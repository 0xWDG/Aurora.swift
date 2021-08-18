// Aurora framework for Swift
//
// The **Aurora.framework** contains a base for your project.
//
// It has a lot of extensions built-in to make development easier.
//
// - Version: 1.0
// - Copyright: [Wesley de Groot](https://wesleydegroot.nl) ([WDGWV](https://wdgwv.com))\
//  and [Contributors](https://github.com/AuroraFramework/Aurora.swift/graphs/contributors).
//
// Thanks for using!
//
// Licence: MIT

import Foundation

public extension Timer {
    /// Create and schedule a timer that will call `block` once after the specified time.
    /// - Parameters:
    ///   - interval: The time interval to wait before schedule the `Timer`.
    ///   - block: The block invoked when the timer fires. The block takes no argument.
    /// - Returns: The created Timer.
    class func new(after interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
        CFRunLoopTimerCreateWithHandler(
            kCFAllocatorDefault,
            CFAbsoluteTimeGetCurrent() + interval,
            0,
            0,
            0) { _ in
            block()
        }
    }

    /// Create and schedule a timer that will call `block` once after the specified time.
    /// - Parameters:
    ///   - interval: The time interval to wait before schedule the `Timer`.
    ///   - block: The block invoked when the timer fires. The block takes no argument.
    /// - Returns: The created Timer.
    class func after(_ interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
        let timer = Timer.new(after: interval, block)
        timer.start()
        return timer
    }

    /// Create and schedule a timer that will call `block` repeatedly in specified time intervals.
    /// - Parameters:
    ///   - interval: The firing interval of the timer.
    ///   - firesImmediately: A boolean indicating if the Timer must be fired immediately or not.
    ///                       Default value is false.
    ///   - block: The block invoked when the timer fires. The block takes one argument
    ///            corresponding to the `Timer` that has been fired.
    /// - Returns: The created Timer.
    class func every(_ interval: TimeInterval,
                     firesImmediately: Bool = false,
                     _ block: @escaping (Timer) -> Void) -> Timer {
        if firesImmediately {
            let fireDate = CFAbsoluteTimeGetCurrent()
            let timer = CFRunLoopTimerCreateWithHandler(
                kCFAllocatorDefault,
                fireDate,
                interval,
                0,
                0) { run in
                block(run!)
            }
            CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
            return timer!
        } else {
            let timer = Timer.new(every: interval, block)
            timer.start()
            return timer
        }
    }

    /// Create and schedule a timer that will call `block` once after the specified time.
    /// - Parameters:
    ///   - interval: The time interval to wait before schedule the `Timer`.
    ///   - block: The block invoked when the timer fires. The block takes one argument corresponding
    ///            to the `Timer` that has been fired.
    /// - Returns: The created Timer.
    class func new(every interval: TimeInterval, _ block: @escaping (Timer) -> Void) -> Timer {
        var timer: Timer!
        timer = CFRunLoopTimerCreateWithHandler(
            kCFAllocatorDefault,
            CFAbsoluteTimeGetCurrent() + interval,
            interval,
            0,
            0) { _ in
            block(timer)
        }
        return timer
    }

    /// Schedule this timer on the run loop.
    /// - Parameters:
    ///     - runLoop: The run loop where the Timer is scheduled. The default value is `RunLoop.current`
    ///     - modes: The run loop mode where the timer is scheduled. If none, it will scheduled on
    ///              `RunLoop.Mode.default`.
    func start(onRunLoop runLoop: RunLoop = RunLoop.current, modes: RunLoop.Mode...) {
        let modes = modes.isEmpty ? [RunLoop.Mode.default] : modes
        modes.forEach {
            runLoop.add(self, forMode: $0)
        }
    }

}
