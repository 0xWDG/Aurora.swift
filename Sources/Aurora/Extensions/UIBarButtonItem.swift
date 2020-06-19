// $$HEADER$$

import Foundation

#if canImport(UIKit)
import UIKit

extension UIBarButtonItem {
    /// <#Description#>
    public var frame: CGRect? {
        guard let view = self.value(forKey: "view") as? UIView else {
            return nil
        }
        return view.frame
    }
    
    /// <#Description#>
    public var view: UIView? {
        guard let view = self.value(forKey: "view") as? UIView else {
            return nil
        }
        return view
    }
}
#endif
