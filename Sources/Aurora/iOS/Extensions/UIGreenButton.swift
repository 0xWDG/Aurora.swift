// $$HEADER$$

import Foundation
import UIKit

@IBDesignable
public class UIGreenButton: UIButton {
    /// <#Description#>
    /// - Parameter frame: <#frame description#>
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /// <#Description#>
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setTitleColor(.white, for: .normal)
        
        backgroundColor = .button
        
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        
        updateFocusIfNeeded()
    }
    
    
    /// <#Description#>
    /// - Parameter coder: <#coder description#>
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
