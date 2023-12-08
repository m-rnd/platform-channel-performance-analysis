package com.example.platformchannelperformance

import android.content.Context
import android.os.Message
import com.example.platformchannelperformance.clarke.MessagingTimingPlugin
import com.example.platformchannelperformance.infinitescroll.GetItemsUseCaseFlutterWrapper
import com.example.platformchannelperformance.measuring.FpsMonitor
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryCodec
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCodec
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.common.StringCodec
import java.nio.ByteBuffer

class FlutterDependencies(context: Context) {

    companion object {
        const val ENGINE_ID = "platform_channel_performance_tests"
    }

    private var engine: FlutterEngine

    // https://docs.flutter.dev/add-to-app/android/add-flutter-screen?tab=prewarm-engine-kotlin-tab
    init {
        engine = FlutterEngine(context)

        // Start executing Dart code to pre-warm the FlutterEngine.
        engine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )

        FlutterEngineCache
            .getInstance()
            .put(ENGINE_ID, engine)

        with(engine.dartExecutor.binaryMessenger) {
            GetItemsUseCaseFlutterWrapper(this)
            FpsMonitor.initFlutterChannel(this)
        }
        engine.plugins.add(MessagingTimingPlugin())
    }

    fun createBasicMessageChannelSMCodec() =
        BasicMessageChannel(
            engine.dartExecutor.binaryMessenger,
            "BasicMessageChannelSM",
            StandardMessageCodec.INSTANCE
        )

    fun createBasicMessageChannelStringCodec() =
        BasicMessageChannel(
            engine.dartExecutor.binaryMessenger,
            "BasicMessageChannelString",
            StringCodec.INSTANCE
        )

    fun createBasicMessageChannelBinaryCodec() =
        BasicMessageChannel(
            engine.dartExecutor.binaryMessenger,
            "BasicMessageChannelBinary",
            BinaryCodec.INSTANCE
        )

    fun createBasicMessageChannelBinaryCodecDirect() =
        BasicMessageChannel(
            engine.dartExecutor.binaryMessenger,
            "BasicMessageChannelBinary",
            BinaryCodec.INSTANCE_DIRECT
        )
}