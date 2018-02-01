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

class TimelyTests: XCTestCase {
    // The () -> () closure to time
    private let funcVoidReturn: () -> () = {
        Thread.sleep(forTimeInterval: 1.0)
    }

    // The () -> T closure to time
    private let funcWithReturn: () -> Int = {
        Thread.sleep(forTimeInterval: 1.0)
        return 100
    }

    // The callback for the void closure
    private let voidReturnCallback: (String, Double) -> () = { name, secs in
        XCTAssertEqual(name, "Void callback")
        XCTAssertGreaterThan(secs, 0.99)
        XCTAssertLessThan(secs, 1.01)
    }

    // The callback for the (-> T) closure
    private let tReturnCallback: (String, Double) -> () = { name, secs in
        XCTAssertEqual(name, "Return T callback")
        XCTAssertGreaterThan(secs, 0.99)
        XCTAssertLessThan(secs, 1.01)
    }

    func testVoidReturnTimingFunction() {
        Timely.setReportFunction(voidReturnCallback)
        Timely.time("Void callback", funcVoidReturn)
        XCTAssert(true)
    }

    func testReturningTimingFunction() {
        Timely.setReportFunction(tReturnCallback)
        let oneHundred = Timely.time("Return T callback", funcWithReturn)
        XCTAssertEqual(Int(100), oneHundred)
    }

    func testInterchangingReportFunctions() {
        Timely.setReportFunction(voidReturnCallback)
        Timely.time("Void callback", funcVoidReturn)

        Timely.setReportFunction(tReturnCallback)
        let oneHundred = Timely.time("Return T callback", funcWithReturn)
        XCTAssertEqual(Int(100), oneHundred)

        Timely.setReportFunction(voidReturnCallback)
        Timely.time("Void callback", funcVoidReturn)

        Timely.setReportFunction(tReturnCallback)
        let oneHundredAgain = Timely.time("Return T callback", funcWithReturn)
        XCTAssertEqual(Int(100), oneHundredAgain)
    }

    static var allTests = [
        ("testVoidReturnTimingFunction", testVoidReturnTimingFunction),
        ("testReturningTimingFunction", testReturningTimingFunction),
        ("testInterchangingReportFunction", testInterchangingReportFunctions)
    ]
}
