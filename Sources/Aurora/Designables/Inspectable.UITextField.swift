// $$FILE$$

#if canImport(UIKit)
import Foundation
import UIKit

public extension UITextField {
    @IBInspectable var paddingValue: CGFloat {
        get {
            return self.paddingValue
        }
        set {
            self.paddingValue = newValue
        }
    }
    
    var padding: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: paddingValue, bottom: 0, right: paddingValue)
    }
}
#endif
