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
// Licence: Needs to be decided.

import Foundation

infix operator ~>   // serial queue operator

/// Executes the lefthand closure on a background thread and,
/// upon completion, the righthand closure on the main thread.
/// Passes the background closure's output to the main closure.
/// - Parameters:
///   - backgroundClosure: <#backgroundClosure description#>
///   - mainClosure: <#mainClosure description#>
public func ~> (backgroundClosure: @escaping () -> Void, mainClosure: @escaping () -> Void) {
    serialQueue.async {
        backgroundClosure()
        DispatchQueue.main.async {
            mainClosure()
        }
    }
}
/// <#Description#>
/// - Parameters:
///   - backgroundClosure: <#backgroundClosure description#>
///   - mainClosure: <#mainClosure description#>
public func ~> <R> (backgroundClosure: @escaping () -> R, mainClosure: @escaping (_ result: R) -> Void) {
    serialQueue.async {
        let result = backgroundClosure()
        DispatchQueue.main.async(execute: {
            mainClosure(result)
        })
    }
}
/// <#Description#>
/// - Parameters:
///   - backgroundClosure: <#backgroundClosure description#>
///   - mainClosure: <#mainClosure description#>
public func ~> (backgroundClosure: @escaping () -> String, mainClosure: @escaping (_ result: String) -> Void) {
    serialQueue.async {
        let result = backgroundClosure()
        DispatchQueue.main.async(execute: {
            mainClosure(result)
        })
    }
}

/// Serial dispatch queue used by the ~> operator.
private let serialQueue = DispatchQueue(label: "serial-worker")

public extension Aurora {
    /// <#Description#>
    /// - Parameter block: <#block description#>
    func runInBackground(block: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            block()
        }
    }
    
    /// <#Description#>
    /// - Parameter block: <#block description#>
    func runInForeground(block: @escaping () -> Void) {
        DispatchQueue.main.async {
            block()
        }
    }
    
    /// repeat/run
    /// - Parameters:
    ///   - every: <#every description#>
    ///   - block: <#block description#>
    func run(every: TimeInterval, block: @escaping (Timer) -> Void) {
        Timer.scheduledTimer(withTimeInterval: every, repeats: true, block: block)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - background: <#background description#>
    ///   - foreground: <#foreground description#>
    func run(background: @escaping () -> String,
             foreground: @escaping (_ returning: String) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let result = background()
        
            DispatchQueue.main.async(execute: {
                foreground(result)
            })
        }
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - background: <#background description#>
    ///   - foreground: <#foreground description#>
    func run(background: @escaping () -> Bool,
             foreground: @escaping (_ returning: Bool) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let result = background()
            
            DispatchQueue.main.async {
                foreground(result)
                
            }
        }
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - background: <#background description#>
    ///   - foreground: <#foreground description#>
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
