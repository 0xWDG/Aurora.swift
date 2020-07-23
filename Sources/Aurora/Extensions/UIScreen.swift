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

#if os(iOS) || os(tvOS)

import UIKit

extension UIScreen {
    /// Get the screen's size.
    @objc public class var size: CGSize {
        CGSize(width: width, height: height)
    }
    
    /// Get the screen's width.
    @objc public class var width: CGFloat {
        UIScreen.main.bounds.size.width
    }
    
    /// Get the screen's height..
    @objc public class var height: CGFloat {
        UIScreen.main.bounds.size.height
    }
    
    #if os(iOS)
    /// Get the status bar height.
    /// - Returns: The status bar height.
    public class var statusBarHeight: CGFloat {
        UIApplication.shared.statusBarFrame.height
    }
    
    /// Get the screen height without the status bar.
    public class var heightWithoutStatusBar: CGFloat {
        currentOrientation.isPortrait ? height - statusBarHeight :
        UIScreen.main.bounds.size.width - statusBarHeight
    }
    
    /// Get the current screen orientation.
    @objc public class var currentOrientation: UIInterfaceOrientation {
        UIApplication.shared.statusBarOrientation
    }
    #endif
}
#endif
