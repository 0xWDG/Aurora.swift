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

import Foundation
#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

public enum UITest {
    /// Check if interface tests are running or not.
    public static var isRunning: Bool {
        ProcessInfo.processInfo.arguments.contains("-ui_testing")
    }
}

public enum UnitTest {
    /// Check if unit tests are running or not.
    public static var isRunning: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
    
    #if !os(watchOS)
    public static func measure(closure: () -> Void) -> Float {
        let start = CACurrentMediaTime()
        closure()
        
        let end = CACurrentMediaTime()
        return Float(end - start)
    }
    #endif
}
