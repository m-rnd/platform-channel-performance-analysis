package com.example.macrobenchmark

import android.util.Log
import androidx.benchmark.macro.FrameTimingMetric
import androidx.benchmark.macro.MacrobenchmarkScope
import androidx.benchmark.macro.StartupMode
import androidx.benchmark.macro.junit4.MacrobenchmarkRule
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.uiautomator.By
import androidx.test.uiautomator.Direction
import androidx.test.uiautomator.UiDevice
import androidx.test.uiautomator.Until
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

private const val ITERATION_COUNT = 1

@RunWith(AndroidJUnit4::class)
class ScrollBenchmark {
    private val packageName = "com.example.platformchannelperformance"

    @get:Rule
    val benchmarkRule = MacrobenchmarkRule()

    private fun measure(testName: String, setupBlock: MacrobenchmarkScope.() -> Unit) = benchmarkRule.measureRepeated(
        packageName = packageName,
        metrics = listOf(FrameTimingMetric()),
        iterations = ITERATION_COUNT,
        startupMode = StartupMode.COLD,
        setupBlock = {
            pressHome()
            startActivityAndWait()
            setupBlock() // navigate to scrollable view
        },
        measureBlock = {
            device.wait(Until.findObject(By.scrollable(true)), 1000L)
            val scrollableObject = device.findObject(By.scrollable(true))
            repeat(10) {
                Log.i("measure", "screenUpdate_$testName: -20.0")
                scrollableObject.fling(Direction.DOWN)
            }
        }
    )

    @Test
    fun T1aScroll() = measure("T1a") {
        device.findObject(By.text("native scroll")).click()
    }

    @Test
    fun T1bInfiniteScroll() = measure("T1b") {
        device.findObject(By.text("native infinite scroll")).click()
    }


    @Test
    fun T3aFlutterScroll() = measure("T3a") {
        device.findObject(By.text("launch flutter view")).click()
        device.findObjects(By.clickable(true))[2].click()
    }

    @Test
    fun T3bFlutterInfiniteScroll() = measure("T3b") {
        device.findObject(By.text("launch flutter view")).click()
        device.findObjects(By.clickable(true))[4].click()
    }

    @Test
    fun T5aFlutterScrollPC() = measure("T5a") {
        device.findObject(By.text("launch flutter view")).click()
        device.findObjects(By.clickable(true))[3].click()
    }

    @Test
    fun T5bFlutterInfiniteScrollPC() = measure("T5b") {
        device.findObject(By.text("launch flutter view")).click()
        device.findObjects(By.clickable(true))[5].click()
    }
}