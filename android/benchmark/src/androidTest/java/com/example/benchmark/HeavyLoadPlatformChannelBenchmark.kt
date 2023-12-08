package com.example.benchmark

import androidx.test.ext.junit.rules.ActivityScenarioRule
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.example.platformchannelperformance.BenchmarkActivity
import com.example.platformchannelperformance.FlutterDependencies
import com.example.platformchannelperformance.Measuring
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import java.nio.ByteBuffer

@RunWith(AndroidJUnit4::class)
class HeavyLoadPlatformChannelBenchmark {
    @get:Rule
    val activityRule = ActivityScenarioRule(BenchmarkActivity::class.java)

    val MeasureIterations = 10000

    private inline fun measureWithLogs(
        name: String,
        crossinline measureBlock: () -> Unit
    ) {
        for (i in 0 until MeasureIterations) {
            Measuring.startMeasuring("heavyLoadBenchmark_$name")
            measureBlock()
            Measuring.endMeasuring("heavyLoadBenchmark_$name")
        }
        Measuring.printLogs()
    }

    private fun sendWithStandardMessageCodec(
        stringLength: Int
    ) {
        activityRule.scenario.onActivity { activity ->
            val flutter = FlutterDependencies(activity)
            val channel = flutter.createBasicMessageChannelSMCodec()
            val longString = "a".repeat(stringLength)

            measureWithLogs("T1a${"%06d".format(stringLength)}") {
                channel.send(longString)
            }
        }
    }

    private fun sendWithStringCodec(
        stringLength: Int
    ) {
        activityRule.scenario.onActivity { activity ->
            val flutter = FlutterDependencies(activity)
            val channel = flutter.createBasicMessageChannelStringCodec()
            val longString = "a".repeat(stringLength)

            measureWithLogs("T1b${"%06d".format(stringLength)}") {
                channel.send(longString)
            }
        }
    }

    private fun sendWithBinaryCodec(
        stringLength: Int
    ) {
        activityRule.scenario.onActivity { activity ->
            val flutter = FlutterDependencies(activity)
            val channel = flutter.createBasicMessageChannelBinaryCodec()
            val longString = "a".repeat(stringLength)
            val longStringAsBytes = longString.toByteArray()

            val buffer = ByteBuffer.allocateDirect(longStringAsBytes.size)
            buffer.put(longStringAsBytes)

            measureWithLogs("T1c${"%06d".format(stringLength)}") {
                channel.send(buffer)
            }
        }
    }

    private fun sendWithBinaryCodecDirect(
        stringLength: Int
    ) {
        activityRule.scenario.onActivity { activity ->
            val flutter = FlutterDependencies(activity)
            val channel = flutter.createBasicMessageChannelBinaryCodecDirect()
            val longString = "a".repeat(stringLength)
            val longStringAsBytes = longString.toByteArray()

            val buffer = ByteBuffer.allocateDirect(longStringAsBytes.size)
            buffer.put(longStringAsBytes)

            measureWithLogs("T1d${"%06d".format(stringLength)}") {
                channel.send(buffer)
            }
        }
    }

    private fun sendHashMap(
        size: Int
    ) {
        activityRule.scenario.onActivity { activity ->
            val flutter = FlutterDependencies(activity)
            val channel = flutter.createBasicMessageChannelSMCodec()
            val hashMap = HashMap<String, String>(size)

            for (i in 0 until size) {
                hashMap["Key $i"] = "Value $i"
            }

            measureWithLogs("T3x${size}") {
                channel.send(hashMap)
            }
        }
    }

    @Test
    fun T1a10000() = sendWithStandardMessageCodec(10000)

    @Test
    fun T1a20000() = sendWithStandardMessageCodec(20000)

    @Test
    fun T1a30000() = sendWithStandardMessageCodec(30000)

    @Test
    fun T1a40000() = sendWithStandardMessageCodec(40000)

    @Test
    fun T1a50000() = sendWithStandardMessageCodec(50000)

    @Test
    fun T1a60000() = sendWithStandardMessageCodec(60000)

    @Test
    fun T1a70000() = sendWithStandardMessageCodec(70000)

    @Test
    fun T1a80000() = sendWithStandardMessageCodec(80000)

    @Test
    fun T1a90000() = sendWithStandardMessageCodec(90000)

    @Test
    fun T1a100000() = sendWithStandardMessageCodec(100000)

    @Test
    fun T1b10000() = sendWithStringCodec(10000)

    @Test
    fun T1b20000() = sendWithStringCodec(20000)

    @Test
    fun T1b30000() = sendWithStringCodec(30000)

    @Test
    fun T1b40000() = sendWithStringCodec(40000)

    @Test
    fun T1b50000() = sendWithStringCodec(50000)

    @Test
    fun T1b60000() = sendWithStringCodec(60000)

    @Test
    fun T1b70000() = sendWithStringCodec(70000)

    @Test
    fun T1b80000() = sendWithStringCodec(80000)

    @Test
    fun T1b90000() = sendWithStringCodec(90000)

    @Test
    fun T1b100000() = sendWithStringCodec(100000)

    @Test
    fun T1c10000() = sendWithBinaryCodec(10000)

    @Test
    fun T1c20000() = sendWithBinaryCodec(20000)

    @Test
    fun T1c30000() = sendWithBinaryCodec(30000)

    @Test
    fun T1c40000() = sendWithBinaryCodec(40000)

    @Test
    fun T1c50000() = sendWithBinaryCodec(50000)

    @Test
    fun T1c60000() = sendWithBinaryCodec(60000)

    @Test
    fun T1c70000() = sendWithBinaryCodec(70000)

    @Test
    fun T1c80000() = sendWithBinaryCodec(80000)

    @Test
    fun T1c90000() = sendWithBinaryCodec(90000)

    @Test
    fun T1c100000() = sendWithBinaryCodec(100000)

    @Test
    fun T1d10000() = sendWithBinaryCodecDirect(10000)

    @Test
    fun T1d20000() = sendWithBinaryCodecDirect(20000)

    @Test
    fun T1d30000() = sendWithBinaryCodecDirect(30000)

    @Test
    fun T1d40000() = sendWithBinaryCodecDirect(40000)

    @Test
    fun T1d50000() = sendWithBinaryCodecDirect(50000)

    @Test
    fun T1d60000() = sendWithBinaryCodecDirect(60000)

    @Test
    fun T1d70000() = sendWithBinaryCodecDirect(70000)

    @Test
    fun T1d80000() = sendWithBinaryCodecDirect(80000)

    @Test
    fun T1d90000() = sendWithBinaryCodecDirect(90000)

    @Test
    fun T1d100000() = sendWithBinaryCodecDirect(100000)

//    @Test
//    fun T3x1000() = sendHashMap(5000)
//    @Test
//    fun T3x2000() = sendHashMap(10000)
//    @Test
//    fun T3x3000() = sendHashMap(15000)
//    @Test
//    fun T3x4000() = sendHashMap(20000)
//    @Test
//    fun T3x5000() = sendHashMap(25000)
//    @Test
//    fun T3x6000() = sendHashMap(30000)
//    @Test
//    fun T3x7000() = sendHashMap(35000)
//    @Test
//    fun T3x8000() = sendHashMap(40000)
//    @Test
//    fun T3x9000() = sendHashMap(45000)
//    @Test
//    fun T3x10000() = sendHashMap(50000)
}