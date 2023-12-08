//
//  FlutterDependencies.swift
//  PlatformChannelPerformance
//
//  Created by Markus Reinhold on 24.05.23.
//

import SwiftUI
import Flutter
// The following library connects plugins with iOS platform code to this app.
import FlutterPluginRegistrant

class FlutterDependencies: ObservableObject {
    let flutterEngine = FlutterEngine(name: "platform_channel_performance_tests")
    
    init(){
        flutterEngine.run()
        FpsMonitor.initFlutterChannel(flutterBinaryMessenger: flutterEngine.binaryMessenger)
        GetItemsUseCaseFlutterWrapper(flutterBinaryMessenger: flutterEngine.binaryMessenger)
        
        // Connects plugins with iOS platform code to this app.
        GeneratedPluginRegistrant.register(with: self.flutterEngine);
        ClarkePluginRegistrant.register(with: self.flutterEngine);
    }
    
    func createBasicMessageChannelStringCodec() -> FlutterBasicMessageChannel {
        return FlutterBasicMessageChannel(name: "BasicMessageChannelString", binaryMessenger: flutterEngine.binaryMessenger, codec: FlutterStringCodec.sharedInstance())
    }
    
    func createBasicMessageChannelSMCodec() -> FlutterBasicMessageChannel {
        return FlutterBasicMessageChannel(name: "BasicMessageChannelSM", binaryMessenger: flutterEngine.binaryMessenger, codec: FlutterStandardMessageCodec.sharedInstance())
    }
    
    func createBasicMessageChannelBinaryCodec() -> FlutterBasicMessageChannel {
        return FlutterBasicMessageChannel(name: "BasicMessageChannelBinary", binaryMessenger: flutterEngine.binaryMessenger, codec: FlutterBinaryCodec.sharedInstance())
    }
}
