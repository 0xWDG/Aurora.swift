// $$HEADER$$

#if canImport(Foundation)
import Foundation
#endif

#if canImport(Cocoa)
import Cocoa
#endif

#if canImport(UIKit)
import UIKit
#endif

#if canImport(Cocoa)
/// For Cocoa we typealias NSView as View
public typealias View = NSView

/// For Cocoa we typealias NSFont as Font
public typealias Font = NSFont

/// For Cocoa we typealias NSImage as Image
public typealias Image = NSImage

/// For Cocoa we typealias NSBezierPath as BezierPath
public typealias BezierPath = NSBezierPath

/// For Cocoa we typealias NSViewControleer as ViewController
public typealias ViewController = NSViewController
#endif

#if canImport(UIKit)
/// For UIKit we typealias NSView as View
public typealias View = UIView

/// For UIKit we typealias UIFont as Font
public typealias Font = UIFont

/// For UIKit we typealias UIColor as Color
public typealias Color = UIColor

/// For UIKit we typealias UIImage as Image
public typealias Image = UIImage

/// For UIKit we typealias UIBezierPath as BezierPath
public typealias BezierPath = UIBezierPath

/// For UIKit we typealias UIViewController as ViewController
public typealias ViewController = UIViewController
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
/// For AppKit wer typealias NSColor as Color
public typealias Color = NSColor
#endif
