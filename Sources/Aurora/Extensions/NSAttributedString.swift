// $$HEADER$$

import Foundation
#if os(iOS)
import UIKit

public extension NSMutableAttributedString {
    @discardableResult public func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)]
        let boldString = NSMutableAttributedString(string: "\(text)", attributes: attrs)
        self.append(boldString)
        return self
    }
    
    @discardableResult public func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        self.append(normal)
        return self
    }

    @discardableResult public func changeColor(toColor: UIColor, backgroundColor: UIColor?) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: toColor,
            NSAttributedString.Key.backgroundColor: backgroundColor ?? UIColor.clear
        ]
        
        self.addAttributes(
            attrs,
            range: NSMakeRange(0, self.string.count)
        )
        
        return self
    }
}
#endif
