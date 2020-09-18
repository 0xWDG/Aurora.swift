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
// Please note: this is a beta version.
// It can contain bugs, please report all bugs to https://github.com/AuroraFramework/Aurora.swift
//
// Thanks for using!
//
// Licence: Needs to be decided.

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
#if canImport(UIKit)
  import UIKit.UIGeometry
#endif
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
    @discardableResult public func configure(_ block: (inout Self) -> Void) -> Self {
        var copy = self
        block(&copy)
        return copy
    }
    
    /// Makes it available to execute something with closures.
    ///
    ///     UserDefaults.standard.do {
    ///       $0.set("test", forKey: "username")
    ///       $0.set("my_email@gmail.com", forKey: "email")
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

// NSO callbackKey
private var callbackKey = "ObjCallbackKey"

extension NSObject {    
    /// The name of a the type inheriting of `NSObject`
    public static var className: String {
        String(describing: self)
    }
    
    /// <#Description#>
    public var className: String {
        return type(of: self).className
    }
        
    /// <#Description#>
    @objc
    private class CallbackHolder: NSObject {
        var callbacks = [() -> Void]()
        
        deinit {
            callbacks.forEach {
                $0()
            }
        }
    }
    
    /// <#Description#>
    /// - Parameter object: <#object description#>
    /// - Returns: <#description#>
    private static func getHolder(of object: NSObject) -> CallbackHolder {
        if let existing = objc_getAssociatedObject(object, &callbackKey) as? NSObject.CallbackHolder {
            return existing
        } else {
            let new = CallbackHolder()
            objc_setAssociatedObject(object, &callbackKey, new, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return new
        }
    }
    
    /// Run on Deinit
    /// - Parameters:
    ///   - object: Object class.
    ///   - block: Run after deinit
    ///
    /// **example:**
    ///
    ///      func createViewController() {
    ///           // We'll init a VC as example.
    ///           let viewController = UIViewController()
    ///
    ///           // Actual code
    ///           NSObject.onDeinit(of: viewController) {
    ///               Aurora.shared.log("The viewcontroller dissapeared")
    ///           }
    ///      }
    public static func onDeinit(of object: NSObject, do block: @escaping () -> Void) {
        getHolder(of: object).callbacks.append(block)
    }
}
#endif
