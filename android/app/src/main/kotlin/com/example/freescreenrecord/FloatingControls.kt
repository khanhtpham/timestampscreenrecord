package com.example.freescreenrecord

import android.content.Context
import android.graphics.Color
import android.graphics.PixelFormat
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import android.view.Gravity
import android.view.MotionEvent
import android.view.WindowManager
import android.widget.TextView
import java.util.Locale
import kotlin.math.abs

/**
 * A small draggable "Stop" pill drawn as a system overlay so the user can stop
 * recording from anywhere — without pulling the notification shade or returning
 * to the app. Shows the elapsed time; tapping it stops the recording.
 */
class FloatingControls(
    private val context: Context,
    private val onStop: () -> Unit,
) {
    private val windowManager =
        context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
    private val handler = Handler(Looper.getMainLooper())
    private var added = false
    private var startElapsedMs = 0L

    private val density = context.resources.displayMetrics.density
    private fun dp(v: Int) = (v * density).toInt()

    private val pill = TextView(context).apply {
        setTextColor(Color.WHITE)
        textSize = 14f
        setPadding(dp(16), dp(10), dp(16), dp(10))
        background = GradientDrawable().apply {
            shape = GradientDrawable.RECTANGLE
            cornerRadius = dp(28).toFloat()
            setColor(Color.parseColor("#FF3B5C"))
        }
        text = "■ 00:00"
    }

    private val params = WindowManager.LayoutParams(
        WindowManager.LayoutParams.WRAP_CONTENT,
        WindowManager.LayoutParams.WRAP_CONTENT,
        if (Build.VERSION.SDK_INT >= 26) {
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        } else {
            @Suppress("DEPRECATION") WindowManager.LayoutParams.TYPE_PHONE
        },
        WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
            WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN,
        PixelFormat.TRANSLUCENT,
    ).apply {
        gravity = Gravity.TOP or Gravity.START
        x = dp(16)
        y = dp(120)
    }

    private val tick = object : Runnable {
        override fun run() {
            if (!added) return
            pill.text = "■ ${formatElapsed(SystemClock.elapsedRealtime() - startElapsedMs)}"
            handler.postDelayed(this, 250)
        }
    }

    fun show() {
        if (added) return
        startElapsedMs = SystemClock.elapsedRealtime()
        attachTouch()
        windowManager.addView(pill, params)
        added = true
        handler.post(tick)
    }

    fun hide() {
        if (!added) return
        added = false
        handler.removeCallbacks(tick)
        try {
            windowManager.removeView(pill)
        } catch (_: Exception) {
        }
    }

    private fun attachTouch() {
        var downX = 0f
        var downY = 0f
        var startX = 0
        var startY = 0
        var dragging = false
        val slop = dp(8)

        pill.setOnTouchListener { _, event ->
            when (event.action) {
                MotionEvent.ACTION_DOWN -> {
                    downX = event.rawX
                    downY = event.rawY
                    startX = params.x
                    startY = params.y
                    dragging = false
                    true
                }
                MotionEvent.ACTION_MOVE -> {
                    val dx = (event.rawX - downX).toInt()
                    val dy = (event.rawY - downY).toInt()
                    if (!dragging && (abs(dx) > slop || abs(dy) > slop)) dragging = true
                    if (dragging) {
                        params.x = startX + dx
                        params.y = startY + dy
                        windowManager.updateViewLayout(pill, params)
                    }
                    true
                }
                MotionEvent.ACTION_UP -> {
                    if (!dragging) onStop()
                    true
                }
                else -> false
            }
        }
    }

    private fun formatElapsed(ms: Long): String {
        val clamped = if (ms < 0) 0 else ms
        val minutes = clamped / 60000
        val seconds = (clamped / 1000) % 60
        return String.format(Locale.US, "%02d:%02d", minutes, seconds)
    }
}
