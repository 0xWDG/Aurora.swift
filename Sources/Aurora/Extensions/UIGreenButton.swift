// $$HEADER$$

import Foundation
import UIKit

@IBDesignable
public class UIGreenButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setTitleColor(.white, for: .normal)
        
        backgroundColor = .button
        
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        
        updateFocusIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
