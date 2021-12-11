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

#if canImport(UIKit) && !os(watchOS)
import UIKit

public extension UITabBar {
    /// No iOS 15 transparent TabBar
    func preIOS15() {
        if #available(iOS 15.0, *) {
            // let appearance = UITabBarAppearance()
            // UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    /// Selected index
    var selectedIndex: Int {
        // Tricky business.

        var currentIndex = 0

        guard let items = items else {
            fatalError("No items in Tabbar.")
        }

        for barItem in items {
            if barItem == selectedItem {
                return currentIndex
            }

            currentIndex += 1
        }

        fatalError("Failed to get index")
    }

    /// Select item with name
    /// - Parameter withName: name
    func select(withName: String) {
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
    ///     self.tabBar?.onTap(times: 10, execute: { title in
    ///       // Code to run.
    ///     })
    ///
    ///
    /// - Parameters:
    ///   - times: After x taps
    ///   - execute: What to execute
    func onTap(times: Int? = 10, execute: @escaping ((String) -> Void)) {
        let runner = AuroraOnTabBarInteractionDelegate.sharedInstance
        runner.onInteractionClosure = execute
        runner.onTimes = times ?? 10

        self.delegate = runner
    }
}
#endif
