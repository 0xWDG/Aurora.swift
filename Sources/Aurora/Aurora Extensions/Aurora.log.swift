// HEADER //

import Foundation

#if canImport(UIKit)
import UIKit
#endif

extension Aurora {
    ///  Log
    ///
    ///  This is used to send log messages with the following syntax
    ///
    ///      [Aurora] Filename:line functionName(...) @Main/Background:
    ///       Message
    ///
    ///  _want to use a callback/loghandler?_
    ///
    ///  Put the following (preffered in your AppDelegate):
    ///
    ///       Aurora.shared.logHandler { message in
    ///           // Do something with the message
    ///       }
    ///
    ///  - parameter message: the message to send
    ///  - parameter file: the filename
    ///  - parameter line: the line
    ///  - parameter function: function name
    @discardableResult
    public func log(
        _ message: String...,
        file: String = #file,
        line: Int = #line,
        function: String = #function) -> Bool {
        if debug {
            // extract filename, without path, and without extension.
            let fileName: String = (file.split("/").last).unwrap(
                orError: "Failed to get file name"
            ).split(".").first.unwrap(orError: "Failed to get file name")

            // extract extension.
            let fileExtension: String = file.split(".").last.unwrap(orError: "Invalid file extension")

            // On which Queue are we running
            let queue = Thread.isMainThread ? "Main" : "Background"

            // Make up the log message.
            let logMessage = logTemplate
                .replace("$product", withString: product)
                .replace("$version", withString: version)
                .replace("$datetime", withString: dateFormatter.string(from: Date()))
                .replace("$date", withString: dateFormatter.string(from: Date()))
                .replace("$time", withString: dateFormatter.string(from: Date()))
                .replace("$file", withString: fileName)
                .replace("$fileName", withString: fileName)
                .replace("$extension", withString: fileExtension)
                .replace("$fileExtension", withString: fileExtension)
                .replace("$line", withString: "\(line)")
                .replace("$function", withString: function)
                .replace("$queue", withString: queue)
                .replace("$message", withString: message.joined(separator: " "))
                + "\n"

            // Print the "messages"
            Swift.print(logMessage)

            // Append to the history
            logHistory.append(logMessage)

            if isInitialized {
                Aurora.shared.logHandler?(logMessage)
            }
        }

        return debug
    }

    /// Log
    ///
    /// This is used to send log messages with the following syntax
    ///
    ///     [Aurora] Filename:line functionName(...) @Main/Background:
    ///      Message
    ///
    /// _want to use a callback/loghandler?_
    ///
    /// Put the following (preffered in your AppDelegate):
    ///
    ///      Aurora.shared.logHandler { message in
    ///          // Do something with the message
    ///      }
    ///
    /// - parameter message: the message to send
    /// - parameter file: the filename
    /// - parameter line: the line
    /// - parameter function: function name
    ///
    @discardableResult
    public func log(_ anyThing: Any..., file: String = #file, line: Int = #line, function: String = #function) -> Bool {
        if debug {
            // Any... = [Any]

            // extract filename, without path, and without extension.
            let fileName: String = (file.split("/").last).unwrap(
                    orError: "Failed to get file name"
            ).split(".").first.unwrap(
                orError: "Failed to get file name"
            )

            // extract extension.
            let fileExtension: String = file.split(".").last.unwrap(orError: "Invalid name")

            // On which Queue are we running
            let queue = Thread.isMainThread ? "Main" : "Background"

            // Make up the log message.
            let logMessage = logTemplate
                .replace("$product", withString: product)
                .replace("$version", withString: version)
                .replace("$datetime", withString: dateFormatter.string(from: Date()))
                .replace("$date", withString: dateFormatter.string(from: Date()))
                .replace("$time", withString: dateFormatter.string(from: Date()))
                .replace("$file", withString: fileName)
                .replace("$fileName", withString: fileName)
                .replace("$extension", withString: fileExtension)
                .replace("$fileExtension", withString: fileExtension)
                .replace("$line", withString: "\(line)")
                .replace("$function", withString: function)
                .replace("$queue", withString: queue)
                .replace("$message", withString: "\(anyThing)")
                + "\n"

            // Print the "messages"
            Swift.print(logMessage)

            // Append to the history
            logHistory.append(logMessage)

            if isInitialized {
                Aurora.shared.logHandler?(logMessage)
            }
        }

        return debug
    }

    /// print (alias for log)
    ///
    /// This is used to send log messages with the following syntax
    ///
    ///     [Aurora] Filename:line functionName(...) @Main/Background:
    ///      Message
    ///
    /// _want to use a callback/loghandler?_
    ///
    /// Put the following (preffered in your AppDelegate):
    ///
    ///      Aurora.shared.logHandler { message in
    ///          // Do something with the message
    ///      }
    ///
    /// - parameter message: the message to send
    /// - parameter file: the filename
    /// - parameter line: the line
    /// - parameter function: function name
    @discardableResult
    public func print(
        _ message: String...,
        file: String = #file,
        line: Int = #line,
        function: String = #function) -> Bool {
        return log(
            message.joined(separator: " "),
            file: file,
            line: line,
            function: function
        )
    }

    /// Show LogViewer
    public func showLogViewer() {
        #if canImport(UIKit)
        let logView = AuroraLogView()
        UIApplication.shared.key?.rootViewController?.showDetailViewController(
            logView,
            sender: self
        )
        #endif
    }

    /// Get the log messages
    /// - Returns: The last crashlog
    public func getLogMessages() -> [String] {
        return logHistory
    }
}
