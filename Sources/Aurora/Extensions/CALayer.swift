//

#if canImport(UIKit)
import Foundation
import UIKit

public extension CALayer {
    @IBInspectable var xcornerRadius: CGFloat {
        get {
            return self.cornerRadius 
        }
        set {
            self.cornerRadius = newValue
            setNeedsLayout()
        }
    }
}
#endif
