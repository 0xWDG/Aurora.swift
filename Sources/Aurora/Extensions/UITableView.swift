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
#if canImport(UIKit) && !os(watchOS)
import UIKit

public extension UITableView {
    /// Dequeues reusable UITableViewCell using class name for indexPath.
    ///
    /// - Parameters:
    ///   - type: UITableViewCell type.
    ///   - indexPath: Cell location in collectionView.
    /// - Returns: UITableViewCell object with associated class name.
    func dequeueReusableCell<T: UITableViewCell>(ofType type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: type.className, for: indexPath) as? T else {
            fatalError("Couldn't find UITableViewCell of class \(type.className)")
        }
        return cell
    }
    
    /// Scroll tableview to bottom
    ///
    /// - Parameters:
    ///   - animated: Animation?
    func scrollToBottom_(animated: Bool) {
        let yPosition = (contentSize.height - frame.size.height) + 250
        if yPosition < 0 { return }
        
        setContentOffset(
            CGPoint(x: 0, y: yPosition),
            animated: animated
        )
    }
}
#endif
