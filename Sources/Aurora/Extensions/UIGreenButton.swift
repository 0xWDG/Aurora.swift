// Aurora framework for Swift
//
// The **Aurora.framework** contains a base for your project.
//
// It has a lot of extensions built-in to make development easier.
//
// - Version: 1.0
// - Copyright: [Wesley de Groot](https://wesleydegroot.nl) ([WDGWV](https://wdgwv.com))\
//  and [Contributors](https://github.com/AuroraFramework/Aurora.swift/graphs/contributors).
//
// Please note: this is a beta version.
// It can contain bugs, please report all bugs to https://github.com/AuroraFramework/Aurora.swift
//
// Thanks for using!
//
// Licence: Needs to be decided.

import Foundation
#if canImport(UIKit)
import UIKit

/// A Designable UIGreenButton
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
#endif
