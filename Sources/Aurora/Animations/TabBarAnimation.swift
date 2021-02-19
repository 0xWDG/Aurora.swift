// $$HEADER$$

#if canImport(UIKit)
import Foundation
import UIKit

/// Available animations for UITabBarItems
public enum TabBarItemAnimation {
    case bounce
    case jump
    case rotate
    case rotateRight
    case rotateLeft
    case shake
    case custom((UIImageView) -> Void)
}

/// Animates UITabBarItem Image View with custom animation.
///
/// Example implementation
///
///     class BaseTabBarController: UITabBarController { }
///
///     extension BaseTabBarController: TabBarAnimation {
///         override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
///             playAnimation(type: .rotate, for: item)
///         }
///     }
///
/// /
public protocol TabBarAnimation: UITabBarController {
    /// Animates UITabBarItem Image View with custom animation.
    ///
    /// Example implementation
    ///
    ///     override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    ///         playAnimation(type: .scale, for: item)
    ///     }
    ///
    /// - Parameters:
    ///   - type: Desired animation provided from TabBarItemAnimation.
    ///   - item: UITabBarItem to be animated.
    func playAnimation(type: TabBarItemAnimation, for item: UITabBarItem)
}

/// Implementation of SimpleTabBarAnimation
public extension TabBarAnimation {
    func playAnimation(type: TabBarItemAnimation, for item: UITabBarItem) {
        // Classic TabBar
        // Black or white tabbar
        // 0              -> 1 = map = imageView
        // UITabBarButton -> UITabbarSwappableImageView
        if let idx = tabBar.items?.firstIndex(of: item),
              tabBar.subviews.count > idx + 1,
              let imageView = tabBar.subviews[idx + 1].subviews.compactMap({ $0 as? UIImageView }).first {
            
            playAnimation(type: type, imageView: imageView)
        }
        
        // Transculent TabBar
        // 0              -> 1 (visualEffectView) -> 2 (visualContentView)      -> 3 = map = imageView
        // UITabBarButton -> UIVisualEffectView   -> _UIVisualEffectContentView -> UITabbarSwappableImageView
        if let idx = tabBar.items?.firstIndex(of: item),
           tabBar.subviews.count > idx + 1,
           let visualEffectView = tabBar.subviews[idx + 1].subviews.first,
           let visualContentView = visualEffectView.subviews.first,
           let imageView = visualContentView.subviews.compactMap({ $0 as? UIImageView }).first {

            playAnimation(type: type, imageView: imageView)
        }
    }
    
    private func playAnimation(type: TabBarItemAnimation, imageView: UIImageView) {
        switch type {
        case .bounce:
            bounceAnimation(for: imageView)
        case .jump:
            jumpAnimation(for: imageView)
        case .rotateRight, .rotate:
            rotateRightAnimation(for: imageView)
        case .rotateLeft:
            rotateLeftAnimation(for: imageView)
        case .shake:
            shakeAnimation(for: imageView)
        case .custom(let animation):
            animation(imageView)
        }
    }
    
    private func bounceAnimation(for item: UIImageView) {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = 0.5
        bounceAnimation.calculationMode = .cubic
        
        item.layer.add(bounceAnimation, forKey: nil)
    }
    
    private func jumpAnimation(for item: UIImageView) {
        let jumpAnimation = CAKeyframeAnimation(keyPath: "position.y")
        jumpAnimation.values = [1.05, 1.1, 1.15, 1.1, 1.05]
        jumpAnimation.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
        jumpAnimation.duration = 0.25
        jumpAnimation.isAdditive = true
        
        item.layer.add(jumpAnimation, forKey: "move")
    }
    
    private func rotateRightAnimation(for item: UIImageView) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat.pi * 2
        rotateAnimation.duration = 1.0
        
        item.layer.add(rotateAnimation, forKey: nil)
    }
    
    private func rotateLeftAnimation(for item: UIImageView) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = CGFloat.pi * 2
        rotateAnimation.toValue = 0.0
        rotateAnimation.duration = 1.0
        
        item.layer.add(rotateAnimation, forKey: nil)
    }
    
    private func shakeAnimation(for item: UIImageView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.5
        animation.repeatCount = 2
        animation.autoreverses = true
        
        animation.fromValue = CGPoint.init(
            x: item.center.x - 10,
            y: item.center.y
        )
        
        animation.toValue = CGPoint.init(
            x: item.center.x + 10,
            y: item.center.y
        )

        item.layer.add(animation, forKey: "position")
    }
}
#endif
