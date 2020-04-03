//
//  File.swift
//  
//
//  Created by Wesley de Groot on 03/04/2020.
//

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
public typealias View = NSView
public typealias Font = NSFont
public typealias Image = NSImage
public typealias BezierPath = NSBezierPath
public typealias ViewController = NSViewController
#endif

#if canImport(UIKit)
public typealias View = UIView
public typealias Font = UIFont
public typealias Color = UIColor
public typealias Image = UIImage
public typealias BezierPath = UIBezierPath
public typealias ViewController = UIViewController
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
/// Color
public typealias Color = NSColor
#endif
