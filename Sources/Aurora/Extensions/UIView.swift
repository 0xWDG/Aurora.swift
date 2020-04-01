// $$HEADER$$

import Foundation
import UIKit
import BaaS

extension UIView {
    func roundedCorners(radius: CGFloat? = 45) {
        self.layer.cornerRadius = radius ?? 46
    }
    
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
    
    func gradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.2)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addGradientOnForeground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.2)
        
        let intVal = layer.sublayers?.count
        layer.insertSublayer(gradientLayer, at: UInt32(truncating: intVal! as NSNumber))
    }
    
    func removeLastSubview() {
        let intVal = (layer.sublayers?.count)! - 1
        layer.sublayers?.remove(at: intVal)
    }
    
    struct GestureClosures {
        static var up: (() -> Void)?
        static var down: (() -> Void)?
        static var left: (() -> Void)?
        static var right: (() -> Void)?
    }
    
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
            BaaS.shared.log("Nothing")
        }
    }
    
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

protocol Blurable {
    func addBlur(_ alpha: CGFloat)
}

extension Blurable where Self: UIView {
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
