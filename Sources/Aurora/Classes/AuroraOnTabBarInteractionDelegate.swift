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

#if canImport(UIKit) && !os(watchOS)
import UIKit

/// <#Description#>
class AuroraOnTabBarInteractionDelegate: NSObject, UITabBarControllerDelegate, UITabBarDelegate {
    /// onInteraction closute
    public var onInteractionClosure: ((String) -> Void)?
    /// On x times
    public var onTimes: Int = 10
    
    /// old ViewController
    private var oldVC: ViewController?
    /// old UITabBarItem
    private var oldItem: UITabBarItem?
    
    /// The tap counter
    private var tapCounter: (Double, Int) = (0.0, 0)
    
    /// The shared instance, otherwise it will deinit direct
    static let sharedInstance: AuroraOnTabBarInteractionDelegate = AuroraOnTabBarInteractionDelegate()
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if oldItem != nil {
            if oldItem == item {
                let timestamp = CACurrentMediaTime()
                if tapCounter.0 < timestamp - 0.4 {
                    tapCounter.0 = timestamp
                    tapCounter.1 = 0
                }
                
                if tapCounter.0 >= timestamp - 0.4 {
                    tapCounter.0 = timestamp
                    tapCounter.1 += 1
                }
                
                if tapCounter.1 >= onTimes {
                    tapCounter.1 = 0
                    
                    if let title = item.title {
                        onInteractionClosure?(title)
                    } else {
                        onInteractionClosure?("item")
                    }
                }
            }
        }
        
        oldItem = item
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if oldVC != nil {
            if oldVC == viewController {
                let timestamp = CACurrentMediaTime()
                if tapCounter.0 < timestamp - 0.4 {
                    tapCounter.0 = timestamp
                    tapCounter.1 = 0
                }
                
                if tapCounter.0 >= timestamp - 0.4 {
                    tapCounter.0 = timestamp
                    tapCounter.1 += 1
                }
                
                if tapCounter.1 >= onTimes {
                    tapCounter.1 = 0

                    if let title = tabBarController.tabBar.items?[tabBarController.selectedIndex].title {
                        onInteractionClosure?(title)
                    } else {
                        onInteractionClosure?("item")
                    }
                }
            }
        }
        
        oldVC = viewController
    }
}

#endif
