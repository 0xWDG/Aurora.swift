//
//  UITabbar.swift
//  Aurora
//
//  Created by Wesley de Groot on 26/06/2020.
//


#if canImport(UIKit)
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
        
        print("Could not find item \(withName).")
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
