/*
 *  Timely.swift
 *  Timely
 *
 *  Copyright (c) 2018 David Piper, @_davidpiper
 *
 *  This software may be modified and distributed under the terms
 *  of the MIT license. See the LICENSE file for details.
 */

import Foundation

public struct Timely: TimelyTimer {
    private static var reportFunction: ((String, Double) -> ())?

    public static func setReportFunction(_ function: @escaping (String, Double) -> ()) {
        reportFunction = function
    }
    
    public static func noop() {
        reportFunction = nil
    }

    public static func time<T>(_ name: String, _ closure: () -> T) -> T {
        if let report = reportFunction {
            let start = Date()
            let ret = closure()
            let diff: Double = start.timeIntervalSinceNow * -1
            report(name, diff)
            return ret
        }
        
        return closure()
    }
    
    public static func time<T>(_ name: String, withReportFunction report: (String, Double) -> (), _ closure: () -> T) -> T {
        let start = Date()
        let ret = closure()
        let diff: Double = start.timeIntervalSinceNow * -1
        report(name, diff)
        return ret
    }
}
