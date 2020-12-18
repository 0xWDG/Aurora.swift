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
import CommonCrypto

#if os(iOS)
import UIKit
#endif
#if os(OSX)
import AppKit
#endif
#if canImport(CryptoKit)
import CryptoKit
#endif

/// The Aurora framework for swift
///
/// The **Aurora.framework** contains a base for your project.
///
/// It has a lot of extensions built-in to make development easier
///
/// - Version: 1.0
/// - Copyright: [Wesley de Groot](https://wesleydegroot.nl) ([WDGWV](https://wdgwv.com))\
///  and [Contributors](https://github.com/AuroraFramework/Aurora.swift/graphs/contributors).
open class Aurora {
    /// The shared instance of the "AuroraFramework"
    public static let shared = Aurora()
    
    /// Initialize crash handler
    static let crashLogger = AuroraCrashHandler.shared

    /// the version
    public let version = "1.0"
    
    /// The product name
    public let product = "Aurora Framework"
    
    /// Should we debug right now?
    private var debug = _isDebugAssertConfiguration()
    
    /// If this is non-nil, we will call it with the same string that we
    /// are going to print to the console. You can use this to pass log
    /// messages along to your crash reporter, analytics service, etc.
    /// - warning: Be mindful of private user data that might end up in
    ///            your log statements! Use log levels appropriately
    ///            to keep private data out of logs that are sent over
    ///            the Internet.
    public var logHandler: ((String) -> Void)?

    /// Logging history
    private var logHistory: [String] = []
    
    /// Is it already started?
    var isInitialized: Bool = false
    
    /// Initialize
    public init(_ silent: Bool = true) {
        #if os(iOS)
        self.log("Aurora Framework for iOS \(self.version) loaded")
        #elseif os(macOS)
        self.log("Aurora Framework for Mac OS \(self.version) loaded")
        #elseif os(watchOS)
        self.log("Aurora Framework for WachtOS \(self.version) loaded")
        #elseif os(tvOS)
        self.log("Aurora Framework for tvOS \(self.version) loaded")
        #elseif os(Android)
        self.log("Aurora Framework for Android \(self.version) loaded")
        #elseif os(Windows)
        self.log("Aurora Framework for Windows \(self.version) loaded")
        #elseif os(Linux)
        self.log("Aurora Framework for Linux \(self.version) loaded")
        #else
        self.log("Aurora Framework \(self.version) loaded")
        self.log("Unknown platform")
        #endif
        
        #if os(iOS)
        let iCloud: WDGFrameworkiCloudSync = WDGFrameworkiCloudSync()
        iCloud.startSync()
        #endif
        
        isInitialized = true
    }
    
    /**
     * Log
     *
     * This is used to send log messages with the following syntax
     *
     *     [Aurora] Filename:line functionName(...) @Main/Background:
     *      Message
     *
     * _want to use a callback/loghandler?_
     *
     * Put the following (preffered in your AppDelegate):
     *
     *      Aurora.shared.logHandler { message in
     *          // Do something with the message
     *      }
     *
     * - parameter message: the message to send
     * - parameter file: the filename
     * - parameter line: the line
     * - parameter function: function name
     */
    @discardableResult
    public func log(
        _ message: String...,
        file: String = #file,
        line: Int = #line,
        function: String = #function) -> Bool {
        if debug {
            // extract filename, without path, and without extension.
            let fileName: String = (file.split("/").last)!.split(".").first!
            
            let queue = Thread.isMainThread ? "Main" : "Background"
            
            // Make up the log message.
            let logMessage: String = "[Aurora.Framework] \(fileName):\(line) \(function)" +
                                     " @\(queue):\n \(message.joined(separator: " "))\n"
            
            // Print the "messages"
            Swift.print(logMessage)
            
            // Append to the history
            logHistory.append(logMessage)
            
            if isInitialized {
                Aurora.shared.logHandler?(logMessage)
            }
        }
        
        // return the debug value, if wanted you can use
        //
        //    if (log("myMessage")) {
        //       // My message is logged
        //    } else {
        //       // My message is not logged
        //    }
        return debug
    }

    /**
     * Log
     *
     * This is used to send log messages with the following syntax
     *
     *     [Aurora] Filename:line functionName(...) @Main/Background:
     *      Message
     *
     * _want to use a callback/loghandler?_
     *
     * Put the following (preffered in your AppDelegate):
     *
     *      Aurora.shared.logHandler { message in
     *          // Do something with the message
     *      }
     *
     * - parameter message: the message to send
     * - parameter file: the filename
     * - parameter line: the line
     * - parameter function: function name
     */
    @discardableResult
    public func log(_ anyThing: Any..., file: String = #file, line: Int = #line, function: String = #function) -> Bool {
        if debug {
            // Any... = [Any]
            
            // extract filename, without path, and without extension.
            let fileName: String = (file.split("/").last)!.split(".").first!
            
            let queue = Thread.isMainThread ? "Main" : "Background"
            
            // Make up the log message.
            let logMessage: String = "[Aurora.Framework] \(fileName):\(line) \(function) @\(queue):\n \(anyThing)\n"
            
            // Print the "messages"
            Swift.print(logMessage)
            
            // Append to the history
            logHistory.append(logMessage)
            
            if isInitialized {
                Aurora.shared.logHandler?(logMessage)
            }
        }
        
        // return the debug value, if wanted you can use
        //
        //    if (log("myMessage")) {
        //       // My message is logged
        //    } else {
        //       // My message is not logged
        //    }
        return debug
    }
    
    /**
     * print (alias for log)
     *
     * This is used to send log messages with the following syntax
     *
     *     [Aurora] Filename:line functionName(...) @Main/Background:
     *      Message
     *
     * _want to use a callback/loghandler?_
     *
     * Put the following (preffered in your AppDelegate):
     *
     *      Aurora.shared.logHandler { message in
     *          // Do something with the message
     *      }
     *
     * - parameter message: the message to send
     * - parameter file: the filename
     * - parameter line: the line
     * - parameter function: function name
     */
    @discardableResult
    public func print(
        _ message: String...,
        file: String = #file,
        line: Int = #line,
        function: String = #function) -> Bool {
        return log(message.joined(separator: " "), file: file, line: line, function: function)
    }
    
    /// Get the log messages
    /// - Returns: The last crashlog
    public func getLogMessages() -> [String] {
        return logHistory
    }
    
    /// Get the last crash log
    /// - Returns: The last crashlog
    public func getLastCrashLog() -> String? {
        return Aurora.crashLogger.getLastCrashLog()
    }
    
    /// Delete the last crash log
    /// - Returns: Bool if deleted
    @discardableResult
    public func deleteLastCrashLog() -> Bool {
        return Aurora.crashLogger.deleteLastCrashLog()
    }
    
    #if canImport(CryptoKit)
    /// Create a MD5 string
    /// - Parameter phrase: The phrase which needs to be converted into MD5
    /// - Returns: MD5 Hash
    public func md5(phrase: String) -> String {
        return phrase.md5
    }
    #endif
    
    /// **No op**eration
    /// - Parameter something: Whay ever you want.
    public func noop(_ something: Any...) {
        // Great.
    }

    /// **No op**eration
    /// - Parameter something: Whay ever you want. (object)
    public func noop(_ something: AnyObject...) {
        // Great.
    }
    
    /// This is a demo func, thing for unavailable things.
    /// - Returns: Void
    @available(*, unavailable)
    func unavailableFunc() {
    }
}

/// Support older configurations
open class WDGFramework: Aurora { }
