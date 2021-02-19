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

#if canImport(UIKit) && !os(watchOS) && !os(tvOS)
import UIKit
import QuartzCore

@IBDesignable
open class UIViewRounded: UIView {
    /// Radius for the UIViewRounded
    @IBInspectable public var xborderRadius: CGFloat = 24
    
    /// Draw a rounded view
    /// - Parameter rect: The portion of the view’s bounds that needs to be updated.\
    /// The first time your view is drawn, this rectangle is typically the entire visible bounds of your view.\
    /// However, during subsequent drawing operations, the rectangle may specify only part of your view.
    public override func draw(_ rect: CGRect) {
        super.draw(rect)

        self.roundCorners(
            corners: [.allCorners],
            radius: xborderRadius
        )
    }
}
#endif
