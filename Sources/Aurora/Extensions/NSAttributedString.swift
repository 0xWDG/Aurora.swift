// $$HEADER$$

import Foundation
#if os(iOS)
import UIKit

extension NSMutableAttributedString {
    /// Make a string **bold**
    /// - Parameter text: The text what needs to be bold
    /// - Returns: a bold NSAttributedString
    @discardableResult public func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(
                ofSize: UIFont.systemFontSize
            )
        ]
        
        let boldString = NSMutableAttributedString(
            string: "\(text)",
            attributes: attrs
        )
        
        self.append(boldString)
        return self
    }
    
    /// Make a string "normal"
    /// - Parameter text: The text what needs to be "normal"
    /// - Returns: a bold NSAttributedString
    @discardableResult public func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        self.append(normal)
        return self
    }

    /// Make a string **colored**
    ///   - toColor: text color
    ///   - backgroundColor: background color
    /// - Returns: a bold NSAttributedString
    @discardableResult public func changeColor(toColor: UIColor, backgroundColor: UIColor?) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: toColor,
            .backgroundColor: backgroundColor ?? UIColor.clear
        ]
        
        self.addAttributes(
            attrs,
            range: NSMakeRange(0, self.string.count)
        )
        
        return self
    }
}
#endif
