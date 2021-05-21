// $$HEADER$$

#if canImport(UIKit)
import UIKit

public extension UIScrollView {
    func addExtraScrollAt(top value: CGFloat) {
        contentInset = UIEdgeInsets(top: value, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func addExtraScrollAt(left value: CGFloat) {
        contentInset = UIEdgeInsets(top: 0.0, left: value, bottom: 0.0, right: 0.0)
    }
    
    func addExtraScrollAt(bottom value: CGFloat) {
        contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: value, right: 0.0)
    }
    
    func addExtraScrollAt(right value: CGFloat) {
        contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: value)
    }
}
#endif
