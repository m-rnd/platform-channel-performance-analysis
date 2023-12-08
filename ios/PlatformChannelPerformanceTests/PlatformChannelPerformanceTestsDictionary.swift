//
//  PlatformChannelPerformanceTestsHashMap.swift
//  PlatformChannelPerformanceTests
//
//  Created by Markus Reinhold on 28.10.23.
//

import Foundation
import XCTest
@testable import PlatformChannelPerformance

final class PlatformChannelPerformanceTestsDictionary: XCTestCase {
   
    var flutter: FlutterDependencies!
    let measureOptions = XCTMeasureOptions()

    override func setUpWithError() throws {
        measureOptions.iterationCount = 10000
        flutter = FlutterDependencies()
    }

    override func tearDownWithError() throws {
        MeasuringWrapper.printLogs()
    }
    
    func sendDict(_ dictLength: Int) {
        let name = "heavyLoadBenchmark_T4x\(dictLength)"
        let channel = flutter.createBasicMessageChannelSMCodec()
        var dict: [String:String] = Dictionary(minimumCapacity: dictLength)
        
        for i in 0..<dictLength {
            dict["Key \(i)"] = "Value \(i)"
        }
        
        self.measure(options: measureOptions) {
            MeasuringWrapper.startMeasuring(name, 0)
            channel.sendMessage(dict)
            MeasuringWrapper.endMeasuring(name, 0)
        }
    }
    
    func testT3_3000() throws { sendDict(5000) }
    func testT3_6000() throws { sendDict(10000) }
    func testT3_9000() throws { sendDict(15000) }
    func testT3_12000() throws { sendDict(20000) }
    func testT3_15000() throws { sendDict(25000) }
    func testT3_18000() throws { sendDict(30000) }
    func testT3_21000() throws { sendDict(35000) }
    func testT3_24000() throws { sendDict(40000) }
    func testT3_27000() throws { sendDict(45000) }
    func testT3_30000() throws { sendDict(50000) }
}

