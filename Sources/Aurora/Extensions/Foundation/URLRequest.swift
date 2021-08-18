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
// Licence: MIT

import Foundation

public extension URLRequest {
    /// Returns a cURL command for a request
    /// - return A String object that contains cURL command or "" if an URL is not properly initalized.
    var cURLRepresentation: String {
        guard let url = url, let httpMethod = httpMethod, url.absoluteString.count > 0 else {
            return ""
        }
        
        var curlCommand = "curl --verbose \\\n"
        
        curlCommand.append(" '\(url.absoluteString)' \\\n")
        
        if httpMethod != "GET" {
            curlCommand.append(" -X \(httpMethod) \\\n")
        }
        
        for (key, _) in allHTTPHeaderFields?.sorted(by: { $0.key < $1.key }) ?? [] {
            curlCommand.append(" -H '\(key): \(self.value(forHTTPHeaderField: key)!)' \\\n")
        }
        
        if let httpBody = httpBody, httpBody.count > 0, let httpBodyString = String(data: httpBody, encoding: .utf8) {
            let escapedHttpBody = httpBodyString.replacingOccurrences(of: "'", with: "'\\''")
            curlCommand.append(" --data '\(escapedHttpBody)' \\\n")
        }
        
        return curlCommand
    }
}
