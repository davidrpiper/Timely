# Timely

A tiny timing library for Swift. Timely allows you to easily time the execution of blocks of code.

## Usage

```swift
Timely.time("doSomething timer") { doSomething() }

let answer: Int = Timely.time("calculation timer") { calculateSomethingWithInts(1, 2) }
```

Timely wraps your existing code and times its execution. It is easy to drop into existing code
when performance measurements are needed.

However, no timing will actually occur until Timely knows what to do with its measurements.
Timely makes no assumptions about what you want to do with your timing reports. This makes Timely
itself very light and highly customisable. When you want to start reciving timing reports, you
set a report function:

```swift
Timely.setReportFunction { timer, seconds in
    // With the examples above, `timer` will be "doSomething timer" and "calculation timer".
    print("Timer with name \(timer) took \(seconds) seconds.")
}
```

This closure will be executed synchronously after a timer completes. Its arguments are the name
of the timer just executed and the number of seconds it measured. Timely's measurements are as
accurate as Foundation's Date class is for the execution platform.

You can of course dispatch asynchronous code in the report function. You might want to aggregate
the data, log it, write it out to a file, send it to a Splunk instance, etc.

If you want to stop Timely from timing (for example during tests) you can call:

```swift
Timely.noop()
```

Timely will then simply execute the code blocks it is passed without any timing or reporting (as
it did before it was provided a report function). If you want to start timing again, simply pass
another report function.

There might be times when you'll have already set up Timely, but want to use a different
reporting mechanism for particular timers. This can be done with an overload of the time method:

```swift
Timely.time("Timer", withReportFunction: CUSTOM_REPORT_FUNCTION) { doSomething() }
```

## License

Timely is released under the MIT License. See LICENSE.md for details.
