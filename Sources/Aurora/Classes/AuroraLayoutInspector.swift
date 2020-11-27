// $$HEADER

#if canImport(UIKit)
import Foundation
import UIKit

open class AuroraLayoutInspector {
    /// Description
    static public let shared: AuroraLayoutInspector = AuroraLayoutInspector.init()
    
    public func startInspecting() {
        // Start.
    }
    
    public func captureHierarchy() -> ViewDescriptionProtocol? {
        guard let firstWindow = UIApplication.shared.windows.first else {
            return nil
        }
        
        return buildHierarchy(view: firstWindow)
    }
    
    func buildHierarchy(view: UIView) -> ViewDescriptionProtocol {
        let children = view.subviews.map {
            buildHierarchy(view: $0)
        }
        
        let viewsToHide = view.subviews.filter {
            $0.isHidden == false
        }
        
        // don't capture visible subviews for current view snapshot
        viewsToHide.forEach {
            $0.isHidden = true
        }
        
        let isTransparent = isViewTransparent(view)
        let image = isTransparent ? nil : view.asImage()
        
        // hidden subviews rollback
        viewsToHide.forEach {
            $0.isHidden = false
        }
        
        return ViewDescription(
            frame: view.frame,
            snapshot: image,
            subviews: children,
            parentSize: view.superview?.frame.size,
            center: view.center,
            isHidden: view.isHidden,
            isTransparent: isTransparent,
            className: String(describing: type(of: view)),
            isUserInteractionEnabled: view.isUserInteractionEnabled,
            alpha: Float(view.alpha),
            backgroundColor: view.backgroundColor,
            tint: view.tintColor,
            clipToBounds: view.clipsToBounds,
            font: view.visibleFont
        )
    }
    
    func isViewTransparent(_ view: UIView) -> Bool {
        let isTransparent: Bool
        
        if view.isKind(of: UIImageView.self) || view.isKind(of: UILabel.self) || view.isKind(of: UITextView.self) {
            isTransparent = false
        } else if view.backgroundColor == .clear || view.alpha == 0 || view.backgroundColor?.alphaValue == 0 || view.backgroundColor == nil {
            isTransparent = true
        } else {
            isTransparent = false
        }
        
        return isTransparent
    }
}

public protocol ViewDescriptionProtocol {
    var frame: CGRect { get }
    var snapshotImage: UIImage? { get }
    var subviews: [ViewDescriptionProtocol]? { get }
    var parentSize: CGSize? { get }
    var center: CGPoint { get }
    var isHidden: Bool { get }
    var isTransparent: Bool { get }
    var className: String { get }
    var isUserInteractionEnabled: Bool { get }
    var alpha: Float { get }
    var backgroundColor: UIColor? { get }
    var tint: UIColor? { get }
    var clipToBounds: Bool { get }
    var font: UIFont? { get }
}

public class ViewDescription: ViewDescriptionProtocol {
    public let frame: CGRect
    public let snapshotImage: UIImage?
    public let subviews: [ViewDescriptionProtocol]?
    public let parentSize: CGSize?
    public let center: CGPoint
    public let isHidden: Bool
    public let isTransparent: Bool
    public let className: String
    public let isUserInteractionEnabled: Bool
    public let alpha: Float
    public let backgroundColor: UIColor?
    public let tint: UIColor?
    public let clipToBounds: Bool
    public let font: UIFont?
    
    // MARK: - Init
    init(frame: CGRect,
         snapshot: UIImage?,
         subviews: [ViewDescriptionProtocol]?,
         parentSize: CGSize?,
         center: CGPoint,
         isHidden: Bool,
         isTransparent: Bool,
         className: String,
         isUserInteractionEnabled: Bool,
         alpha: Float,
         backgroundColor: UIColor?,
         tint: UIColor?,
         clipToBounds: Bool,
         font: UIFont?)
    {
        self.frame = frame
        self.snapshotImage = snapshot
        self.subviews = subviews
        self.parentSize = parentSize
        self.center = center
        self.isHidden = isHidden
        self.isTransparent = isTransparent
        self.className = className
        self.isUserInteractionEnabled = isUserInteractionEnabled
        self.alpha = alpha
        self.backgroundColor = backgroundColor
        self.tint = tint
        self.clipToBounds = clipToBounds
        self.font = font
    }
}

#endif
