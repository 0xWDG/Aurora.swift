// $$HEADER$$

#if canImport(NibView)
import NibView
#endif
import UIKit

/**
 `NibLoadable` helps you reuse views created in .xib files.
 
 # Reference only from code
 Setup class by conforming to `NibLoadable`:
 
 class MyView: UIView, NibLoadable {}
 
 Get the view loaded from nib with a one-liner:
 
 let myView = MyView.fromNib()
 
 Setup like this will look for a file named "MyView.xib" in your project and load the view that is of type `MyView`.
 
 *Optionally* provide custom nib name (defaults to type name):
 
 class var nibName: String { return "MyCustomView" }
 *Optionally* provide custom bundle (defaults to class location):
 
 class var bundle: Bundle { return Bundle(for: self) }
 
 # Refencing from IB
 
 To reference view from another .xib or .storyboard file simply subclass `NibView`:
 
 class MyView: NibView {}
 
 If subclassing is **not an option** override `awakeAfter(using:)` with a call to `nibLoader`:
 
 class MyView: SomeBaseView, NibLoadable {
 open override func awakeAfter(using aDecoder: NSCoder) -> Any? {
 return nibLoader.awakeAfter(using: aDecoder,
 super.awakeAfter(using: aDecoder))
 }
 }
 
 # @IBDesignable referencing from IB
 
 To see live updates and get intrinsic content size of view reference simply subclass `NibView` with `@IBDesignable` attribute:
 
 @IBDesignable
 class MyView: NibView {}
 
 If subclassing is **not an option** override functions of the view with calls to `nibLoader`:
 
 @IBDesignable
 class MyView: SomeBaseView, NibLoadable {
 
 open override func awakeAfter(using aDecoder: NSCoder) -> Any? {
 return nibLoader.awakeAfter(using: aDecoder, super.awakeAfter(using: aDecoder))
 }
 
 #if TARGET_INTERFACE_BUILDER
 
 public override init(frame: CGRect) {
 super.init(frame: frame)
 nibLoader.initWithFrame()
 }
 
 public required init?(coder aDecoder: NSCoder) {
 super.init(coder: aDecoder)
 }
 
 open override func prepareForInterfaceBuilder() {
 super.prepareForInterfaceBuilder()
 nibLoader.prepareForInterfaceBuilder()
 }
 
 open override func setValue(_ value: Any?, forKeyPath keyPath: String) {
 super.setValue(value, forKeyPath: keyPath)
 nibLoader.setValue(value, forKeyPath: keyPath)
 }
 
 #endif
 }
 
 */
public protocol NibLoadable: class {
    static var nibName: String { get }
    static var bundle: Bundle { get }
}

// MARK: - From Nib
public extension NibLoadable where Self: UIView {
    
    static var nibName: String {
        return String(describing: self)
    }
    
    static var bundle: Bundle {
        return Bundle(for: self)
    }
    
    static func fromNib() -> Self {
        guard let nib = self.bundle.loadNibNamed(nibName, owner: nil, options: nil) else {
            fatalError("Failed loading the nib named \(nibName) for 'NibLoadable' view of type '\(self)'.")
        }
        guard let view = (nib.first { $0 is Self }) as? Self else {
            fatalError("Did not find 'NibLoadable' view of type '\(self)' inside '\(nibName).xib'.")
        }
        return view
    }
}

public extension NibLoadable where Self: UIView {
    var nibLoader: IBNibLoader<Self> { return IBNibLoader(self) }
}

public struct IBNibLoader<NibLoadableView: NibLoadable> where NibLoadableView: UIView {
    
    public func awakeAfter(using aDecoder: NSCoder, _ superMethod: @autoclosure () -> Any?) -> Any? {
        guard nonPrivateSubviews.isEmpty else { return superMethod() }
        
        let nibView = type(of: view).fromNib()
        copyProperties(to: nibView)
        copyConstraints(to: nibView)
        
        return nibView
    }
    
