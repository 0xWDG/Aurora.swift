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
// Licence: MIT

#if os(iOS) || os(tvOS)
import UIKit

@available(iOS 9.0, *)
public extension UIButton {
    /// Add a right image with custom offset to the current button.
    /// - Parameters:
    ///     - image: The image that will be added to the button.
    ///     - offset: The trailing margin that will be added between the image and the button's right border.
    func addRightImage(_ image: UIImage?, offset: CGFloat) {
        setImage(image, for: .normal)
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0.0).isActive = true
        imageView?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset).isActive = true
    }
}

#endif
