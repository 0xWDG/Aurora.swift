// $$HEADER$$

#if canImport(Foundation)
import Foundation
#endif

#if canImport(UIKit)
import UIKit
#endif

#if canImport(CoreGraphics)
import CoreGraphics
#endif

#if os(iOS) || os(tvOS)
  import UIKit.UIGeometry
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
    
    /// Makes it available to execute something with closures.
    ///
    ///     UserDefaults.standard.do {
    ///       $0.set("devxoul", forKey: "username")
    ///       $0.set("devxoul@gmail.com", forKey: "email")
    ///       $0.synchronize()
    ///     }
    public func `do`(_ block: (Self) throws -> Void) rethrows {
      try block(self)
    }
}

extension NSObject: Configure {}
extension CGPoint: Configure {}
extension CGRect: Configure {}
extension CGSize: Configure {}
extension CGVector: Configure {}
extension Array: Configure {}
extension Dictionary: Configure {}
extension Set: Configure {}

#if os(iOS) || os(tvOS)
  extension UIEdgeInsets: Configure {}
  extension UIOffset: Configure {}
  extension UIRectEdge: Configure {}
#endif

extension NSObject {
    public var className: String {
        return type(of: self).className
    }
    
    public static var className: String {
        return String(describing: self)
    }
}
#endif
