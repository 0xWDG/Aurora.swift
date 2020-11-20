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

public extension UIView {
    /// Ignore invert colors?
    @IBInspectable var ignoresInvertColors: Bool {
        get {
            return accessibilityIgnoresInvertColors
        }
        set {
            accessibilityIgnoresInvertColors = newValue
        }
    }
    
    /// is darkmode enabled
    var isDarkModeEnabled: Bool {
        get {
            return traitCollection.userInterfaceStyle == .dark
        }
    }

    /// is darkmode enabled
    var darkMode: Bool {
        get {
            return traitCollection.userInterfaceStyle == .dark
        }
    }
    
    /// <#Description#>
    /// - Parameter radius: <#radius description#>
    func roundedCorners(radius: CGFloat? = 45) {
        self.layer.cornerRadius = radius ?? 46
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - corners: <#corners description#>
    ///   - radius: <#radius description#>
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(
                width: radius,
                height: radius
            )
        )
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        layer.masksToBounds = true
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - colorOne: <#colorOne description#>
    ///   - colorTwo: <#colorTwo description#>
    func gradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.2)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - colorOne: <#colorOne description#>
    ///   - colorTwo: <#colorTwo description#>
    func addGradientOnForeground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.2)
        
        let intVal = layer.sublayers?.count
        layer.insertSublayer(gradientLayer, at: UInt32(truncating: intVal! as NSNumber))
    }
    
    /// <#Description#>
    func removeLastSubview() {
        let intVal = (layer.sublayers?.count)! - 1
        layer.sublayers?.remove(at: intVal)
    }
    
    /// <#Description#>
    func sameSizeAsParent() {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = superview.translatesAutoresizingMaskIntoConstraints
        if translatesAutoresizingMaskIntoConstraints {
            autoresizingMask = [.flexibleWidth, .flexibleHeight]
            frame = superview.bounds
        } else {
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
        }
    }
    
    // Animate a view, adding effect of "something went wrong". Useful for login button for example.
    /// - Parameter repeatAnimation: Repeat the animation?
    func shakeWrong(_ repeatAnimation: Bool? = false) {
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.configure {
            $0.duration = 0.05
            $0.repeatCount = 5
            $0.autoreverses = true
            $0.fromValue = CGPoint(
                x: self.center.x - 4.0,
                y: self.center.y
            )
            $0.toValue = CGPoint(
                x: self.center.x + 4.0,
                y: self.center.y
            )
        }
        
        if let repeatAnimation = repeatAnimation, repeatAnimation == true {
            shakeAnimation.repeatCount = Float.infinity
        }
        
        self.layer.add(shakeAnimation, forKey: "position")
    }
    
    /// Wiggle
    /// - Parameter repeatAnimation: repeat?
    func wiggle(_ repeatAnimation: Bool? = true) {
        let wiggleAnimation = CAKeyframeAnimation(keyPath: "transform")
        wiggleAnimation.configure {
            $0.values  = [
                NSValue(caTransform3D: CATransform3DMakeRotation(0.04, 0.0, 0.0, 1.0)),
                NSValue(caTransform3D: CATransform3DMakeRotation(-0.04, 0, 0, 1))
            ]
            $0.autoreverses = true
            $0.duration = 0.115
        }
        
        if let repeatAnimation = repeatAnimation, repeatAnimation == true {
            wiggleAnimation.repeatCount = Float.infinity
        }
        
        self.layer.add(wiggleAnimation, forKey: "transform")
    }
    
    /// <#Description#>
    struct GestureClosures {
        // swiftlint:disable:next identifier_name
        static var up: (() -> Void)?
        static var down: (() -> Void)?
        static var left: (() -> Void)?
        static var right: (() -> Void)?
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - swipeDirection: <#swipeDirection description#>
    ///   - completionHandler: <#completionHandler description#>
    func swipeAction(
        swipeDirection: UISwipeGestureRecognizer.Direction,
        completionHandler: @escaping () -> Void
    ) {
        let swiper = UISwipeGestureRecognizer(target: self, action: #selector(self.invokeTarget(_:)))
        
        swiper.direction = swipeDirection
        self.addGestureRecognizer(swiper)
        
        switch swipeDirection {
        case .up:
            GestureClosures.up = completionHandler
            
        case .down:
            GestureClosures.down = completionHandler
            
        case .left:
            GestureClosures.left = completionHandler
            
        case .right:
            GestureClosures.right = completionHandler
            
        default:
            return
        }
    }
    
    /// <#Description#>
    /// - Parameter gesture: <#gesture description#>
    @objc
    func invokeTarget(_ gesture: UIGestureRecognizer?) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .up:
                guard let execute = GestureClosures.up else {
                    return
                }
                execute()
                
            case .down:
                guard let execute = GestureClosures.down else {
                    return
                }
                execute()
                
            case .left:
                guard let execute = GestureClosures.left else {
                    return
                }
                execute()
                
            case .right:
                guard let execute = GestureClosures.right else {
                    return
                }
                execute()
                
            default:
                return
            }
        }
    }
}

/// <#Description#>
public protocol Blurable {
    /// <#Description#>
    /// - Parameter alpha: <#alpha description#>
    func addBlur(_ alpha: CGFloat)
}

public extension Blurable where Self: UIView {
    /// <#Description#>
    /// - Parameter alpha: <#alpha description#>
    func addBlur(_ alpha: CGFloat = 0.5) {
        // create effect
        let effect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: effect)
        
        // set boundry and alpha
        effectView.frame = self.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effectView.alpha = alpha
        
        self.addSubview(effectView)
    }
}

// Conformance
extension UIView: Blurable {}
#endif
