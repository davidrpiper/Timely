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
        and the number of seconds the timed closure took to execute.
     */
    static func setReportFunction(_ function: @escaping (String, Double) -> ());

    static func time(_ name: String, _ closure: () -> ());
    static func time<T>(_ name: String, _ closure: () -> T) -> T;
}
