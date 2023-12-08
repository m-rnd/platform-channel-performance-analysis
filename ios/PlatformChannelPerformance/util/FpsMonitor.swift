//
//  FpsMonitor.swift
//  PlatformChannelPerformance
//
//  Created by Markus Reinhold on 07.11.23.
//

import Foundation

import SwiftUI
import Metal
import QuartzCore
import os

class FpsMonitor: NSObject {
    private static var displayLink: CADisplayLink?
    private static var experiment: String?
    private static var lastFrameMs: CFAbsoluteTime = 0.0
    
    static var logCategory = OSLog(subsystem: "test.PlatformChannelPerformance", category: "measure")
    
    static func initFlutterChannel(flutterBinaryMessenger: FlutterBinaryMessenger) {
        let channel = FlutterMethodChannel(name: "FpsEvents", binaryMessenger: flutterBinaryMessenger)
        
        channel.setMethodCallHandler { (call: FlutterMethodCall, result: FlutterResult) -> Void in
            switch call.method {
            case "start":
                if let name = call.arguments as? String {
                    start(experimentName: name)
                    result(nil)
                } else {
                    result(FlutterError(code: "bad args", message: nil, details: nil))
                }
            case "stop":
                stop()
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    static func log(_ log: Double) {
        os_log("screenUpdate_%@: %f", log: logCategory, type: .debug, experiment ?? "", log)
    }
    
    static func start(experimentName: String) {
        displayLink = CADisplayLink(target: self, selector: #selector(updateFrameTime))
        displayLink?.add(to: .current, forMode: .common)
        experiment = experimentName
    }
    
    static func stop() {
        displayLink?.invalidate()
        displayLink = nil
        lastFrameMs = 0.0
    }
    
    @objc static private func updateFrameTime(displayLink: CADisplayLink) {
        let currentFrameMs = displayLink.timestamp * 1000
        if (lastFrameMs == 0.0) {
            lastFrameMs = currentFrameMs
            return
        }
        let msBetweenFrames = (currentFrameMs - lastFrameMs)
        log(msBetweenFrames)
        lastFrameMs = currentFrameMs
    }
}
