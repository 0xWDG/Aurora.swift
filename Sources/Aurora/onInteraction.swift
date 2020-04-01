// $$HEADER$$

import Foundation
import UIKit

#if canImport(UIKit)
extension UIControl {
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
    public func onInteraction(
        for controlEvents: UIControl.Event = .primaryActionTriggered,
        action: @escaping (AnyObject) -> Void
    ) {
        let helper = UIControlHelper(
            attachTo: self,
            closure: action
        )
        
        addTarget(
            helper,
            action: #selector(UIControlHelper.invoke),
            for: controlEvents
        )
    }
}

class UIControlHelper {
    let closure: (AnyObject) -> Void
    
    public init(attachTo: AnyObject, closure: @escaping (AnyObject) -> Void) {
        self.closure = closure
        objc_setAssociatedObject(
            attachTo,
            "[\(arc4random())]",
            self,
            .OBJC_ASSOCIATION_RETAIN
        )
    }
    
    @objc func invoke(sender: AnyObject) {
        closure(sender)
    }
}
#endif

#if canImport(AppKit)
// see https://gist.github.com/sindresorhus/3580ce9426fff8fafb1677341fca4815
// renamed onAction to onInteraction
extension NSControl {
    typealias ActionClosure = ((NSControl) -> Void)
    
    private struct AssociatedKeys {
        static let onActionClosure = AssociatedObject<ActionClosure>()
    }
    
    @objc
    private func callClosure(_ sender: NSControl) {
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
    public var onInteraction: ActionClosure? {
        // swiftlint:disable:next implicit_getter
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
