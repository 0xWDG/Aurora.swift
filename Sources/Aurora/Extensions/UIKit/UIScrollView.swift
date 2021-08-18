// $$HEADER$$

#if canImport(UIKit)
import UIKit

public extension UIScrollView {
    /// Add extra scroll at top
    /// - Parameter value: padding value
    func addExtraScrollAt(top value: CGFloat) {
        contentInset = UIEdgeInsets(top: value, left: 0.0, bottom: 0.0, right: 0.0)
    }

    /// Add extra scroll at left
    /// - Parameter value: padding value
    func addExtraScrollAt(left value: CGFloat) {
        contentInset = UIEdgeInsets(top: 0.0, left: value, bottom: 0.0, right: 0.0)
    }

    /// Add extra scroll at bottom
    /// - Parameter value: padding value
    func addExtraScrollAt(bottom value: CGFloat) {
        contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: value, right: 0.0)
    }

    /// Add extra scroll at right
    /// - Parameter value: padding value
    func addExtraScrollAt(right value: CGFloat) {
        contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: value)
    }
}
#endif
