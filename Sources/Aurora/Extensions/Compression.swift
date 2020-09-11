//
//  Compression.swift
//  Aurora
//
//  Created by Wesley de Groot on 28/12/2018.
//  Copyright © 2018 Wesley de Groot. All rights reserved.
//

import Foundation
import Compression

extension Aurora {
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
