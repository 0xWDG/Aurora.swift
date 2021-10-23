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
/// Configurable protocol.
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
public protocol Configure {}

public extension Configure {
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
    @discardableResult func configure(_ block: (inout Self) -> Void) -> Self {
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
    func `do`(_ block: (Self) throws -> Void) rethrows {
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
extension URLRequest: Configure {}

#if os(iOS) || os(tvOS)
extension UIEdgeInsets: Configure {}
extension UIOffset: Configure {}
extension UIRectEdge: Configure {}
#endif

// NSO callbackKey
private var callbackKey = "ObjCallbackKey"

public extension NSObject {
    /// Run on Queue
    enum RunOnQueue {
        /// Run on background
        case background

        /// Run on foreground
        case foreground, main
    }
    /// The name of a the type inheriting of `NSObject`
    static var className: String {
        String(describing: self)
    }

    /// The class name
    var className: String {
        return type(of: self).className
    }

    /// Deinitialization callback holder
    @objc private class DeinitCallbackHolder: NSObject {
        var callbacks = [() -> Void]()

        deinit {
            callbacks.forEach {
                $0()
            }
        }
    }

    /// Get hoider of deinit object
    /// - Parameter object: the object
    /// - Returns: the callback/holder
    private static func getHolder(of object: NSObject) -> DeinitCallbackHolder {
        if let existing = objc_getAssociatedObject(object, &callbackKey) as? NSObject.DeinitCallbackHolder {
            return existing
        } else {
            let new = DeinitCallbackHolder()
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
    static func onDeinit(of object: NSObject, do block: @escaping () -> Void) {
        getHolder(of: object).callbacks.append(block)
    }

    /// Run on
    /// - Parameters:
    ///   - queue: Which queue
    ///   - execute: Run block.
    func run(on queue: RunOnQueue, execute work: @escaping () -> Void) {
        if queue == .background {
            DispatchQueue.global(qos: .background).async {
                work()
            }

            return
        }

        DispatchQueue.main.async {
            work()
        }
    }
}

/// Save properties to the Objective-C runtime of a object.
///
/// This is used to save things when it's not possible, like in extensions
///
/// **Extension Example:**
///
///     extension UIBarItem {
///         struct properties {
///             static var identifier = "identifier"
///         }
///
///         @IBInspectable public var identifier: String? {
///             get {
///                 return self.property(forKey: &properties.identifier) as? String
///             }
///             set {
///                 self.property(newValue as Any, forKey: &properties.identifier)
///             }
///         }
///     }
///
public protocol AssociatedProperties { }

public extension AssociatedProperties {
    /// Returns the value for the property identified by a given key.
    ///
    /// wrapper around `objc_getAssociatedObject`
    ///
    /// - Parameter forKey: The key for the association.
    /// - Returns: The value associated with the key key for object.
    func property(forKey key: UnsafeRawPointer) -> Any? {
        return objc_getAssociatedObject(self, key)
    }

    /// Sets an associated value for a current object using a given key.
    ///
    /// wrapper around `objc_setAssociatedObject`
    ///
    /// - Parameters:
    ///   - value: The value to associate with the key key for object. Pass nil to clear an existing association.
    ///   - forKey: The key for the association.
    func property(_ value: Any, forKey key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    /// Removes all associations for the current object.
    ///
    /// wrapper around `objc_removeAssociatedObjects`
    func removeAllProperties() {
        objc_removeAssociatedObjects(self)
    }
}

extension NSObject: AssociatedProperties {}
#endif
