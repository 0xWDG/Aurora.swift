// $$HEADER$$

import Foundation
import UIKit

extension UIView {
    /// Ignore invert colors?
    @IBInspectable var ignoresInvertColors: Bool {
        get {
            return accessibilityIgnoresInvertColors
        }
        set {
            accessibilityIgnoresInvertColors = newValue
        }
    }
    
    /// <#Description#>
    /// - Parameter radius: <#radius description#>
    public func roundedCorners(radius: CGFloat? = 45) {
        self.layer.cornerRadius = radius ?? 46
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - corners: <#corners description#>
    ///   - radius: <#radius description#>
    public func roundCorners(corners: UIRectCorner, radius: CGFloat) {
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
    public func gradientBackground(colorOne: UIColor, colorTwo: UIColor) {
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
    public func addGradientOnForeground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.2)
        
        let intVal = layer.sublayers?.count
        layer.insertSublayer(gradientLayer, at: UInt32(truncating: intVal! as NSNumber))
    }
    
    /// <#Description#>
    public func removeLastSubview() {
        let intVal = (layer.sublayers?.count)! - 1
        layer.sublayers?.remove(at: intVal)
    }
    
    /// <#Description#>
    public func sameSizeAsParent() {
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
    
    /// <#Description#>
    struct GestureClosures {
        static var up: (() -> Void)?
        static var down: (() -> Void)?
        static var left: (() -> Void)?
        static var right: (() -> Void)?
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - swipeDirection: <#swipeDirection description#>
    ///   - completionHandler: <#completionHandler description#>
    public func swipeAction(
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
    @objc func invokeTarget(_ gesture: UIGestureRecognizer?) {
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

extension Blurable where Self: UIView {
    /// <#Description#>
    /// - Parameter alpha: <#alpha description#>
    public func addBlur(_ alpha: CGFloat = 0.5) {
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
