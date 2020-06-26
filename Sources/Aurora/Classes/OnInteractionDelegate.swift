// $$HEADER$$

import Foundation

#if canImport(UIKit)
import UIKit

class AuroraOnTabBarInteractionDelegate: NSObject, UITabBarControllerDelegate, UITabBarDelegate {
    /// onInteraction closute
    public var onInteractionClosure: (() -> Void)?
    /// On x times
    public var onTimes: Int = 10
    
    /// old ViewController
    private var oldVC: ViewController?
    /// old UITabBarItem
    private var oldItem: UITabBarItem?
    
    /// The tap counter
    private var tapCounter: (Double, Int) = (0.0, 0)
    
    /// The shared instance, otherwise it will deinit direct
    static let sharedInstance: OnInteractionDelegate = OnInteractionDelegate()
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if oldItem != nil {
            if oldItem == item {
                let timestamp = CACurrentMediaTime()
                if tapCounter.0 < timestamp - 0.4 {
                    tapCounter.0 = timestamp
                    tapCounter.1 = 0
                }
                
                if tapCounter.0 >= timestamp - 0.4 {
                    tapCounter.0 = timestamp
                    tapCounter.1 += 1
                }
                
                if tapCounter.1 >= onTimes {
                    tapCounter.1 = 0
                    
                    onInteractionClosure?()
                }
            }
        }
        
        oldItem = item
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if oldVC != nil {
            if oldVC == viewController {
                let timestamp = CACurrentMediaTime()
                if tapCounter.0 < timestamp - 0.4 {
                    tapCounter.0 = timestamp
                    tapCounter.1 = 0
                }
                
                if tapCounter.0 >= timestamp - 0.4 {
                    tapCounter.0 = timestamp
                    tapCounter.1 += 1
                }
                
                if tapCounter.1 >= onTimes {
                    tapCounter.1 = 0
                    
                    onInteractionClosure?()
                }
            }
        }
        
        oldVC = viewController
    }
}

#endif
