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
extension Aurora {
    /// Simple Timer
    open class SimpleTimer {
        typealias Tick = () -> Void
        
        /// Timer
        var timer: Timer?
        
        /// Interval
        var interval: TimeInterval
        
        /// Needs to repeat
        var repeats: Bool
        
        /// Do on Tick
        var tick: Tick
        
        /// Run something on a timed interval
        /// - Parameters:
        ///   - interval: interval
        ///   - repeats: does it need to repeat?
        ///   - onTick: on Tick execute...
        init(interval: TimeInterval, repeats: Bool = false, onTick: @escaping Tick) {
            self.interval = interval
            self.repeats = repeats
            self.tick = onTick
        }
        
        /// Start the timer
        func start() {
            timer = Timer.scheduledTimer(
                timeInterval: interval,
                target: self,
                selector: #selector(update),
                userInfo: nil,
                repeats: true
            )
        }
        
        /// Stop the timer
        func stop() {
            if let timer = timer {
                timer.invalidate()
            }
        }
        
        /// This method must be in the public or scope
        @objc func update() {
            tick()
        }
    }
}
