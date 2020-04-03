// $$HEADER$$

#if canImport(Foundation)
import Foundation
#endif

#if os(iOS)
import UIKit

public extension NSMutableAttributedString {
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

public extension NSAttributedString {
    /// Add a NSAttributedString to another NSAttributedString.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add to.
    ///   - rhs: NSAttributedString to add.
    static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        lhs = string
    }

    /// Add a NSAttributedString to another NSAttributedString and return a new NSAttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add.
    ///   - rhs: NSAttributedString to add.
    /// - Returns: New instance with added NSAttributedString.
    static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        return NSAttributedString(attributedString: string)
    }

    /// Add a NSAttributedString to another NSAttributedString.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add to.
    ///   - rhs: String to add.
    static func += (lhs: inout NSAttributedString, rhs: String) {
        lhs += NSAttributedString(string: rhs)
    }

    /// Add a NSAttributedString to another NSAttributedString and return a new NSAttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add.
    ///   - rhs: String to add.
    /// - Returns: New instance with added NSAttributedString.
    static func + (lhs: NSAttributedString, rhs: String) -> NSAttributedString {
        return lhs + NSAttributedString(string: rhs)
    }
}
#endif
