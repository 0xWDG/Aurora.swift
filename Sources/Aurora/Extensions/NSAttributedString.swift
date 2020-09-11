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

#if canImport(Foundation)
import Foundation
#endif

#if os(iOS)
#if canImport(UIKit)
import UIKit

public extension NSMutableAttributedString {
    /// Make a string **bold**
    /// - Parameter text: The text what needs to be bold
    /// - Returns: a bold NSAttributedString
    @discardableResult
    func bold(_ text: String) -> NSMutableAttributedString {
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
    @discardableResult
    func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        self.append(normal)
        return self
    }

    /// Make a string **colored**
    ///   - toColor: text color
    ///   - backgroundColor: background color
    /// - Returns: a bold NSAttributedString
    @discardableResult
    func changeColor(toColor: UIColor, backgroundColor: UIColor?) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: toColor,
            .backgroundColor: backgroundColor ?? UIColor.clear
        ]
        
        self.addAttributes(
            attrs,
            range: NSRange(location: 0, length: self.string.count)
        )
        
        return self
    }
    
    /// <#Description#>
    /// - Parameter width: <#width description#>
    /// - Returns: <#description#>
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    /// <#Description#>
    /// - Parameter height: <#height description#>
    /// - Returns: <#description#>
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
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
#endif
