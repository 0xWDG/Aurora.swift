// $$HEADER$$

import Foundation

#if os(iOS)
import UIKit
import WebKit
extension UILabel {
    open func HTMLString(_ text: String) {
        self.HTML(text)
    }

    open func HTML(_ text: String) {
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
#endif
