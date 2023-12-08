package com.example.platformchannelperformance.infinitescroll

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class GetItemsUseCaseFlutterWrapper(binaryMessenger: BinaryMessenger) :
    EventChannel.StreamHandler,
    MethodChannel.MethodCallHandler {

    private var getItemsUseCase: GetItemsUseCase? = null
    private var coroutineScope: CoroutineScope? = null

    init {
        EventChannel(
            binaryMessenger,
            "scrollItemStream"
        ).setStreamHandler(this@GetItemsUseCaseFlutterWrapper)
        MethodChannel(
            binaryMessenger,
            "scrollItemRequest"
        ).setMethodCallHandler(this@GetItemsUseCaseFlutterWrapper)
    }

    // EventChannel
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        coroutineScope = CoroutineScope(SupervisorJob() + Dispatchers.Default)
        getItemsUseCase = GetItemsUseCase().also { useCase ->
            useCase.loadNewItems(PAGE_PRELOAD_COUNT)
            coroutineScope?.launch {
                useCase.items.collect {
                    withContext(Dispatchers.Main) {
                        events?.success(it.toFlutter())
                    }
                }
            }
        }
    }

    // EventChannel
    override fun onCancel(arguments: Any?) {
        coroutineScope?.cancel()
        coroutineScope = null
        getItemsUseCase = null
    }

    // MethodChannel
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "loadContent" -> when (val targetPage = call.arguments as? Int) {
                null -> result.error("bad args", null, null)
                else -> {
                    getItemsUseCase?.loadNewItems(targetPage)?.also {
                        result.success(null)
                    } ?: result.error("not instantiated", null, null)
                }
            }

            else -> result.notImplemented()
        }
    }

    // converter functions

    private fun List<Item>.toFlutter() = map { it.toFlutter() }

    private fun Item.toFlutter() = buildList<Any> {
        add(id)
        add(header)
    }
}



