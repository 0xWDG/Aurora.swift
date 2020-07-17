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
#if canImport(UIKit)
import UIKit

extension UIApplication {
    /// Clear the cache of the launchscreen
    func clearLaunchScreenCache() {
        do {
            let cache = NSHomeDirectory() + "/Library/SplashBoard"
            try FileManager.default.removeItem(
                at: URL.init(
                    string: cache
                    )!
            )
        } catch {
            print("Failed to delete launch screen cache with error: \(error)")
        }
    }
}
#endif
