//
//  PlatformChannelPerformanceUITests.swift
//  PlatformChannelPerformanceUITests
//
//  Created by Markus Reinhold on 23.05.23.
//

import XCTest
import os

final class PlatformChannelPerformanceUITests: XCTestCase {

    var logCategory = OSLog(subsystem: "test.PlatformChannelPerformance", category: "measure")
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    private func scrollWithLogging(app: XCUIApplication, name: String) {
        for _ in 0..<10 {
            app.swipeUp(velocity: 10000)
            os_log("screenUpdate_%@: %f", log: logCategory, type: .debug, name, -20.0)
        }
    }
    
    func testT2aScroll() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Native scroll"].tap()
        scrollWithLogging(app: app, name: "T2a")
    }
    
    func testT2bInfiniteScroll() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Native infinite scroll"].tap()
        scrollWithLogging(app: app, name: "T2b")
    }
    
    func testT4aFlutterScroll() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Show Flutter!"].tap()
        app.buttons["Scroll"].tap()
        scrollWithLogging(app: app, name: "T4a")
    }
    
    func testT4bFlutterInfiniteScroll() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Show Flutter!"].tap()
        app.buttons["Infinite Scroll"].tap()
        scrollWithLogging(app: app, name: "T4b")
    }
    
    func testT6aFlutterScrollPC() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Show Flutter!"].tap()
        app.buttons["Scroll mit PlatformC"].tap()
        scrollWithLogging(app: app, name: "T6a")
    }
    
    func testT6bFlutterInfiniteScrollPC() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Show Flutter!"].tap()
        app.buttons["Infinite Scroll mit PlatformC"].tap()
        scrollWithLogging(app: app, name: "T6b")
    }
}
