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

#if canImport(UIKit) && !os(watchOS)
import UIKit

extension UITabBar {
    /// <#Description#>
    /// - Parameter withName: <#withName description#>
    public func select(withName: String) {
        var currentIndex = 0
        
        guard let items = items else {
            return
        }
        
        for barItem in items {
            if barItem.title == withName {
                selectedItem = barItem
                return
            }
            
            currentIndex += 1
        }
        
        fatalError("Could not find item \(withName).")
    }
    
    /// Execute a action after x taps
    ///
    /// Example:
    ///
    ///     self.tabBar?.onTap(times: 10, execute: {
    ///       // Code to run.
    ///     })
    ///
    ///
    /// - Parameters:
    ///   - times: After x taps
    ///   - execute: What to execute
    public func onTap(times: Int? = 10, execute: @escaping (() -> Void)) {
        let runner = AuroraOnTabBarInteractionDelegate.sharedInstance
        runner.onInteractionClosure = execute
        runner.onTimes = times ?? 10
        
        self.delegate = runner
    }
}
#endif
