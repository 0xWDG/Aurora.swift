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

public extension UIBarButtonItem {
    /// Frame
    var frame: CGRect? {
        guard let view = self.value(forKey: "view") as? UIView else {
            return nil
        }
        return view.frame
    }

    /// View
    var view: UIView? {
        guard let view = self.value(forKey: "view") as? UIView else {
            return nil
        }
        return view
    }
}
#endif
