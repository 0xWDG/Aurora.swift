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

public extension UIView {
    // MARK: - Basic Properties
    // swiftlint:disable identifier_name
    /// X Axis value of UIView.
    @objc
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame = CGRect(
                x: _pixelIntegral(newValue),
                y: self.y,
                width: self.width,
                height: self.height
            )
        }
    }

    /// Y Axis value of UIView.
    @objc
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame = CGRect(
                x: self.x,
                y: _pixelIntegral(newValue),
                width: self.width,
                height: self.height
            )
        }
    }
    // swiftlint:enable identifier_name

    /// Width of view.
    @objc
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame = CGRect(
                x: self.x,
                y: self.y,
                width: _pixelIntegral(newValue),
                height: self.height
            )
        }
    }

    /// Height of view.
    @objc
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame = CGRect(
                x: self.x,
                y: self.y,
                width: self.width,
                height: _pixelIntegral(newValue)
            )
        }
    }

    // MARK: - Origin and Size
    /// View's Origin point.
    @objc
    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            self.frame = CGRect(
                x: _pixelIntegral(newValue.x),
                y: _pixelIntegral(newValue.y),
                width: self.width,
                height: self.height
            )
        }
    }

    /// View's size.
    @objc
    var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            self.frame = CGRect(
                x: self.x,
                y: self.y,
                width: _pixelIntegral(newValue.width),
                height: _pixelIntegral(newValue.height)
            )
        }
    }

    // MARK: - Extra Properties
    /// View's right side (x + width).
    @objc
    var right: CGFloat {
        get {
            return self.x + self.width
        }
        set {
            self.x = newValue - self.width
        }
    }

    /// View's bottom (y + height).
    @objc
    var bottom: CGFloat {
        get {
            return self.y + self.height
        }
        set {
            self.y = newValue - self.height
        }
    }

    /// View's top (y).
    @objc
    var top: CGFloat {
        get {
            return self.y
        }
        set {
            self.y = newValue
        }
    }

    /// View's left side (x).
    @objc
    var left: CGFloat {
        get {
            return self.x
        }
        set {
            self.x = newValue
        }
    }

    /// View's center X value (center.x).
    @objc
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint(x: newValue, y: self.centerY)
        }
    }

    /// View's center Y value (center.y).
    @objc
    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center = CGPoint(x: self.centerX, y: newValue)
        }
    }

    /// Last subview on X Axis.
    @objc
    var lastSubviewOnX: UIView? {
        return self.subviews.reduce(UIView(frame: .zero)) {
            return $1.x > $0.x ? $1: $0
        }
    }

    /// Last subview on Y Axis.
    @objc
    var lastSubviewOnY: UIView? {
        return self.subviews.reduce(UIView(frame: .zero)) {
            return $1.y > $0.y ? $1: $0
        }
    }

    // MARK: - Bounds Methods
    /// X value of bounds (bounds.origin.x).
    @objc
    var boundsX: CGFloat {
        get {
            return self.bounds.origin.x
        }
        set {
            self.bounds = CGRect(
                x: _pixelIntegral(newValue),
                y: self.boundsY,
                width: self.boundsWidth,
                height: self.boundsHeight
            )
        }
    }

    /// Y value of bounds (bounds.origin.y).
    @objc
    var boundsY: CGFloat {
        get {
            return self.bounds.origin.y
        }
        set {
            self.frame = CGRect(
                x: self.boundsX,
                y: _pixelIntegral(newValue),
                width: self.boundsWidth,
                height: self.boundsHeight
            )
        }
    }

    /// Width of bounds (bounds.size.width).
    @objc
    var boundsWidth: CGFloat {
        get {
            return self.bounds.size.width
        }
        set {
            self.frame = CGRect(
                x: self.boundsX,
                y: self.boundsY,
                width: _pixelIntegral(newValue),
                height: self.boundsHeight
            )
        }
    }

    /// Height of bounds (bounds.size.height).
    @objc
    var boundsHeight: CGFloat {
        get {
            return self.bounds.size.height
        }
        set {
            self.frame = CGRect(
                x: self.boundsX,
                y: self.boundsY,
                width: self.boundsWidth,
                height: _pixelIntegral(newValue)
            )
        }
    }

    // MARK: - Useful Methods
    /// Center view to it's parent view.
    @available(iOS 10, *)
    @objc
    func centerToParent() {
        #if os(iOS)
        guard let superview = self.superview else { return }
        var orientation: UIInterfaceOrientation = .unknown

        if #available(iOS 13.0, *) {
            orientation = UIApplication.shared.windows
                .first?.windowScene?
                .interfaceOrientation ?? .unknown
        } else {
            orientation =  UIApplication.shared.statusBarOrientation
        }

        switch orientation {
        case .landscapeLeft, .landscapeRight:
            self.origin = CGPoint(
                x: (superview.height / 2) - (self.width / 2),
                y: (superview.width / 2) - (self.height / 2)
            )

        case .portrait, .portraitUpsideDown:
            self.origin = CGPoint(
                x: (superview.width / 2) - (self.width / 2),
                y: (superview.height / 2) - (self.height / 2)
            )

        case .unknown:
            return

        @unknown default:
            return
        }
        #endif
    }

    // MARK: - Private Methods

    /// _pixelIntegral
    /// - Parameter pointValue: point
    /// - Returns: CGFloat
    fileprivate func _pixelIntegral(_ pointValue: CGFloat) -> CGFloat {
        let scale = UIScreen.main.scale
        return (round(pointValue * scale) / scale)
    }
}
#endif
