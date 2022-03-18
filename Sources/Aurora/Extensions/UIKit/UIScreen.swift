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

#if os(iOS) || os(tvOS)

import UIKit

public extension UIScreen {
    /// Get the screen's size.
    @objc class var size: CGSize {
        CGSize(width: width, height: height)
    }

    /// Get the screen's width.
    @objc class var width: CGFloat {
        UIScreen.main.bounds.size.width
    }

    /// Get the screen's height..
    @objc class var height: CGFloat {
        UIScreen.main.bounds.size.height
    }

    #if os(iOS)
    /// Get the status bar height.
    /// - Returns: The status bar height.
    class var statusBarHeight: CGFloat {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }

    /// Get the screen height without the status bar.
    class var heightWithoutStatusBar: CGFloat {
        currentOrientation.isPortrait ? height - statusBarHeight :
        UIScreen.main.bounds.size.width - statusBarHeight
    }

    #if !os(tvOS)
    /// Get the current screen orientation.
    @objc class var currentOrientation: UIInterfaceOrientation {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows
                .first?
                .windowScene?
                .interfaceOrientation ?? .unknown
        } else {
            return UIApplication.shared.statusBarOrientation
        }
    }
    #endif
    #endif
}
#endif
