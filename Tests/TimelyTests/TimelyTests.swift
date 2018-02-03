/*
 *  TimelyTests.swift
 *  Timely
 *
 *  Copyright (c) 2018 David Piper, @_davidpiper
 *
 *  This software may be modified and distributed under the terms
 *  of the MIT license. See the LICENSE file for details.
 */

import XCTest
@testable import Timely

var globalCounter = 0

class TimelyTests: XCTestCase {
    // A () -> () closure to time
    private let funcVoidReturn: () -> () = {
        Thread.sleep(forTimeInterval: 0.2)
    }

    // A () -> T closure to time
    private let funcWithReturn: () -> Int = {
        Thread.sleep(forTimeInterval: 0.2)
        return 100
    }

    // A callback that should be called - adds 1 to the global counter
    private let timerCallbackAddingOne: (String, Double) -> () = { name, secs in
        XCTAssertEqual(name, "Timer")
        XCTAssertGreaterThanOrEqual(secs, 0.2)
        globalCounter += 1
    }

    // A callback that should be called - subtracts one from the global counter
    private let timerCallbackSubtractingOne: (String, Double) -> () = { name, secs in
        XCTAssertEqual(name, "Timer")
        XCTAssertGreaterThanOrEqual(secs, 0.2)
        globalCounter -= 1
    }

    // A callback that should never be called
    private let failingCallback: (String, Double) -> () = { name, secs in
        XCTFail("This callback should never be called.")
    }

    override func setUp() {
        globalCounter = 0
    }

    func testVoidReturnTimingFunction() {
        Timely.setReportFunction(timerCallbackAddingOne)

        Timely.time("Timer", funcVoidReturn)
        let void: Void = Timely.time("Timer", funcVoidReturn)

        XCTAssertTrue(Void.self == type(of: void).self)
        XCTAssertEqual(globalCounter, 2)
    }

    func testReturningTimingFunction() {
        Timely.setReportFunction(timerCallbackAddingOne)

        let oneHundred = Timely.time("Timer", funcWithReturn)

        XCTAssertEqual(Int(100), oneHundred)
        XCTAssertEqual(globalCounter, 1)
    }

    func testInterchangingReportFunctions() {
        Timely.setReportFunction(timerCallbackAddingOne)
        Timely.time("Timer", funcVoidReturn)
        XCTAssertEqual(globalCounter, 1)

        Timely.setReportFunction(timerCallbackSubtractingOne)
        let oneHundred = Timely.time("Timer", funcWithReturn)
        XCTAssertEqual(Int(100), oneHundred)
        XCTAssertEqual(globalCounter, 0)

        Timely.setReportFunction(timerCallbackAddingOne)
        Timely.time("Timer", funcVoidReturn)
        XCTAssertEqual(globalCounter, 1)

        Timely.setReportFunction(timerCallbackSubtractingOne)
        let oneHundredAgain = Timely.time("Timer", funcWithReturn)
        XCTAssertEqual(Int(100), oneHundredAgain)
        XCTAssertEqual(globalCounter, 0)
    }
    
    func testDefaultNoop() {
        Timely.time("Timer", funcVoidReturn)
        XCTAssertEqual(globalCounter, 0)

        let oneHundred = Timely.time("Timer", funcWithReturn)
        XCTAssertEqual(Int(100), oneHundred)
        XCTAssertEqual(globalCounter, 0)
    }
    
    func testNoop() {
        // -- Reporting -- //
        Timely.setReportFunction(timerCallbackAddingOne)

        Timely.time("Timer", funcVoidReturn)
        XCTAssertEqual(globalCounter, 1)

        let oneHundred = Timely.time("Timer", funcWithReturn)
        XCTAssertEqual(Int(100), oneHundred)
        XCTAssertEqual(globalCounter, 2)

        // -- No reporting -- //
        Timely.noop()

        Timely.time("Timer", funcVoidReturn)
        XCTAssertEqual(globalCounter, 2)

        let oneHundredAgain = Timely.time("Timer", funcWithReturn)
        XCTAssertEqual(Int(100), oneHundredAgain)
        XCTAssertEqual(globalCounter, 2)

        // -- Reporting -- //
        Timely.setReportFunction(timerCallbackSubtractingOne)

        Timely.time("Timer", funcVoidReturn)
        XCTAssertEqual(globalCounter, 1)

        let oneHundredAThirdTime = Timely.time("Timer", funcWithReturn)
        XCTAssertEqual(Int(100), oneHundredAThirdTime)
        XCTAssertEqual(globalCounter, 0)

        // -- No reporting -- //
        Timely.noop()

        Timely.time("Timer", funcVoidReturn)
        XCTAssertEqual(globalCounter, 0)

        let oneHundredAFourthTime = Timely.time("Timer", funcWithReturn)
        XCTAssertEqual(Int(100), oneHundredAFourthTime)
        XCTAssertEqual(globalCounter, 0)
    }

    func testProvidedReportFunction() {
        Timely.time("Timer", withReportFunction: {_, _ in globalCounter += 1}, funcVoidReturn)
        XCTAssertEqual(globalCounter, 1)

        let oneHundred = Timely.time("Timer", withReportFunction: {_, _ in globalCounter += 1}, funcWithReturn)
        XCTAssertEqual(Int(100), oneHundred)
        XCTAssertEqual(globalCounter, 2)

        // Check that we can still go back to the usual calling conventions
        // after specifying a one-off reporting function

        Timely.time("Timer", funcVoidReturn)
        XCTAssertEqual(globalCounter, 2)

        Timely.setReportFunction(timerCallbackSubtractingOne)
        Timely.time("Timer", funcVoidReturn)
        XCTAssertEqual(globalCounter, 1)

        Timely.noop()
        let oneHundredAgain = Timely.time("Timer", funcWithReturn)
        XCTAssertEqual(Int(100), oneHundredAgain)
        XCTAssertEqual(globalCounter, 1)
    }

    static var allTests = [
        ("testVoidReturnTimingFunction", testVoidReturnTimingFunction),
        ("testReturningTimingFunction", testReturningTimingFunction),
        ("testInterchangingReportFunction", testInterchangingReportFunctions),
        ("testDefaultNoop", testDefaultNoop),
        ("testNoop", testNoop),
        ("testProvidedReportFunction", testProvidedReportFunction),
    ]
}
