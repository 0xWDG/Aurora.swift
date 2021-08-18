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
    /// Execute block in background
    /// - Parameter background: what to execute
    func run(background: @escaping () -> Void) {
        DispatchQueue.global().async {
            background()
        }
    }
    
    /// Execute block in foreground
    /// - Parameter main: What to run in execute foreground
    func execute(main: @escaping () -> Void) {
        DispatchQueue.main.async {
            main()
        }
    }
    
    /// Execute block in background
    /// - Parameter background:What to execute in the backgroud
    func execute(background: @escaping () -> Void) {
        DispatchQueue.global().async {
            background()
        }
    }
    
    /// Delay execution of block (on main)
    /// - Parameters:
    ///   - after: For how long
    ///   - closure: What to execute
    func delay(seconds: Double, closure: @escaping () -> Void) {
        let when = DispatchTime.now() + seconds
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    /// Delay execution of block (in background)
    /// - Parameters:
    ///   - after: For how long
    ///   - closure: What to execute
    func execute(after: Double, closure: @escaping () -> Void) {
        let when = DispatchTime.now() + after
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}
