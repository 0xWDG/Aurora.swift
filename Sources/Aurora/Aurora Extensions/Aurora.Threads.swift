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
// Please note: this is a beta version.
// It can contain bugs, please report all bugs to https://github.com/AuroraFramework/Aurora.swift
//
// Thanks for using!
//
// Licence: MIT

import Foundation

public extension Aurora {
    /// run in background
    /// - Parameter block: what to run
    func runInBackground(block: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            block()
        }
    }
    
    /// run on main thread (foreground)
    /// - Parameter block: what to run
    func runInForeground(block: @escaping () -> Void) {
        DispatchQueue.main.async {
            block()
        }
    }
    
    /// Run every
    /// - Parameters:
    ///   - every: time interval
    ///   - block: what to run
    func run(every: TimeInterval, block: @escaping (Timer) -> Void) {
        Timer.scheduledTimer(withTimeInterval: every, repeats: true, block: block)
    }
    
    /// Run
    /// - Parameters:
    ///   - background: what to run in background
    ///   - foreground: what to run in foreground
    func run(background: @escaping () -> String,
             foreground: @escaping (_ returning: String) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let result = background()
        
            DispatchQueue.main.async(execute: {
                foreground(result)
            })
        }
    }
    
    /// Run
    /// - Parameters:
    ///   - background: what to run in background
    ///   - foreground: what to run in foreground
    func run(background: @escaping () -> Bool,
             foreground: @escaping (_ returning: Bool) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let result = background()
            
            DispatchQueue.main.async {
                foreground(result)
                
            }
        }
    }
    
    /// Run
    /// - Parameters:
    ///   - background: what to run in background
    ///   - foreground: what to run in foreground
    func run(background: @escaping () -> Any,
             foreground: @escaping (_ returning: Any) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let result = background()
            
            DispatchQueue.main.async {
                foreground(result)
            }
        }
    }
}
