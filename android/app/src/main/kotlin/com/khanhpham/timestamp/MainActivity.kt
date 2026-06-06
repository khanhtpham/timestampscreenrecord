package com.khanhpham.timestamp

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.media.projection.MediaProjectionManager
import android.net.Uri
import android.os.Bundle
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Hosts the Flutter UI and bridges it to the native screen-capture pipeline.
 *
 * The heavy lifting (MediaProjection + MediaRecorder + the millisecond overlay
 * clock) lives in [ScreenRecordService]. This activity only:
 *   1. exposes a MethodChannel to the Dart layer,
 *   2. drives the two consent flows (overlay permission + screen-capture intent),
 *   3. starts/stops the foreground service.
 */
class MainActivity : FlutterActivity() {

    private var channel: MethodChannel? = null

    /** Config captured from the Dart "startRecording" call, replayed once the
     *  user grants the screen-capture consent dialog. */
    private var pendingConfig: RecordConfig? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleStopIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleStopIntent(intent)
    }

    /** The notification's "Dừng" action reopens us with this flag so the user
     *  lands back in the app the moment recording stops. */
    private fun handleStopIntent(intent: Intent?) {
        if (intent?.getBooleanExtra(EXTRA_FROM_STOP, false) == true) {
            ScreenRecordService.stop(this)
            intent.removeExtra(EXTRA_FROM_STOP)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).also {
            it.setMethodCallHandler(::onMethodCall)
        }
    }

    private fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "hasOverlayPermission" -> result.success(Settings.canDrawOverlays(this))

            "requestOverlayPermission" -> {
                val intent = Intent(
                    Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                    Uri.parse("package:$packageName"),
                )
                startActivity(intent)
                result.success(null)
            }

            "startRecording" -> {
                val config = RecordConfig.fromMap(call.arguments as? Map<*, *>)
                pendingConfig = config
                // Microphone needs a runtime permission before the capture
                // consent dialog; everything else proceeds straight to capture.
                if (config.recordAudio &&
                    checkSelfPermission(Manifest.permission.RECORD_AUDIO) != PackageManager.PERMISSION_GRANTED
                ) {
                    requestPermissions(arrayOf(Manifest.permission.RECORD_AUDIO), REQUEST_AUDIO)
                } else {
                    launchCapture()
                }
                // The actual start happens in onActivityResult; report that the
                // consent flow was launched so Dart can begin polling status.
                result.success(true)
            }

            "stopRecording" -> {
                ScreenRecordService.stop(this)
                result.success(true)
            }

            "getStatus" -> result.success(ScreenRecordService.statusMap())

            "listRecordings" -> result.success(RecordingStore.list(this))

            "deleteRecording" -> {
                val uri = call.argument<String>("uri")
                result.success(uri != null && RecordingStore.delete(this, uri))
            }

            "openRecording" -> {
                val uri = call.argument<String>("uri")
                result.success(uri != null && openVideo(uri))
            }

            else -> result.notImplemented()
        }
    }

    private fun launchCapture() {
        val mpm = getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
        startActivityForResult(mpm.createScreenCaptureIntent(), REQUEST_CAPTURE)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode != REQUEST_AUDIO) return
        val granted = grantResults.isNotEmpty() &&
            grantResults[0] == PackageManager.PERMISSION_GRANTED
        if (!granted) {
            // Mic denied — fall back to recording video without audio.
            pendingConfig = pendingConfig?.copy(recordAudio = false)
        }
        launchCapture()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != REQUEST_CAPTURE) return

        val config = pendingConfig
        pendingConfig = null
        if (resultCode == Activity.RESULT_OK && data != null && config != null) {
            ScreenRecordService.start(this, resultCode, data, config)
        } else {
            // Localized in the Flutter layer via AppLocalizations.errorConsentDenied.
            channel?.invokeMethod("onError", "consent_denied")
        }
    }

    private fun openVideo(uri: String): Boolean = try {
        val intent = Intent(Intent.ACTION_VIEW).apply {
            setDataAndType(Uri.parse(uri), "video/mp4")
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        startActivity(intent)
        true
    } catch (e: Exception) {
        false
    }

    companion object {
        private const val CHANNEL = "timestamp/recorder"
        private const val REQUEST_CAPTURE = 4711
        private const val REQUEST_AUDIO = 4712

        /** Set by the notification's stop action to bring the app to the front. */
        const val EXTRA_FROM_STOP = "from_stop"
    }
}
