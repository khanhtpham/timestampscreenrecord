package com.example.freescreenrecord

import android.content.ContentUris
import android.content.ContentValues
import android.content.Context
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.os.ParcelFileDescriptor
import android.provider.MediaStore
import java.io.File
import java.io.FileDescriptor
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * Persists recordings to the public Movies/FreeScreenRecord collection.
 *
 * On Android 10+ (scoped storage) it uses MediaStore with an IS_PENDING flag so
 * the file is invisible to the gallery until [finalize] commits it. On older
 * releases it falls back to the app-specific external Movies directory, which
 * needs no storage permission.
 */
object RecordingStore {

    private const val FOLDER = "FreeScreenRecord"
    private val RELATIVE_PATH = "${Environment.DIRECTORY_MOVIES}/$FOLDER"

    /** Handle to an in-progress recording target. */
    class Output(
        val uri: Uri?,
        val file: File?,
        private val pfd: ParcelFileDescriptor?,
        val displayUri: String,
    ) {
        val fileDescriptor: FileDescriptor? get() = pfd?.fileDescriptor
        val filePath: String? get() = file?.absolutePath

        internal fun closeDescriptor() {
            try {
                pfd?.close()
            } catch (_: Exception) {
            }
        }
    }

    private fun newName(): String {
        val stamp = SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US).format(Date())
        return "FSR_$stamp.mp4"
    }

    fun create(context: Context): Output {
        val name = newName()
        return if (Build.VERSION.SDK_INT >= 29) {
            val values = ContentValues().apply {
                put(MediaStore.Video.Media.DISPLAY_NAME, name)
                put(MediaStore.Video.Media.MIME_TYPE, "video/mp4")
                put(MediaStore.Video.Media.RELATIVE_PATH, RELATIVE_PATH)
                put(MediaStore.Video.Media.IS_PENDING, 1)
            }
            val collection = MediaStore.Video.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
            val uri = context.contentResolver.insert(collection, values)
                ?: throw IllegalStateException("Không tạo được file trong thư viện.")
            val pfd = context.contentResolver.openFileDescriptor(uri, "rw")
                ?: throw IllegalStateException("Không mở được file để ghi.")
            Output(uri = uri, file = null, pfd = pfd, displayUri = uri.toString())
        } else {
            val dir = File(context.getExternalFilesDir(Environment.DIRECTORY_MOVIES), FOLDER)
            if (!dir.exists()) dir.mkdirs()
            val file = File(dir, name)
            Output(uri = null, file = file, pfd = null, displayUri = file.absolutePath)
        }
    }

    fun finalize(context: Context, output: Output) {
        output.closeDescriptor()
        if (Build.VERSION.SDK_INT >= 29 && output.uri != null) {
            val values = ContentValues().apply { put(MediaStore.Video.Media.IS_PENDING, 0) }
            try {
                context.contentResolver.update(output.uri, values, null, null)
            } catch (_: Exception) {
            }
        }
    }

    fun list(context: Context): List<Map<String, Any?>> {
        if (Build.VERSION.SDK_INT >= 29) {
            val result = mutableListOf<Map<String, Any?>>()
            val projection = arrayOf(
                MediaStore.Video.Media._ID,
                MediaStore.Video.Media.DISPLAY_NAME,
                MediaStore.Video.Media.SIZE,
                MediaStore.Video.Media.DATE_ADDED,
            )
            val collection = MediaStore.Video.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
            val selection = "${MediaStore.Video.Media.RELATIVE_PATH} LIKE ?"
            val args = arrayOf("%$FOLDER%")
            val sort = "${MediaStore.Video.Media.DATE_ADDED} DESC"
            context.contentResolver.query(collection, projection, selection, args, sort)?.use { c ->
                val idCol = c.getColumnIndexOrThrow(MediaStore.Video.Media._ID)
                val nameCol = c.getColumnIndexOrThrow(MediaStore.Video.Media.DISPLAY_NAME)
                val sizeCol = c.getColumnIndexOrThrow(MediaStore.Video.Media.SIZE)
                val dateCol = c.getColumnIndexOrThrow(MediaStore.Video.Media.DATE_ADDED)
                while (c.moveToNext()) {
                    val id = c.getLong(idCol)
                    val uri = ContentUris.withAppendedId(collection, id)
                    result.add(
                        mapOf(
                            "name" to c.getString(nameCol),
                            "uri" to uri.toString(),
                            "sizeBytes" to c.getLong(sizeCol),
                            "dateMillis" to c.getLong(dateCol) * 1000,
                        ),
                    )
                }
            }
            return result
        }

        val dir = File(context.getExternalFilesDir(Environment.DIRECTORY_MOVIES), FOLDER)
        val files = dir.listFiles { f -> f.extension.equals("mp4", ignoreCase = true) } ?: emptyArray()
        return files.sortedByDescending { it.lastModified() }.map {
            mapOf(
                "name" to it.name,
                "uri" to it.absolutePath,
                "sizeBytes" to it.length(),
                "dateMillis" to it.lastModified(),
            )
        }
    }

    fun delete(context: Context, uri: String): Boolean = try {
        if (Build.VERSION.SDK_INT >= 29 && uri.startsWith("content://")) {
            context.contentResolver.delete(Uri.parse(uri), null, null) > 0
        } else {
            File(uri).delete()
        }
    } catch (e: Exception) {
        false
    }
}