    public func initWithFrame() {
        let nibView = type(of: view).fromNib()
        copyProperties(to: nibView)
        SubviewsCopier.copySubviewReferences(from: nibView, to: view)
        
        nibView.frame = view.bounds
        nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(nibView)
    }
    
    public func prepareForInterfaceBuilder() {
        if nonPrivateSubviews.count == 1 {
            // Used as a reference container
            view.backgroundColor = .clear
        } else {
            // Is original .xib file
            nonPrivateSubviews.first?.removeFromSuperview()
        }
    }
    
    public func setValue(_ value: Any?, forKeyPath keyPath: String) {
        guard let subview = value as? UIView else { return }
        SubviewsCopier.store(subview: subview, forKeyPath: keyPath, of: view)
    }
    
    
    // MARK: - Private
    
    private let view: NibLoadableView
    fileprivate init(_ view: NibLoadableView) {
        self.view = view
    }
    
    private var nonPrivateSubviews: [UIView] {
        return view.subviews.filter { !String(describing: type(of: $0)).hasPrefix("_") }
    }
    
    private func copyProperties(to nibView: UIView) {
        nibView.frame = view.frame
        nibView.autoresizingMask = view.autoresizingMask
        nibView.translatesAutoresizingMaskIntoConstraints = view.translatesAutoresizingMaskIntoConstraints
        nibView.clipsToBounds = view.clipsToBounds
        nibView.alpha = view.alpha
        nibView.isHidden = view.isHidden
    }
    
    private func copyConstraints(to nibView: UIView) {
        nibView.addConstraints(
            view.constraints.map {
                NSLayoutConstraint(
                    item: $0.firstItem === view ? nibView : $0.firstItem as Any,
                    attribute: $0.firstAttribute,
                    relatedBy: $0.relation,
                    toItem: $0.secondItem === view ? nibView : $0.secondItem,
                    attribute: $0.secondAttribute,
                    multiplier: $0.multiplier,
                    constant: $0.constant)
            }
        )
    }
}


fileprivate struct SubviewsCopier {
    
    static var viewKeyPathsForSubviews = [UIView: [String: UIView]]()
    
    static func store(subview: UIView, forKeyPath keyPath: String, of view: UIView) {
        if viewKeyPathsForSubviews[view] == nil {
            viewKeyPathsForSubviews[view] = [keyPath: subview]
        } else {
            viewKeyPathsForSubviews[view]?[keyPath] = subview
        }
    }
    
    static func copySubviewReferences(from view: UIView, to otherView: UIView) {
        viewKeyPathsForSubviews[view]?.forEach { otherView.setValue($0.value, forKeyPath: $0.key) }
        viewKeyPathsForSubviews[view] = nil
    }
}

public protocol NibViewController {
    associatedtype ViewType: NibLoadable
}

public extension NibViewController where Self: UIViewController {
    var ui: ViewType {
        guard let ui = view as? ViewType else {
            fatalError("'\(type(of: self))' 'view' type did not match the 'ViewType' declared in conformance to 'NibViewController' protocol.Found \(type(of: view)) instead of expected '\(ViewType.self)'")
        }
        return ui
    }
}

open class NibView: UIView, NibLoadable {
    
    open class var nibName: String {
        return String(describing: self)
    }
    
    open class var bundle: Bundle {
        return Bundle(for: self)
    }
    
    open override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        return nibLoader.awakeAfter(using: aDecoder, super.awakeAfter(using: aDecoder))
    }
    
    // MARK: - Interface builder
    
    #if TARGET_INTERFACE_BUILDER
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibLoader.initWithFrame()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        nibLoader.prepareForInterfaceBuilder()
    }
    
    open override func setValue(_ value: Any?, forKeyPath keyPath: String) {
        super.setValue(value, forKeyPath: keyPath)
        nibLoader.setValue(value, forKeyPath: keyPath)
    }
    
    #endif
}
