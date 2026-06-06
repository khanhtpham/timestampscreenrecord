package com.khanhpham.timestamp

import android.content.Context
import android.graphics.Color
import android.graphics.PixelFormat
import android.graphics.Typeface
import android.os.Build
import android.os.SystemClock
import android.view.Choreographer
import android.view.Gravity
import android.view.WindowManager
import android.widget.TextView
import java.time.LocalDateTime
import java.time.ZoneOffset
import java.time.format.DateTimeFormatter
import java.util.Locale

/**
 * A system overlay window (TYPE_APPLICATION_OVERLAY) that paints the current
 * time with millisecond precision in the user-chosen format. Because
 * MediaProjection mirrors the fully composited display, this overlay is captured
 * into the recording on top of whatever app is on screen.
 *
 * Refreshed every display frame via [Choreographer] (~60 Hz) so the millisecond
 * digits visibly tick.
 */
class TimestampOverlay(
    private val context: Context,
    private val config: RecordConfig,
) {

    private val isUnix = config.timeFormat == "unix"

    private val formatter: DateTimeFormatter? =
        if (isUnix) null else DateTimeFormatter.ofPattern(patternFor(config.timeFormat), Locale.US)

    private val windowManager =
        context.getSystemService(Context.WINDOW_SERVICE) as WindowManager

    private val textView = TextView(context).apply {
        typeface = Typeface.MONOSPACE
        setTextColor(Color.WHITE)
        textSize = config.fontSp.toFloat()
        setBackgroundColor(Color.argb(140, 0, 0, 0))
        val padH = (config.fontSp * 0.75f).toInt()
        val padV = (config.fontSp * 0.35f).toInt()
        setPadding(padH, padV, padH, padV)
        setShadowLayer(4f, 0f, 0f, Color.BLACK)
    }

    private var added = false
    private var startElapsedMs = 0L

    // Rolling 1-second FPS counter driven by the Choreographer.
    private var fps = 0
    private var frameWindow = 0
    private var lastFpsNanos = 0L

    private val frameCallback = object : Choreographer.FrameCallback {
        override fun doFrame(frameTimeNanos: Long) {
            if (!added) return
            if (lastFpsNanos == 0L) lastFpsNanos = frameTimeNanos
            frameWindow++
            if (frameTimeNanos - lastFpsNanos >= 1_000_000_000L) {
                fps = frameWindow
                frameWindow = 0
                lastFpsNanos = frameTimeNanos
            }
            textView.text = buildText()
            Choreographer.getInstance().postFrameCallback(this)
        }
    }

    private fun buildText(): String {
        val parts = ArrayList<String>(3)
        if (config.showTimestamp) parts.add(timestampString())
        if (config.showFps) parts.add("${fps}fps")
        if (config.showElapsed) {
            parts.add("+${formatElapsed(SystemClock.elapsedRealtime() - startElapsedMs)}")
        }
        return parts.joinToString("  ")
    }

    private fun timestampString(): String {
        if (isUnix) return System.currentTimeMillis().toString()
        val now = if (config.useUtc) {
            LocalDateTime.now(ZoneOffset.UTC)
        } else {
            LocalDateTime.now()
        }
        val stamp = now.format(formatter)
        return if (config.useUtc) "$stamp UTC" else stamp
    }

    private fun formatElapsed(ms: Long): String {
        val clamped = if (ms < 0) 0 else ms
        val minutes = clamped / 60000
        val seconds = (clamped / 1000) % 60
        val millis = clamped % 1000
        return String.format(Locale.US, "%02d:%02d.%03d", minutes, seconds, millis)
    }

    fun show() {
        if (added) return
        startElapsedMs = SystemClock.elapsedRealtime()
        val type = if (Build.VERSION.SDK_INT >= 26) {
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        } else {
            @Suppress("DEPRECATION") WindowManager.LayoutParams.TYPE_PHONE
        }
        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            type,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE or
                WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN,
            PixelFormat.TRANSLUCENT,
        ).apply {
            gravity = gravityFor(config.position)
            val margin = 24
            x = margin
            y = margin
        }

        windowManager.addView(textView, params)
        added = true
        Choreographer.getInstance().postFrameCallback(frameCallback)
    }

    fun hide() {
        if (!added) return
        added = false
        Choreographer.getInstance().removeFrameCallback(frameCallback)
        try {
            windowManager.removeView(textView)
        } catch (_: Exception) {
        }
    }

    private fun gravityFor(position: String): Int = when (position) {
        "top_right" -> Gravity.TOP or Gravity.END
        "top_center" -> Gravity.TOP or Gravity.CENTER_HORIZONTAL
        "bottom_left" -> Gravity.BOTTOM or Gravity.START
        "bottom_right" -> Gravity.BOTTOM or Gravity.END
        "bottom_center" -> Gravity.BOTTOM or Gravity.CENTER_HORIZONTAL
        else -> Gravity.TOP or Gravity.START
    }

    private fun patternFor(format: String): String = when (format) {
        "time24" -> "HH:mm:ss.SSS"
        "datetime12" -> "yyyy-MM-dd hh:mm:ss.SSS a"
        "time12" -> "hh:mm:ss.SSS a"
        else -> "yyyy-MM-dd HH:mm:ss.SSS" // datetime24
    }
}
