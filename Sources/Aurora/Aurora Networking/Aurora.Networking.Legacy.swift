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

extension Aurora {
    /// [Legacy] getDataAsData
    ///
    /// - Parameter url: The url to be loaded
    /// - Returns: Data?
    public func getDataAsData(_ url: String) -> Data? {
        return self.networkRequest(url: url, method: .get, values: nil)
    }

    /// [Legacy] getDataAsText
    ///
    /// - Parameter url: The url to be loaded
    /// - Returns: String?
    public func getDataAsText(_ url: String) -> String? {
        guard let URLData = self.networkRequest(url: url, method: .get, values: nil) else {
            return nil
        }

        return String.init(data: URLData, encoding: .utf8)
    }
}
