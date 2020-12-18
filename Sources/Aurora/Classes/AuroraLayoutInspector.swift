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

#if canImport(UIKit) && !os(watchOS) && !os(tvOS)
import Foundation
import UIKit

open class AuroraLayoutInspector {
    /// Description
    static public let shared: AuroraLayoutInspector = AuroraLayoutInspector.init()
    
    public func startInspecting() {
        // Start.
    }
    
    public func captureHierarchy() -> ViewDescriptionProtocol {
        guard let firstWindow = UIApplication.shared.windows.first else {
            //            return nil
            fatalError("Oops.")
        }
        
        return buildHierarchy(view: firstWindow)
    }
    
    func viewAsImage(view: UIView) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { rendererContext in
            view.layer.render(in: rendererContext.cgContext)
        }
    }
    
    public func buildHierarchy(view: UIView) -> ViewDescriptionProtocol {
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
        
        let image = isTransparent ? nil : viewAsImage(view: view)
        
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
        } else if view.backgroundColor == .clear || view.alpha == 0 ||
                    view.backgroundColor?.alphaValue == 0 || view.backgroundColor == nil {
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

extension ViewDescription: CustomDebugStringConvertible {
    func parseView(view: ViewDescriptionProtocol, numberOfTabs: Int = 0) -> String {
        var tabs: String = ""
        
        for _ in 0...numberOfTabs {
            tabs.append("\t")
        }
        
        var dString = "\(tabs)View<\(className)> "
            + "(hidden:\(isHidden ? "Yes" : "No"), "
            + "transparent:\(isTransparent ? "Yes" : "No"), "
            + "userInteractionEnabled:\(isUserInteractionEnabled ? "Yes" : "No")):\n"
        dString.append("\(tabs)\tFrame: \(frame)\n")
        dString.append("\(tabs)\tCenter point: \(center)\n")
        dString.append("\(tabs)\tParent size: (w: \(parentSize?.width), h: \(parentSize?.height))\n")
        dString.append("\(tabs)\tBackground color: (r:\(backgroundColor?.redValue),")
        dString.append("g:\(backgroundColor?.greenValue), b:\(backgroundColor?.blueValue),")
        dString.append("a:\(backgroundColor?.alphaValue))\n")
        dString.append("\(tabs)\tTint color: (r:\(tint?.redValue), g:\(tint?.greenValue),")
        dString.append("b:\(tint?.blueValue), a:\(tint?.alphaValue))\n")
        dString.append("\(tabs)\tclipToBounds: \(clipToBounds ? "Yes" : "No")\n")
        dString.append("\(tabs)\tfont: \(font)\n")
        
        dString.append("\(tabs)\tSubviews(\(subviews?.count)):\n")
        
        if let subviews = subviews {
            for subView in subviews {
                if numberOfTabs < 10 {
                    dString.append(parseView(view: subView, numberOfTabs: (numberOfTabs + 2)))
                } else {
                    dString.append("\(tabs)\t\tSubview limit reached.\n")
                }
            }
        }
        
        return dString
    }
    
    public var debugDescription: String {
        var dString = "View<\(className)> "
            + "(hidden:\(isHidden ? "Yes" : "No"),"
            + "transparent:\(isTransparent ? "Yes" : "No"),"
            + "userInteractionEnabled:\(isUserInteractionEnabled ? "Yes" : "No")):\n"
        dString.append("Frame: \(frame)\n")
        dString.append("Center point: \(center)\n")
        dString.append("Parent size: (w: \(parentSize?.width), h: \(parentSize?.height))\n")
        dString.append("Background color: (r:\(backgroundColor?.redValue), ")
        dString.append("g:\(backgroundColor?.greenValue), ")
        dString.append("b:\(backgroundColor?.blueValue), ")
        dString.append("a:\(backgroundColor?.alphaValue))\n")
        dString.append("Tint color: (r:\(tint?.redValue), ")
        dString.append("g:\(tint?.greenValue), b:\(tint?.blueValue), ")
        dString.append("a:\(tint?.alphaValue))\n")
        dString.append("clipToBounds: \(clipToBounds ? "Yes" : "No")\n")
        dString.append("font: \(font)\n")
        
        dString.append("Subviews(\(subviews?.count)):\n")
        
        if let subviews = subviews {
            for subView in subviews {
                dString.append(parseView(view: subView, numberOfTabs: 2))
            }
        }
        
        return dString
        //        return parseView(view: self)
    }
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
         font: UIFont?) {
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
