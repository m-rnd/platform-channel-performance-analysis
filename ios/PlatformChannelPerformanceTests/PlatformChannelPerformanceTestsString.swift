//
//  PlatformChannelPerformanceTests.swift
//  PlatformChannelPerformanceTests
//
//  Created by Markus Reinhold on 23.05.23.
//

import XCTest
@testable import PlatformChannelPerformance

final class PlatformChannelPerformanceTestsString: XCTestCase {
   
    var flutter: FlutterDependencies!
    let measureOptions = XCTMeasureOptions()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        measureOptions.iterationCount = 10000
        flutter = FlutterDependencies()
        
    }

    override func tearDownWithError() throws {
        MeasuringWrapper.printLogs()
    }
    
    func sendWithStandardMessageCodec(_ stringLength: Int) {
        let channel = flutter.createBasicMessageChannelSMCodec()
        let longString = String(repeating: "a", count: stringLength)
        let name = "heavyLoadBenchmark_T2a\(stringLength)"
        
        self.measure(options: measureOptions) {
            var i = 0
            MeasuringWrapper.startMeasuring(name, i)
            channel.sendMessage(longString)
            MeasuringWrapper.endMeasuring(name, i)
            i += 1
        }
    }
    
    func sendWithStringCodec(_ stringLength: Int) {
        let channel = flutter.createBasicMessageChannelStringCodec()
        let longString = String(repeating: "a", count: stringLength)
        let name = "heavyLoadBenchmark_T2b\(stringLength)"
        
        self.measure(options: measureOptions) {
            var i = 0
            MeasuringWrapper.startMeasuring(name, i)
            channel.sendMessage(longString)
            MeasuringWrapper.endMeasuring(name, i)
            i += 1
        }
    }
    
    func sendWithBinaryCodec(_ stringLength: Int) throws {
        let channel = flutter.createBasicMessageChannelBinaryCodec()
        let longString = String(repeating: "a", count: stringLength)
        let name = "heavyLoadBenchmark_T2c\(stringLength)"
        let longData = longString.data(using: .utf8)
        
        if let longData = longString.data(using: .utf8) {
            self.measure(options: measureOptions) {
                MeasuringWrapper.startMeasuring(name, 0)
                channel.sendMessage(longData)
                MeasuringWrapper.endMeasuring(name, 0)
            }
        } else {
            throw NSError()
        }
    }
    
    
    func testT2a10000() throws { sendWithStandardMessageCodec(10000) }
    func testT2a20000() throws { sendWithStandardMessageCodec(20000) }
    func testT2a30000() throws { sendWithStandardMessageCodec(30000) }
    func testT2a40000() throws { sendWithStandardMessageCodec(40000) }
    func testT2a50000() throws { sendWithStandardMessageCodec(50000) }
    func testT2a60000() throws { sendWithStandardMessageCodec(60000) }
    func testT2a70000() throws { sendWithStandardMessageCodec(70000) }
    func testT2a80000() throws { sendWithStandardMessageCodec(80000) }
    func testT2a90000() throws { sendWithStandardMessageCodec(90000) }
    func testT2a100000() throws { sendWithStandardMessageCodec(100000) }

    func testT2b10000() throws { sendWithStringCodec(10000) }
    func testT2b20000() throws { sendWithStringCodec(20000) }
    func testT2b30000() throws { sendWithStringCodec(30000) }
    func testT2b40000() throws { sendWithStringCodec(40000) }
    func testT2b50000() throws { sendWithStringCodec(50000) }
    func testT2b60000() throws { sendWithStringCodec(60000) }
    func testT2b70000() throws { sendWithStringCodec(70000) }
    func testT2b80000() throws { sendWithStringCodec(80000) }
    func testT2b90000() throws { sendWithStringCodec(90000) }
    func testT2b100000() throws { sendWithStringCodec(100000) }
    
    func testT2c10000() throws { try sendWithBinaryCodec(10000) }
    func testT2c20000() throws { try sendWithBinaryCodec(20000) }
    func testT2c30000() throws { try sendWithBinaryCodec(30000) }
    func testT2c40000() throws { try sendWithBinaryCodec(40000) }
    func testT2c50000() throws { try sendWithBinaryCodec(50000) }
    func testT2c60000() throws { try sendWithBinaryCodec(60000) }
    func testT2c70000() throws { try sendWithBinaryCodec(70000) }
    func testT2c80000() throws { try sendWithBinaryCodec(80000) }
    func testT2c90000() throws { try sendWithBinaryCodec(90000) }
    func testT2c100000() throws { try sendWithBinaryCodec(100000) }
}
