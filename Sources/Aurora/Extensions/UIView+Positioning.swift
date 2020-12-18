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

#if canImport(UIKit) && !os(watchOS)
import UIKit

public extension UIView {
    // MARK: - Basic Properties
    // swiftlint:disable identifier_name
    /// X Axis value of UIView.
    @objc
    var x: CGFloat {
        set {
            self.frame = CGRect(
                x: _pixelIntegral(newValue),
                y: self.y,
                width: self.width,
                height: self.height
            )
        }
        get {
            return self.frame.origin.x
        }
    }

    /// Y Axis value of UIView.
    @objc
    var y: CGFloat {
        set {
            self.frame = CGRect(
                x: self.x,
                y: _pixelIntegral(newValue),
                width: self.width,
                height: self.height
            )
        }
        get {
            return self.frame.origin.y
        }
    }
    // swiftlint:enable identifier_name
    
    /// Width of view.
    @objc
    var width: CGFloat {
        set {
            self.frame = CGRect(
                x: self.x,
                y: self.y,
                width: _pixelIntegral(newValue),
                height: self.height
            )
        }
        get {
            return self.frame.size.width
        }
    }
    
    /// Height of view.
    @objc
    var height: CGFloat {
        set {
            self.frame = CGRect(
                x: self.x,
                y: self.y,
                width: self.width,
                height: _pixelIntegral(newValue)
            )
        }
        get {
            return self.frame.size.height
        }
    }
    
    // MARK: - Origin and Size
    /// View's Origin point.
    @objc
    var origin: CGPoint {
        set {
            self.frame = CGRect(
                x: _pixelIntegral(newValue.x),
                y: _pixelIntegral(newValue.y),
                width: self.width,
                height: self.height
            )
        }
        get {
            return self.frame.origin
        }
    }
    
    /// View's size.
    @objc
    var size: CGSize {
        set {
            self.frame = CGRect(
                x: self.x,
                y: self.y,
                width: _pixelIntegral(newValue.width),
                height: _pixelIntegral(newValue.height)
            )
        }
        get {
            return self.frame.size
        }
    }
    
    // MARK: - Extra Properties
    /// View's right side (x + width).
    @objc
    var right: CGFloat {
        set {
            self.x = newValue - self.width
        }
        get {
            return self.x + self.width
        }
    }
    
    /// View's bottom (y + height).
    @objc
    var bottom: CGFloat {
        set {
            self.y = newValue - self.height
        }
        get {
            return self.y + self.height
        }
    }
    
    /// View's top (y).
    @objc
    var top: CGFloat {
        set {
            self.y = newValue
        }
        get {
            return self.y
        }
    }
    
    /// View's left side (x).
    @objc
    var left: CGFloat {
        set {
            self.x = newValue
        }
        get {
            return self.x
        }
    }
    
    /// View's center X value (center.x).
    @objc
    var centerX: CGFloat {
        set {
            self.center = CGPoint(x: newValue, y: self.centerY)
        }
        get {
            return self.center.x
        }
    }
    
    /// View's center Y value (center.y).
    @objc
    var centerY: CGFloat {
        set {
            self.center = CGPoint(x: self.centerX, y: newValue)
        }
        get {
            return self.center.y
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
        set {
            self.bounds = CGRect(
                x: _pixelIntegral(newValue),
                y: self.boundsY,
                width: self.boundsWidth,
                height: self.boundsHeight
            )
        }
        get {
            return self.bounds.origin.x
            
        }
    }
    
    /// Y value of bounds (bounds.origin.y).
    @objc
    var boundsY: CGFloat {
        set {
            self.frame = CGRect(
                x: self.boundsX,
                y: _pixelIntegral(newValue),
                width: self.boundsWidth,
                height: self.boundsHeight
            )
        }
        get {
            return self.bounds.origin.y
        }
    }
    
    /// Width of bounds (bounds.size.width).
    @objc
    var boundsWidth: CGFloat {
        set {
            self.frame = CGRect(
                x: self.boundsX,
                y: self.boundsY,
                width: _pixelIntegral(newValue),
                height: self.boundsHeight
            )
        }
        get {
            return self.bounds.size.width
        }
    }
    
    /// Height of bounds (bounds.size.height).
    @objc
    var boundsHeight: CGFloat {
        set {
            self.frame = CGRect(
                x: self.boundsX,
                y: self.boundsY,
                width: self.boundsWidth,
                height: _pixelIntegral(newValue)
            )
        }
        get {
            return self.bounds.size.height
            
        }
    }
    
    // MARK: - Useful Methods
    /// Center view to it's parent view.
    @available(iOS 10, *)
    @objc
    func centerToParent() {
        #if os(iOS)
        guard let superview = self.superview else { return }

        switch UIApplication.shared.statusBarOrientation {
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
