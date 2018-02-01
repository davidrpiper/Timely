/*
 *  TimelyNoop.swift
 *  Timely
 *
 *  Copyright (c) 2018 David Piper, @_davidpiper
 *
 *  This software may be modified and distributed under the terms
 *  of the MIT license. See the LICENSE file for details.
 */

public struct TimelyNoop: TimelyTimer {
    public static func setReportFunction(_ function: @escaping (String, Double) -> ()) { }

    public static func time(_ name: String, _ closure: () -> ()) {
        closure()
    }

    public static func time<T>(_ name: String, _ closure: () -> T) -> T {
        return closure()
    }
}
