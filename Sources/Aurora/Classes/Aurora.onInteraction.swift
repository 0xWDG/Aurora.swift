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

import Foundation

/// AssociationPolicy
enum AssociationPolicy {
    case assign
    case retainNonatomic
    case copyNonatomic
    case retain
    case copy

    var rawValue: objc_AssociationPolicy {
        switch self {
        case .assign:
            return .OBJC_ASSOCIATION_ASSIGN
        case .retainNonatomic:
            return .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        case .copyNonatomic:
            return .OBJC_ASSOCIATION_COPY_NONATOMIC
        case .retain:
            return .OBJC_ASSOCIATION_RETAIN
        case .copy:
            return .OBJC_ASSOCIATION_COPY
        }
    }
}

/// ObjectAssociation (private use)
final class ObjectAssociation<T: Any> {
    private let policy: AssociationPolicy

    init(policy: AssociationPolicy = .retainNonatomic) {
        self.policy = policy
    }

    subscript(index: AnyObject) -> T? {
        get {
            guard let associatedObject = objc_getAssociatedObject(
                index,
                Unmanaged.passUnretained(self).toOpaque()
            ) as? T? else {
                fatalError("Could not cast to \(T.Type.self)")
            }

            return associatedObject
        }
        set {
            objc_setAssociatedObject(
                index,
                Unmanaged.passUnretained(self).toOpaque(),
                newValue,
                policy.rawValue
            )
        }
    }
}

#if canImport(UIKit) && !os(watchOS)
import UIKit

public extension UIControl {
    /// .onInteraction
    ///
    /// Do something on interaction
    ///
    /// - Parameters:
    ///   - controlEvents: For which control events?
    ///   - action: Which action needs to be executed.
    ///
    /// ​‎‎
    ///
    /// **Example**
    ///
    ///     myControlElement.onInteraction { sender in
    ///        print(sender)
    ///     }
    func onInteraction(
        for controlEvents: UIControl.Event = .primaryActionTriggered,
        action: @escaping (AnyObject) -> Void
    ) {
        /// UIControl Helper
        let helper = AuroraUIControlHelper(
            attachTo: self,
            closure: action
        )

        addTarget(
            helper,
            action: #selector(AuroraUIControlHelper.invoke),
            for: controlEvents
        )
    }
}

/// UI Control helper
public class AuroraUIControlHelper {
    /// Closure to run
    let closure: (AnyObject) -> Void

    /// Init helper
    /// - Parameters:
    ///   - attachTo: to UIControl
    ///   - closure: what to run?
    public init(attachTo: AnyObject, closure: @escaping (AnyObject) -> Void) {
        self.closure = closure
        objc_setAssociatedObject(
            attachTo,
            "[\(arc4random())]",
            self,
            .OBJC_ASSOCIATION_RETAIN
        )
    }

    /// Invoke
    /// - Parameter sender: from sender
    @objc func invoke(sender: AnyObject) {
        closure(sender)
    }
}

#endif

#if canImport(AppKit)
import AppKit

// Thanks @sindresorhus
// see https://gist.github.com/sindresorhus/3580ce9426fff8fafb1677341fca4815
// renamed onAction to onInteraction
public extension NSControl {
    /// Action closure
    typealias ActionClosure = ((NSControl) -> Void)

    /// AssociatedKeys
    private struct AssociatedKeys {
        static let onActionClosure = ObjectAssociation<ActionClosure>()
    }

    /// call Closure
    /// - Parameter sender: sender
    @objc private func callClosure(_ sender: NSControl) {
        onInteraction?(sender)
    }

    /// .onInteraction
    ///
    /// Do something on interaction
    ///
    /// - Parameters:
    ///   - controlEvents: For which control events?
    ///   - action: Which action needs to be executed.
    ///
    /// ​‎‎
    ///
    /// **Example**
    ///
    ///     myControlElement.onInteraction { sender in
    ///        print(sender)
    ///     }
    var onInteraction: ActionClosure? {
        get {
            return AssociatedKeys.onActionClosure[self]
        }
        set {
            AssociatedKeys.onActionClosure[self] = newValue
            action = #selector(callClosure)
            target = self
        }
    }
}
#endif
