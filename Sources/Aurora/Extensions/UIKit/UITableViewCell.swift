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
// Licence: MIT

#if canImport(UIKit) && os(iOS)
import UIKit

public extension UITableViewCell {
    /// Hides the separator below the cell.
    func hideSeparator() {
        let largeIndent = CGFloat.infinity
        separatorInset = UIEdgeInsets(top: 0.0, left: largeIndent, bottom: 0.0, right: 0.0)
        indentationWidth = largeIndent * -1.0
        indentationLevel = 1
    }
}
#endif
