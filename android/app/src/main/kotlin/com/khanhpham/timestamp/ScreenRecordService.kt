package com.khanhpham.timestamp

import android.app.Activity
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.hardware.display.DisplayManager
import android.hardware.display.VirtualDisplay
import android.media.MediaRecorder
import android.media.projection.MediaProjection
import android.media.projection.MediaProjectionManager
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.SystemClock
import android.util.DisplayMetrics
import android.view.WindowManager

/**
 * Foreground service that owns the full capture pipeline:
 *   MediaProjection -> VirtualDisplay -> MediaRecorder (H.264 / MP4)
 * and the [TimestampOverlay] millisecond clock that gets composited into the
 * mirrored display, so the timestamp is burned into the saved video.
 */
class ScreenRecordService : Service() {

    private var projection: MediaProjection? = null
    private var virtualDisplay: VirtualDisplay? = null
    private var recorder: MediaRecorder? = null
    private var overlay: TimestampOverlay? = null
    private var floating: FloatingControls? = null
    private var output: RecordingStore.Output? = null
    private val mainHandler = Handler(Looper.getMainLooper())

    private val projectionCallback = object : MediaProjection.Callback() {
        override fun onStop() {
            // The system (or the user via the cast notification) revoked the
            // projection — tear everything down cleanly.
            stopEverything(null)
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_START -> handleStart(intent)
            ACTION_STOP -> stopEverything(null)
            else -> stopSelf()
        }
        return START_NOT_STICKY
    }

    private fun handleStart(intent: Intent) {
        val resultCode = intent.getIntExtra(EXTRA_RESULT_CODE, Activity.RESULT_CANCELED)
        val data: Intent? = if (Build.VERSION.SDK_INT >= 33) {
            intent.getParcelableExtra(EXTRA_DATA, Intent::class.java)
        } else {
            @Suppress("DEPRECATION") intent.getParcelableExtra(EXTRA_DATA)
        }
        val config = RecordConfig.fromIntent(intent)
        startForegroundNotification(config.recordAudio)

        if (data == null) {
            stopEverything("Thiếu dữ liệu cấp quyền quay màn hình.")
            return
        }

        try {
            val mpm = getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
            val proj = mpm.getMediaProjection(resultCode, data)
                ?: throw IllegalStateException("Không tạo được MediaProjection.")
            proj.registerCallback(projectionCallback, mainHandler)
            projection = proj
            startCapture(proj, config)

            startElapsed = SystemClock.elapsedRealtime()
            running = true
            lastError = null
            lastPath = output?.displayUri
        } catch (e: Exception) {
            stopEverything(e.message ?: "Lỗi khởi động ghi hình.")
        }
    }

    private fun startCapture(proj: MediaProjection, config: RecordConfig) {
        val metrics = DisplayMetrics()
        val wm = getSystemService(Context.WINDOW_SERVICE) as WindowManager
        @Suppress("DEPRECATION")
        wm.defaultDisplay.getRealMetrics(metrics)

        val scale = config.scalePercent.coerceIn(20, 100) / 100f
        var width = (metrics.widthPixels * scale).toInt()
        var height = (metrics.heightPixels * scale).toInt()
        // H.264 encoders require even dimensions.
        width -= width % 2
        height -= height % 2
        val dpi = (metrics.densityDpi * scale).toInt().coerceAtLeast(1)

        val out = RecordingStore.create(this)
        output = out

        val rec = if (Build.VERSION.SDK_INT >= 31) MediaRecorder(this) else @Suppress("DEPRECATION") MediaRecorder()
        rec.apply {
            // Audio source (if any) must be set before the video source.
            if (config.recordAudio) setAudioSource(MediaRecorder.AudioSource.MIC)
            setVideoSource(MediaRecorder.VideoSource.SURFACE)
            setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
            if (config.recordAudio) setAudioEncoder(MediaRecorder.AudioEncoder.AAC)
            setVideoEncoder(MediaRecorder.VideoEncoder.H264)
            setVideoEncodingBitRate(config.bitrateKbps.coerceIn(500, 20_000) * 1000)
            setVideoFrameRate(FRAME_RATE)
            setVideoSize(width, height)
            if (config.recordAudio) {
                setAudioEncodingBitRate(128_000)
                setAudioSamplingRate(44_100)
            }
            if (out.fileDescriptor != null) setOutputFile(out.fileDescriptor) else setOutputFile(out.filePath)
            prepare()
        }
        recorder = rec

        virtualDisplay = proj.createVirtualDisplay(
            "Timestamp",
            width,
            height,
            dpi,
            DisplayManager.VIRTUAL_DISPLAY_FLAG_AUTO_MIRROR,
            rec.surface,
            null,
            mainHandler,
        )

        rec.start()

        if (config.needsTextOverlay) {
            overlay = TimestampOverlay(this, config).also { it.show() }
        }
        if (config.floatingButton) {
            floating = FloatingControls(this) { stopEverything(null) }.also { it.show() }
        }
    }

