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

#if canImport(Foundation)
import Foundation

/**
 * Log
 *
 * This is used to send log messages with the following syntax
 *
 *     [Aurora] Filename:line functionName(...):
 *      Message
 *
 * - parameter message: the message to send
 * - parameter file: the filename
 * - parameter line: the line
 * - parameter function: function name
 */
@discardableResult
public func log(_ message: Any, file: String = #file, line: Int = #line, function: String = #function) -> Bool {
    if _isDebugAssertConfiguration() {
        let fileName: String = String(
            (file.split(separator: "/").last)!.split(separator: ".").first!
        )
        
        Swift.print("[Aurora] \(fileName):\(line) \(function):\n \(message)\n")
    }
    
    return _isDebugAssertConfiguration()
}
#endif
