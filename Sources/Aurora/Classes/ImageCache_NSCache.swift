//
//  ImageCache_NSCache.swift
//  Aurora
//
//  Created by Wesley de Groot on 03/06/2020.
//

#if canImport(UIkit)
import Foundation
import UIKit

class ImageCache {
    /// <#Description#>
    private let cache = NSCache<NSString, NSData>()
    
    /// <#Description#>
    /// - Parameters:
    ///   - name: <#name description#>
    ///   - maxCount: <#maxCount description#>
    ///   - maxSizeInBytes: <#maxSizeInBytes description#>
    init(name: String, maxCount: Int, maxSizeInBytes: Int) {
        self.cache.name = name
        self.cache.countLimit = maxCount
        self.cache.totalCostLimit = maxSizeInBytes
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - data: <#data description#>
    ///   - forURL: <#forURL description#>
    func putImageData(_ data: Data, forURL: URL) {
        cache.setObject(
            data as NSData,
            forKey: forURL.absoluteString as NSString,
            cost: data.count
        )
    }
    
    /// <#Description#>
    /// - Parameter URL: <#URL description#>
    /// - Returns: <#description#>
    func retrieveImageData(for URL: URL) -> Data? {
        return cache.object(forKey: URL.absoluteString as NSString) as Data?
    }
    
    /// <#Description#>
    /// - Parameter URL: <#URL description#>
    /// - Returns: <#description#>
    func retrieveImage(for URL: URL) -> UIImage? {
        return self.retrieveImageData(for: URL).flatMap {
            UIImage(data: $0)
        }
    }
    
    /// <#Description#>
    func flush() {
        cache.removeAllObjects()
    }
}

#endif
