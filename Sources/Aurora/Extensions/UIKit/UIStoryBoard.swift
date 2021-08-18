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

public extension UIStoryboard {
    /// Get the main application storyboard.
    class var main: UIStoryboard? {
        let bundle = Bundle.main
        guard let storyboardName = bundle.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String else {
            return nil
        }
        return UIStoryboard(name: storyboardName, bundle: bundle)
    }

}
#endif
