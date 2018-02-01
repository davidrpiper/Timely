/*
 *  TimelyNoopTests.swift
 *  Timely
 *
 *  Copyright (c) 2018 David Piper, @_davidpiper
 *
 *  This software may be modified and distributed under the terms
 *  of the MIT license. See the LICENSE file for details.
 */

import XCTest
@testable import Timely

class TimelyNoopTests: XCTestCase {
    // The () -> () closure to time
    private let funcVoidReturn: () -> () = {
        Thread.sleep(forTimeInterval: 1.0)
    }

    // The () -> T closure to time
    private let funcWithReturn: () -> Int = {
        Thread.sleep(forTimeInterval: 1.0)
        return 100
    }

    // Noop timer should never call the callback
    private let noopCallback: (String, Double) -> () = { _, _ in
        XCTFail("Callback should never be called in the Noop struct")
    }

    // In fact the noop timer should never even set the callback, but a black
    // box test wouldn't know that, and TimelyNoop might change in future.
    private let noopCallback2: (String, Double) -> () = { _, _ in
        XCTFail("Callback should never be called in the Noop struct")
    }

    override func setUp() {
        super.setUp()
        TimelyNoop.setReportFunction(noopCallback)
    }

    func testVoidReturnTimingFunction() {
        TimelyNoop.time("Noop with function with no return type", funcVoidReturn)
        XCTAssert(true)
    }

    func testReturningTimingFunction() {
        let oneHundred = TimelyNoop.time("Noop with returning function", funcWithReturn)
        XCTAssertEqual(Int(100), oneHundred)
    }

    func testInterchangingReportFunctions() {
        TimelyNoop.time("Noop with function with no return type", funcVoidReturn)
        
        TimelyNoop.setReportFunction(noopCallback2)
        let oneHundred = TimelyNoop.time("Noop with function with no return type", funcWithReturn)
        XCTAssertEqual(Int(100), oneHundred)
        
        TimelyNoop.setReportFunction(noopCallback)
        TimelyNoop.time("Noop with function with no return type", funcVoidReturn)
        XCTAssert(true)
    }

    static var allTests = [
        ("testVoidReturnTimingFunction", testVoidReturnTimingFunction),
        ("testReturningTimingFunction", testReturningTimingFunction),
        ("testInterchangingReportFunction", testInterchangingReportFunctions)
    ]
}
