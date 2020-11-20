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

#if canImport(UIKit) && !os(watchOS)
import UIKit

public extension UILabel {
    /// <#Description#>
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    /// <#Description#>
    var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(
                self,
                &AssociatedKeys.padding
                ) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.padding,
                    newValue as UIEdgeInsets,
                    objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    //&AssociatedKeys.padding, newValue as UIEdgeInsets!,
    
    /// <#Description#>
    /// - Parameter rect: <#rect description#>
    override func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: rect.inset(by: insets))
        } else {
            self.drawText(in: rect)
        }
    }
    
    /// <#Description#>
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        if let insets = padding {
            contentSize.height += insets.top + insets.bottom
            contentSize.width += insets.left + insets.right
        }
        return contentSize
    }
    
    /// <#Description#>
    /// - Parameter text: <#text description#>
    func HTMLString(_ text: String) {
        self.HTML(text)
    }
    
    /// <#Description#>
    /// - Parameter text: <#text description#>
    func HTML(_ text: String) {
        // swiftlint:disable:next force_try
        let attrStr = try! NSAttributedString(
            data: text.data(
                using: String.Encoding(
                    rawValue: String.Encoding.unicode.rawValue
                ),
                allowLossyConversion: true
                )!,
            options: [
                NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil)
        
        self.attributedText = attrStr
    }
}
#endif
