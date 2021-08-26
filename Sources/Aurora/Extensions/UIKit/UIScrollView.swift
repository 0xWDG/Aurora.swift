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
import UIKit

public extension UIScrollView {
    /// Add extra scroll at top
    /// - Parameter value: padding value
    func addExtraScrollAt(top value: CGFloat) {
        contentInset = UIEdgeInsets(top: value, left: 0.0, bottom: 0.0, right: 0.0)
    }

    /// Add extra scroll at left
    /// - Parameter value: padding value
    func addExtraScrollAt(left value: CGFloat) {
        contentInset = UIEdgeInsets(top: 0.0, left: value, bottom: 0.0, right: 0.0)
    }

    /// Add extra scroll at bottom
    /// - Parameter value: padding value
    func addExtraScrollAt(bottom value: CGFloat) {
        contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: value, right: 0.0)
    }

    /// Add extra scroll at right
    /// - Parameter value: padding value
    func addExtraScrollAt(right value: CGFloat) {
        contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: value)
    }
}
#endif
