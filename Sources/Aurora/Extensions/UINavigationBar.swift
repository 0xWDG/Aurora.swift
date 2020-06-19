// $$HEADER$$

import Foundation

#if canImport(UIKit)
import UIKit

extension UINavigationBar {
    /// Make a clear background color
    ///
    /// Example
    ///
    ///     navigationController?.navigationBar.makeClear()
    func makeClear() {
        shadowImage = UIImage()
        setBackgroundImage(UIImage(), for: .default)
        backgroundColor = .clear
    }
}

#endif
