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
import Compression

public extension Aurora {
    /// <#Description#>
    /// - Parameter data: <#data description#>
    /// - Returns: <#description#>
    func compress(data: Data) -> Data {
        guard let compressed = data.deflate() else {
            return "".data(using: .utf8)!
        }
        
        return compressed
    }
    
    /// <#Description#>
    /// - Parameter data: <#data description#>
    /// - Returns: <#description#>
    func decompress(data: Data) -> Data {
        guard let decompressed = data.inflate() else {
            return "".data(using: .utf8)!
        }
        
        return decompressed
    }
}
