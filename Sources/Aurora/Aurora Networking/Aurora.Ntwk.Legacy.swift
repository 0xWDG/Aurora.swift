//
//  File.swift
//  
//
//  Created by Wesley de Groot on 16/07/2021.
//

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
