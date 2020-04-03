// $$HEADER$$

#if canImport(Foundation)
import Foundation
#endif

#if canImport(UIKit)
import UIKit
#endif

#if canImport(Foundation)
public protocol Configure {}

extension Configure {
    /// Makes it available to set properties with closures just after initializing.
    ///
    /// iOS/WatchOS/tvOS
    ///
    ///     let frame = UIView().configure {
    ///       $0.backgroundColor = .red
    ///     }
    ///
    /// Or MacOS
    ///
    ///     let frame = NSView().configure {
    ///       $0.backgroundColor = .red
    ///     }
    public func configure(_ block: (inout Self) -> Void) -> Self {
        var copy = self
        block(&copy)
        return copy
    }
}

extension NSObject: Configure {}

extension NSObject {
    public var className: String {
        return type(of: self).className
    }
    
    public static var className: String {
        return String(describing: self)
    }
}
#endif
