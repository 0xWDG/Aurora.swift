// $$HEADER$$

import Foundation

#if canImport(UIKit)
import UIKit

extension UIBarButtonItem {
    public var frame: CGRect? {
        guard let view = self.value(forKey: "view") as? UIView else {
            return nil
        }
        return view.frame
    }
    
    public var view: UIView? {
        guard let view = self.value(forKey: "view") as? UIView else {
            return nil
        }
        return view
    }
}
#endif
