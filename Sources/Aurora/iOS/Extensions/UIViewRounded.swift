// $$HEADER$$

import Foundation
import UIKit
import QuartzCore

@IBDesignable
class UIViewRounded: UIView {
    /// Radius for the UIViewRounded
    @IBInspectable public var radius: CGFloat = 24
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        self.roundCorners(
            corners: [.allCorners],
            radius: radius
        )
    }
}
