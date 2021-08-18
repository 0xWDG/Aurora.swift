// $$FILE$$

#if canImport(UIKit)
import Foundation
import UIKit

public extension UITextField {
    /// Padding Value
    @IBInspectable var paddingValue: CGFloat {
        get {
            return self.paddingValue
        }
        set {
            self.paddingValue = newValue
        }
    }

    /// Get the padding value
    var padding: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: paddingValue, bottom: 0, right: paddingValue)
    }
}
#endif
