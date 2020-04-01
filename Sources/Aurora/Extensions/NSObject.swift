// $$HEADER$$

import Foundation
import UIKit

public protocol Configure {}

extension Configure {
    /// Makes it available to set properties with closures just after initializing.
    ///
    ///     let frame = UIView().configure {
    ///       $0.backgroundColor = .red
    ///     }
    public func configure(_ block: (inout Self) -> Void) -> Self {
        var copy = self
        block(&copy)
        return copy
    }
    
}

extension NSObject: Configure {}
