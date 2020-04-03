// $$HEADER$$

import UIKit

extension UILabel {
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    public var padding: UIEdgeInsets? {
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
    
    override open func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: rect.inset(by: insets))
        } else {
            self.drawText(in: rect)
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        if let insets = padding {
            contentSize.height += insets.top + insets.bottom
            contentSize.width += insets.left + insets.right
        }
        return contentSize
    }
    
    public func HTMLString(_ text: String) {
        self.HTML(text)
    }

    public func HTML(_ text: String) {
        // swiftlint:disable:next force_try
        let attrStr = try! NSAttributedString(
            data: text.data(using: String.Encoding(rawValue: String.Encoding.unicode.rawValue), allowLossyConversion: true)!,
            options: [
                NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil)
        
        self.attributedText = attrStr
    }
}
