/*
 *  TimelyTimer.swift
 *  Timely
 *
 *  Copyright (c) 2018 David Piper, @_davidpiper
 *
 *  This software may be modified and distributed under the terms
 *  of the MIT license. See the LICENSE file for details.
 */

public protocol TimelyTimer {
    /**
        The passed closure will be called synchronously at the end of a
        Timely time operation. It will be passed the name of the timer,
        and the time the closure took to execute, in seconds.
     */
    static func setReportFunction(_ function: @escaping (String, Double) -> ());
    
    /**
        Make the Timely timer just execute the closure without timing it.
     */
    static func noop();

    /**
        Time the execution of a closure.
     */
    static func time<T>(_ name: String, _ closure: () -> T) -> T;
    
    /**
        Time the execution of a closure with a specific reporting function
        for this invocation.
     */
    static func time<T>(_ name: String, withReportFunction: (String, Double) -> (), _ closure: () -> T) -> T
}
