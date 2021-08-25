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

#if canImport(UIKit)
import Foundation
import UIKit

public extension UITextField {
    /// Padding Value
    @IBInspectable var paddingValue: CGFloat {
        get {
            return self.paddingValue
        }
        set {
            self.paddingValue = newValue
        }
    }

    /// Get the padding value
    var padding: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: paddingValue, bottom: 0, right: paddingValue)
    }
}
#endif
