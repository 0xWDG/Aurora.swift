//
//  File.swift
//  
//
//  Created by Wesley de Groot on 16/07/2021.
//

import Foundation

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
        if timer != nil {
            timer!.invalidate()
        }
    }
    
    /// This method must be in the public or scope
    @objc func update() {
        tick()
    }
}
