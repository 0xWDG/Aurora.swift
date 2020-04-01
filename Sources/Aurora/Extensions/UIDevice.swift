// $$HEADER$$

import Foundation
import UIKit

extension UIDevice {
    func isiPad() -> Bool {
        return (UIDevice.current.model.range(of: "iPad") != nil)
    }
}
