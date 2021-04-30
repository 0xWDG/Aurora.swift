//
//  Aurora.init.swift
//  Aurora
//
//  Created by Wesley de Groot on 30/04/2021.
//

import Foundation

extension Aurora {
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
