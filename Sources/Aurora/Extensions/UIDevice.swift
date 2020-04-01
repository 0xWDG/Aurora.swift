// $$HEADER$$

import Foundation
import UIKit

extension UIDevice {
    public func isiPad() -> Bool {
        return (UIDevice.current.model.range(of: "iPad") != nil)
    }
}
