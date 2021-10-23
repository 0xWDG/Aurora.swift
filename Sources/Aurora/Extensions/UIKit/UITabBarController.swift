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

#if canImport(UIKit) && !os(watchOS)
import UIKit

public extension UITabBarController {
    /// No iOS 15 transparent TabBar
    func preIOS15() {
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    /// Selet item with name
    /// - Parameter withName: name
    func select(withName: String) {
        var currentIndex = 0

        guard let items = tabBar.items else {
            return
        }

        for barItem in items {
            if barItem.title == withName {
                selectedIndex = currentIndex
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
    ///     self.tabBarController?.onTap(times: 10, execute: { title in
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

    /// Reload the current selected view
    ///
    /// It resets the loading of the current view.
    /// switches from tab and then switches back.
    /// - note: the current view will be re-loaded
    /// the functions below will be re-called
    /// - `viewWillDisappear(_ animated: Bool)`
    /// - `viewDidDisappear(_ animated: Bool)`
    /// - `viewWillAappear(_ animated: Bool)`
    /// - `viewDidAppear(_ animated: Bool)`
    func reloadCurrentView() {
        // save the selected index
        let oldSelected = selectedIndex

        // Count the number of viewControllers
        let vcCount = viewControllers?.count ?? 0

        if vcCount > 1 {
            if oldSelected != 0 {
                selectedIndex = 0
            } else {
                if vcCount > 2 {
                    if oldSelected != 1 {
                        selectedIndex = 1
                    }
                }
            }
            selectedIndex = oldSelected
        }
    }
}
#endif
