package com.example.platformchannelperformance

object Measuring {

    external fun startMeasuring(name: String, identifier: Long = 1)
    external fun endMeasuring(name: String, identifier: Long = 1)
    external fun printLogs()

    init {
        System.loadLibrary("measuring-lib")
    }
}