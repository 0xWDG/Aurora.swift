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
    /// is darkmode enabled
    var isDarkModeEnabled: Bool {
        // swiftlint:disable:next implicit_getter
        get {
            return traitCollection.userInterfaceStyle == .dark
        }
    }
    
    /// is darkmode enabled
    var darkMode: Bool {
        // swiftlint:disable:next implicit_getter
        get {
            return traitCollection.userInterfaceStyle == .dark
        }
    }
    
    /// Safe area
    var safeArea: UILayoutGuide {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide
        } else {
            return layoutMarginsGuide
        }
    }
    
    /// set the corner radius
    /// - Parameter radius: which radius
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
    
    /// Remove the last Subview
    func removeLastSubview() {
        let intVal = (layer.sublayers?.count)! - 1
        layer.sublayers?.remove(at: intVal)
    }
    
    /// Same size as parent
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
    
    /// Return view as Image
    /// - Returns: View as Image
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    /// Is the font visible?
    var visibleFont: UIFont? {
        if let textView = self as? UITextView {
            return textView.font
        } else if let label = self as? UILabel {
            return label.font
        } else if let button = self as? UIButton {
            return button.titleLabel?.font
        } else if let textField = self as? UITextField {
            return textField.font
        }
        
        return nil
    }
    
    // MARK: - placehodlerView
    func placeholderView() {
        // Remove old ones, if present
        placehodlerViewRemove()
        
        // Add placeholderView.
        addPlaceholderView()
    }
    
    /// Add placeholderview
    func addPlaceholderView() {
        DispatchQueue.main.async {
            let gradientBackground: CGColor = #colorLiteral(red: 0.8381932378, green: 0.8472757339, blue: 0.879475534, alpha: 1).cgColor
            let gradientBackgroundMove: CGColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
            let shimmerStartLocation: [NSNumber] = [-1.0, -0.5, 0.0]
            let shimmerEndLocation: [NSNumber] = [1.0, 1.5, 2.0]
            var shimmerGradienLayer: CAGradientLayer!
            
            let gradientLayered = CAGradientLayer().configure {
                $0.frame = self.bounds
                $0.startPoint = CGPoint(x: 0, y: 1)
                $0.endPoint = CGPoint(x: 1, y: 1)
                $0.colors = [
                    gradientBackground,
                    gradientBackgroundMove,
                    gradientBackground
                ]
                $0.locations = shimmerStartLocation
                $0.name = "placehodlerViewLayer"
            }
            
            self.layer.addSublayer(gradientLayered)
            shimmerGradienLayer = gradientLayered
            
            // Start Animating
            let animation = CABasicAnimation(keyPath: "locations").configure {
                $0.fromValue = shimmerStartLocation
                $0.toValue = shimmerEndLocation
                $0.duration = 0.8
                $0.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            }
            
            let animationGroup = CAAnimationGroup().configure {
                $0.duration = 1.8
                $0.animations = [animation]
                $0.repeatCount = .infinity
            }
            
            shimmerGradienLayer?.add(
                animationGroup,
                forKey: animation.keyPath
            )
        }
    }
    
    /// Remove placeholder view
    func placehodlerViewRemove() {
        if let layers = self.layer.sublayers {
            for layer in layers where layer.name == "placehodlerViewLayer" {
                DispatchQueue.main.async {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
    
    /// Alias to placehodlerViewRemove
    func removePlaceholderView() {
        self.placehodlerViewRemove()
    }
    
    // MARK: -
    
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
