package com.example.platformchannelperformance.measuring

import android.util.Log
import android.view.Choreographer
import android.view.Choreographer.FrameCallback
import android.view.Choreographer.getInstance
import com.example.benchmarkable.BuildConfig
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

// https://github.com/wasabeef/Takt/blob/master/takt/src/main/java/jp/wasabeef/takt/Metronome.java
object FpsMonitor : FrameCallback {
    private val choreographer: Choreographer by lazy { getInstance() }
    private var lastFrameMs = 0.0
    private var experiment: String? = null


    fun initFlutterChannel(binaryMessenger: BinaryMessenger) {
        MethodChannel(binaryMessenger, "FpsEvents").setMethodCallHandler { call, result ->
            when (call.method) {
                "start" -> when (val name = call.arguments as? String) {
                    null -> result.error("bad args", null, null)
                    else -> {
                        start(name)
                        result.success(null)
                    }
                }

                "stop" -> {
                    stop()
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }
    }

    fun log(measurement: Double) {
        if (experiment == null) return
        Log.i("measure", "screenUpdate_$experiment: $measurement")
    }

    fun start(experimentName: String) {
        if (BuildConfig.DEBUG) return
        experiment = experimentName
        choreographer.postFrameCallback(this)
    }

    fun stop() {
        if (BuildConfig.DEBUG) return
        choreographer.removeFrameCallback(this)
        lastFrameMs = 0.0
        experiment = null
    }

    override fun doFrame(frameTimeNanos: Long) {
        val frameTimeMillis: Double = frameTimeNanos / 1000.0 / 1000.0
        if (lastFrameMs == 0.0) {
            lastFrameMs = frameTimeMillis
            choreographer.postFrameCallback(this)
            return
        }

        val msBetweenFrames = frameTimeMillis - lastFrameMs
        log(msBetweenFrames)
        lastFrameMs = frameTimeMillis
        choreographer.postFrameCallback(this)
    }
}