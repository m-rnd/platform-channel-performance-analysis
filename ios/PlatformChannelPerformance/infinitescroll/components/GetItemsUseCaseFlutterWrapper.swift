//
//  GetItemsUseCaseFlutterWrapper.swift
//  PlatformChannelPerformance
//
//  Created by Markus Reinhold on 09.11.23.
//

import Foundation
import Combine

class GetItemsUseCaseFlutterWrapper: NSObject, FlutterStreamHandler {
    private var getItemsUseCase: GetItemsUseCase?
    
    private var subscription: AnyCancellable?
    
    init(flutterBinaryMessenger: FlutterBinaryMessenger) {
        super.init()
        FlutterEventChannel(name: "scrollItemStream", binaryMessenger: flutterBinaryMessenger).setStreamHandler(self)
        FlutterMethodChannel(name: "scrollItemRequest", binaryMessenger: flutterBinaryMessenger).setMethodCallHandler(self.onMethodCall)
    }
    
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        getItemsUseCase = GetItemsUseCase()
        getItemsUseCase?.loadContent(targetPage: PAGE_PRELOAD_COUNT)
        
        subscription = getItemsUseCase?.$items
            .sink(receiveValue: { items in
                events(items.toFlutter())
            })
        
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        subscription?.cancel()
        getItemsUseCase = nil
        return nil
    }
    
    func onMethodCall(call: FlutterMethodCall, result: FlutterResult) {
        switch call.method {
        case "loadContent":
            if let targetPage = call.arguments as? Int {
                getItemsUseCase?.loadContent(targetPage: targetPage)
                result(nil)
            } else {
                result(FlutterError(code: "bad args", message: nil, details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}


extension Array where Element == ScrollItem {
    func toFlutter() -> [Any] {
        return map { $0.toFlutter() }
    }
}

extension ScrollItem {
    func toFlutter() -> [Any] {
        var flutterList = [Any]()
        flutterList.append(id)
        flutterList.append(header)
        return flutterList
    }
}
