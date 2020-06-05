// $$HEADER$$

import Foundation
import UIKit
import QuartzCore

@IBDesignable public class UIViewRounded: UIView {
    /// Radius for the UIViewRounded
    @IBInspectable public var radius: CGFloat = 24
    
    /// Draw a rounded view
    /// - Parameter rect: The portion of the view’s bounds that needs to be updated. The first time your view is drawn, this rectangle is typically the entire visible bounds of your view. However, during subsequent drawing operations, the rectangle may specify only part of your view.
    public override func draw(_ rect: CGRect) {
        super.draw(rect)

        self.roundCorners(
            corners: [.allCorners],
            radius: radius
        )
    }
}