    private fun stopEverything(error: String?) {
        // Recorder first; stop() throws if no frames were written (e.g. user
        // stopped instantly) — swallow it so we still release everything.
        recorder?.let { rec ->
            try {
                rec.stop()
            } catch (_: Exception) {
            }
            try {
                rec.reset()
                rec.release()
            } catch (_: Exception) {
            }
        }
        recorder = null

        virtualDisplay?.release()
        virtualDisplay = null

        projection?.let {
            try {
                it.unregisterCallback(projectionCallback)
            } catch (_: Exception) {
            }
            it.stop()
        }
        projection = null

        overlay?.hide()
        overlay = null

        floating?.hide()
        floating = null

        output?.let {
            RecordingStore.finalize(this, it)
            lastPath = it.displayUri
        }
        output = null

        running = false
        if (error != null) lastError = error

        if (Build.VERSION.SDK_INT >= 24) {
            stopForeground(STOP_FOREGROUND_REMOVE)
        } else {
            @Suppress("DEPRECATION") stopForeground(true)
        }
        stopSelf()
    }

    override fun onDestroy() {
        if (running) stopEverything(null)
        super.onDestroy()
    }

    private fun startForegroundNotification(withMic: Boolean = false) {
        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (nm.getNotificationChannel(CHANNEL_ID) == null) {
            nm.createNotificationChannel(
                NotificationChannel(
                    CHANNEL_ID,
                    getString(R.string.notif_channel_name),
                    NotificationManager.IMPORTANCE_LOW,
                ).apply { setShowBadge(false) },
            )
        }

        val openIntent = PendingIntent.getActivity(
            this,
            0,
            Intent(this, MainActivity::class.java).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP),
            PendingIntent.FLAG_IMMUTABLE,
        )

        // Stop action routes back through MainActivity so the user is returned
        // to the app the instant recording stops.
        val stopIntent = Intent(this, MainActivity::class.java).apply {
            putExtra(MainActivity.EXTRA_FROM_STOP, true)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
        }
        val stopPending = PendingIntent.getActivity(
            this,
            1,
            stopIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
        )

        val notification: Notification = Notification.Builder(this, CHANNEL_ID)
            .setContentTitle("Timestamp")
            .setContentText(getString(R.string.notif_text))
            .setSmallIcon(R.drawable.ic_record)
            .setOngoing(true)
            .setContentIntent(openIntent)
            .addAction(R.drawable.ic_record, getString(R.string.notif_stop_action), stopPending)
            .build()

