// $$HEADER$$

import Foundation
import UIKit

extension UITabBarController {
    public func select(withName: String) {
        var currentIndex = 0
        
        guard let items = tabBar.items else {
            return
        }
        
        for barItem in items {
            if barItem.title == withName {
                selectedIndex = currentIndex
                return
            }
            
            currentIndex += 1
        }
        
        print("Could not find item \(withName).")
    }
}
