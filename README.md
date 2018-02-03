# Timely

A tiny timing library for Swift. Timely allows you to easily time the execution of blocks of code.

## Usage

```swift
Timely.time("Timer 1") { doSomething() }

let answer: Int = Timely.time("Timer 2") { calculateSomethingWithInts(1, 2) }
```

Timely wraps your existing code and times its execution. It is easy to drop into existing code
when performance measurements are needed.

However, no timing will actually occur until Timely knows what to do with its measurements. To
remain light and highly customisable, Timely deliberately makes no assumptions about what you
want to do with its timing data. To start receiving timing reports, you have to set a report
function:

```swift
Timely.setReportFunction { timer, seconds in
    // With the examples above, `timer` will be "Timer 1" and "Timer 2".
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

There might be times when you have already set up Timely's report function, but want to use a
different reporting mechanism for a particular timer. This can be done with an overload of the
time method that applies a custom report function to that timer only:

```swift
Timely.time("Timer", withReportFunction: CUSTOM_REPORT_FUNCTION) { doSomething() }
```

## License

Timely is released under the MIT License. See LICENSE.md for details.