        if (Build.VERSION.SDK_INT >= 29) {
            var type = ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PROJECTION
            if (withMic && Build.VERSION.SDK_INT >= 30) {
                type = type or ServiceInfo.FOREGROUND_SERVICE_TYPE_MICROPHONE
            }
            startForeground(NOTIF_ID, notification, type)
        } else {
            startForeground(NOTIF_ID, notification)
        }
    }

    companion object {
        private const val ACTION_START = "com.khanhpham.timestamp.START"
        private const val ACTION_STOP = "com.khanhpham.timestamp.STOP"
        private const val EXTRA_RESULT_CODE = "result_code"
        private const val EXTRA_DATA = "data"
        private const val CHANNEL_ID = "fsr_recording"
        private const val NOTIF_ID = 0x5253 // "RS"
        private const val FRAME_RATE = 30

        @Volatile
        private var running = false

        @Volatile
        private var startElapsed = 0L

        @Volatile
        private var lastError: String? = null

        @Volatile
        private var lastPath: String? = null

        fun start(context: Context, resultCode: Int, data: Intent, config: RecordConfig) {
            val intent = Intent(context, ScreenRecordService::class.java).apply {
                action = ACTION_START
                putExtra(EXTRA_RESULT_CODE, resultCode)
                putExtra(EXTRA_DATA, data)
                config.writeTo(this)
            }
            context.startForegroundService(intent)
        }

        fun stop(context: Context) {
            val intent = Intent(context, ScreenRecordService::class.java).apply { action = ACTION_STOP }
            context.startService(intent)
        }

        fun statusMap(): Map<String, Any?> {
            val elapsed = if (running) SystemClock.elapsedRealtime() - startElapsed else 0L
            return mapOf(
                "recording" to running,
                "elapsedMs" to elapsed,
                "lastError" to lastError,
                "lastPath" to lastPath,
            )
        }
    }
}

/** Capture options chosen in the Flutter UI. */
data class RecordConfig(
    val showTimestamp: Boolean,
    val position: String,
    val scalePercent: Int,
    val bitrateKbps: Int,
    val fontSp: Int,
    val timeFormat: String,
    val useUtc: Boolean,
    val showElapsed: Boolean,
    val recordAudio: Boolean,
    val showFps: Boolean,
    val floatingButton: Boolean,
) {
    /** Whether any overlay window (clock/fps) needs to be shown. */
    val needsTextOverlay: Boolean get() = showTimestamp || showFps || showElapsed

    fun writeTo(intent: Intent) {
        intent.putExtra("showTimestamp", showTimestamp)
        intent.putExtra("position", position)
        intent.putExtra("scalePercent", scalePercent)
        intent.putExtra("bitrateKbps", bitrateKbps)
        intent.putExtra("fontSp", fontSp)
        intent.putExtra("timeFormat", timeFormat)
        intent.putExtra("useUtc", useUtc)
        intent.putExtra("showElapsed", showElapsed)
        intent.putExtra("recordAudio", recordAudio)
        intent.putExtra("showFps", showFps)
        intent.putExtra("floatingButton", floatingButton)
    }

    companion object {
        fun fromMap(map: Map<*, *>?): RecordConfig = RecordConfig(
            showTimestamp = (map?.get("showTimestamp") as? Boolean) ?: true,
            position = (map?.get("position") as? String) ?: "top_left",
            scalePercent = (map?.get("scalePercent") as? Int) ?: 50,
            bitrateKbps = (map?.get("bitrateKbps") as? Int) ?: 2500,
            fontSp = (map?.get("fontSp") as? Int) ?: 16,
            timeFormat = (map?.get("timeFormat") as? String) ?: "datetime24",
            useUtc = (map?.get("useUtc") as? Boolean) ?: false,
            showElapsed = (map?.get("showElapsed") as? Boolean) ?: false,
            recordAudio = (map?.get("recordAudio") as? Boolean) ?: false,
            showFps = (map?.get("showFps") as? Boolean) ?: false,
            floatingButton = (map?.get("floatingButton") as? Boolean) ?: true,
        )

        fun fromIntent(intent: Intent): RecordConfig = RecordConfig(
            showTimestamp = intent.getBooleanExtra("showTimestamp", true),
            position = intent.getStringExtra("position") ?: "top_left",
            scalePercent = intent.getIntExtra("scalePercent", 50),
            bitrateKbps = intent.getIntExtra("bitrateKbps", 2500),
            fontSp = intent.getIntExtra("fontSp", 16),
            timeFormat = intent.getStringExtra("timeFormat") ?: "datetime24",
            useUtc = intent.getBooleanExtra("useUtc", false),
            showElapsed = intent.getBooleanExtra("showElapsed", false),
            recordAudio = intent.getBooleanExtra("recordAudio", false),
            showFps = intent.getBooleanExtra("showFps", false),
            floatingButton = intent.getBooleanExtra("floatingButton", true),
        )
    }
}
