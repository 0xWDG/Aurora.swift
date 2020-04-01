// $$HEADER$$

import Foundation
import UIKit

extension UITableView {
    public func scrollToBottom_(animated: Bool) {
        let yPosition = (contentSize.height - frame.size.height) + 250
        if yPosition < 0 { return }
        
        setContentOffset(
            CGPoint(x: 0, y: yPosition),
            animated: animated
        )
    }
    
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
