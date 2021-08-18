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
// Thanks for using!
//
// Licence: MIT

#if canImport(UIKit) && !os(watchOS)
import UIKit

public extension UILabel {
    /// AssociatedKeys
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }

    /// Padding
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

    /// Draw rect
    /// - Parameter rect: rect size
    override func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: rect.inset(by: insets))
        } else {
            self.drawText(in: rect)
        }
    }

    /// intrinsicContentSize
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        if let insets = padding {
            contentSize.height += insets.top + insets.bottom
            contentSize.width += insets.left + insets.right
        }
        return contentSize
    }

    /// HTMLString (HTML)
    /// - Parameter text: Text
    func HTMLString(_ text: String) {
        self.HTML(text)
    }

    /// HTMLString
    /// - Parameter text: Text
    func HTML(_ text: String) {
        // swiftlint:disable:next force_try
        let attrStr = try! NSAttributedString(
            data: text.data(
                using: String.Encoding(
                    rawValue: String.Encoding.unicode.rawValue
                ),
                allowLossyConversion: true
                ).unwrap(orError: "Failed to convert HTML to NSAttributedString (Input is not a string)"),
            options: [
                NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil)

        self.attributedText = attrStr
    }
}
#endif
