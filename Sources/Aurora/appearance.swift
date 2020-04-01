// $$HEADER$$

import Foundation
#if os(OSX)
    import Cocoa
    import AppKit
#endif
#if os(iOS)
    import UIKit
#endif

public extension Aurora {
    
    enum Blur: CustomDebugStringConvertible {
        case light
        case dark
        case xlight
        
        public var debugDescription: String {
            switch self {
            case .light:
                return "Light"
            case .dark:
                return "Dark"
            case .xlight:
                return "Xlight"
            }
        }
    }
    
    #if os(OSX)
    /**
     Append Blur to a window
     
     - Parameter view: The NSButton, NSView, NSTextField, ...
     - Parameter color: The Color (light/dark)
     - Parameter alwaysBlur: true (default), false=not when in background
     - Parameter hideTitle: false (default), true=hide title
     */
    func appearanceBlur(view: AnyObject, _ color: Blur? = Blur.xlight, _ alwaysBlur: Bool? = true, _ hideTitle: Bool? = false) -> Void {
    if (view is NSButton || view is NSTextField || view is NSView) {
    var Mcolor = ""
    
        if (UserDefaults.standard.object(forKey: "blur") as! String == "(null)") {
            if (color == Blur.xlight) {
    Mcolor = "light"
    }
    } else {
            if (color == Blur.xlight) {
                Mcolor = UserDefaults.standard.object(forKey: "blur") as! String
    
    if (Mcolor == "light") {
    Mcolor = "dark"
    } else {
    Mcolor = "light"
    }
    }
    }
    
        if (color == Blur.light) {
    Mcolor = "light"
    }
    
        if (color == Blur.dark) {
    Mcolor = "dark"
    }
    
        UserDefaults.standard.set(Mcolor, forKey: "blur")
        UserDefaults.standard.synchronize()
    
    if view is NSTextField || view is NSButton {
    if (Mcolor == "dark") {
    Mcolor = "light"
    } else {
    Mcolor = "dark"
    }
    }
    
    let blurryView = NSVisualEffectView(frame: NSRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
    
    // this is default value but is here for clarity
        blurryView.blendingMode = NSVisualEffectBlendingMode.behindWindow
    
    if (Mcolor == "light") {
        blurryView.material = NSVisualEffectMaterial.light
    } else {
        blurryView.material = NSVisualEffectMaterial.dark
    }
    
    if ((alwaysBlur) != nil) {
        blurryView.state = NSVisualEffectState.active
    } else {
        blurryView.state = NSVisualEffectState.followsWindowActiveState
    }
    
    if view is NSView {
        view.addSubview(blurryView, positioned: NSWindowOrderingMode.below, relativeTo: (view as! NSView))
    }
    
    if view is NSTextField {
        view.addSubview(blurryView, positioned: NSWindowOrderingMode.below, relativeTo: (view as! NSTextField))
    }
    
    if view is NSButton {
        view.addSubview(blurryView, positioned: NSWindowOrderingMode.below, relativeTo: (view as! NSButton))
    }
    } else {
    print("At this point i only support NSButton, NSTextField, NSView")
    print("Please report a issue on:")
    print("https://gist.github.com/wdg/b5dfcb8b3cac0faa6907719f3992d696")
    }
    }
    
    /**
     Append Blur to a window (Alias)
     
     - Parameter view: The NSButton, NSView, NSTextField, ...
     - Parameter color: The Color (light/dark)
     - Parameter alwaysBlur: true (default), false=not when in background
     - Parameter hideTitle: false (default), true=hide title
     */
    func appendBlur(view: AnyObject, _ color: Blur? = Blur.xlight, _ alwaysBlur: Bool? = true, _ hideTitle: Bool? = false) -> Void {
        self.appearanceBlur(view: view, color, alwaysBlur, hideTitle)
    }
    
    #else
    /**
     Append Blur to a window (*NOT SUPPORTED ON THIS PLATFORM!*)
     
     - Parameter view: The NS*
     - Parameter color: The Color (light/dark)
     - Parameter alwaysBlur: true (default), false=not when in background
     - Parameter hideTitle: false (default), true=hide title
     */
    func appearanceBlur(_ view: AnyObject, _ color: Blur? = Blur.xlight, _ alwaysBlur: Bool? = true, _ hideTitle: Bool? = false) -> Void {
        
    }
    
    /**
     Append Blur to a window (Alias)
     
     - Parameter view: The NSButton, NSView, NSTextField, ...
     - Parameter color: The Color (light/dark)
     - Parameter alwaysBlur: true (default), false=not when in background
     - Parameter hideTitle: false (default), true=hide title
     */
    func appendBlur(_ view: AnyObject, _ color: Blur? = Blur.xlight, _ alwaysBlur: Bool? = true, _ hideTitle: Bool? = false) -> Void {
        self.appearanceBlur(view, color, alwaysBlur, hideTitle)
    }
    #endif
    
    #if os(iOS)
    /**
     Set Apps tint as a specific color
     
     - Parameter color: the color
     */
    func setAppColor(_ color: UIColor) {
        // iOS
        UIView.appearance().tintColor = color
        
        // Mac?
        UIWindow.appearance().tintColor = color
    }
    
    /**
     Set TabBar background as a specific color
     
     - Parameter color: the color
     */
    func setTabBarBackgroundColor(_ color: UIColor) {
        UITabBar.appearance().barTintColor = color
    }
    
    /**
     Set Apps background as a image
     
     - Parameter color: the image
     */
    func setAppImage(_ image: UIImage) {
        // iOS
        UIView.appearance().tintColor = UIColor.init(patternImage: image)
        
        // Mac?
        UIWindow.appearance().tintColor = UIColor.init(patternImage: image)
    }
    #else
    /**
     Set Apps background as a specific color
     
     - Parameter color: the color
     */
    @available(*, unavailable, message: "Only useable in iOS") public func setAppColor(color: AnyObject) {
    print("Not supported")
    }
    
    /**
     Set Apps background as a specific color
     
     - Parameter color: the color
     */
    @available(*, unavailable, message: "Only useable in iOS") public func setTabBarBackgroundColor(color: AnyObject) {
        print("Not supported")
    }
    
    /**
     Set Apps background as a image
     
     - Parameter color: the image
     */
    @available(*, unavailable, message: "Only useable in iOS") public func setAppImage(color: AnyObject) {
    print("Not supported")
    }
    #endif
}
