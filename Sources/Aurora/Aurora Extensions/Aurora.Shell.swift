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
// Thanks for using!
//
// Licence: MIT

import Foundation

#if os(macOS)

public extension Aurora {
    /// Run a shell command.
    /// - Parameters:
    ///   - arguments: Arguments
    ///   - showLog: Show the log?
    /// - Returns: Shell return
@discardableResult
func shell(_ arguments: String, showLog: Bool = false) -> String {
    let task = Process()
    task.launchPath = "/bin/zsh"
    var environment = ProcessInfo.processInfo.environment
    environment["PATH"] = "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
    task.environment = environment
    task.arguments = ["-c", arguments]

    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String = String(data: data, encoding: .utf8).unwrap(orError: "Cannot convert output")
    task.waitUntilExit()
    pipe.fileHandleForReading.closeFile()

    if showLog && !output.isBlank {
        print(output)
    }
    return output
}
}

/// ANSI Colors
enum ANSIColors: String {
    case black = "\u{001B}[0;30m"
    case red = "\u{001B}[0;31m"
    case green = "\u{001B}[0;32m"
    case yellow = "\u{001B}[0;33m"
    case blue = "\u{001B}[0;34m"
    case magenta = "\u{001B}[0;35m"
    case cyan = "\u{001B}[0;36m"
    case white = "\u{001B}[0;37m"
    case `default` = "\u{001B}[0;0m"
}

/// Add colors to a string
/// - Parameters:
///   - left: ANSI Color
///   - right: String
/// - Returns: Colored String
func + (left: ANSIColors, right: String) -> String {
    return left.rawValue + right
}

/// Add colors to a string
/// - Parameters:
///   - left: String
///   - right: ANSI Color
/// - Returns: Colored String
func + (left: String, right: ANSIColors) -> String {
    return left + right.rawValue
}
#endif
