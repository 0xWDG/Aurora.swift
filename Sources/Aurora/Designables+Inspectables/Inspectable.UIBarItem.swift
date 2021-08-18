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

#if os(iOS) || os(tvOS)
import UIKit

extension UIBarItem {
    struct Properties {
        static var identifier = "identifier"
    }

    /// Identifier
    @IBInspectable public var identifier: String? {
        get {
            return self.property(forKey: &Properties.identifier) as? String
        }
        set {
            self.property(newValue as Any, forKey: &Properties.identifier)
        }
    }
}
#endif
