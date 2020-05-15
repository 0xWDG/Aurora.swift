// $$HEADER$$

import Foundation
import UIKit

extension UITableView {
    /// Dequeues reusable UITableViewCell using class name for indexPath.
    ///
    /// - Parameters:
    ///   - type: UITableViewCell type.
    ///   - indexPath: Cell location in collectionView.
    /// - Returns: UITableViewCell object with associated class name.
    public func dequeueReusableCell<T: UITableViewCell>(ofType type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: type.className, for: indexPath) as? T else {
            fatalError("Couldn't find UITableViewCell of class \(type.className)")
        }
        return cell
    }
    
    /// Scroll tableview to bottom
    ///
    /// - Parameters:
    ///   - animated: Animation?
    public func scrollToBottom_(animated: Bool) {
        let yPosition = (contentSize.height - frame.size.height) + 250
        if yPosition < 0 { return }
        
        setContentOffset(
            CGPoint(x: 0, y: yPosition),
            animated: animated
        )
    }
    
    /// Get/Set the cornerRadius
    public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
}
