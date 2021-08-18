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

/// A Designable UIGreenButton
@IBDesignable open class UIGreenButton: UIButton {
    /// A Designable UIGreenButton
    /// - Parameter frame: button frame
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    /// Awake from nib
    override public func awakeFromNib() {
        super.awakeFromNib()

        setTitleColor(.white, for: .normal)

        backgroundColor = .button

        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor

        updateFocusIfNeeded()
    }

    /// Init (coder)
    /// - Parameter coder: coder
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
#endif
