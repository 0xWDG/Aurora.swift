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

/// Validate input
open class Validator {
    /// Shared instance
    public static let shared = Validator.init()
    
    /// initialize
    public init() {}
    
    /// Contains banned words?
    /// - Parameter str: String to be checked.
    /// - Returns: Contains banned words?
    public func containsBannedWord(str: String) -> Bool {
        let bannedWords = [
            "neuken",
            "fuck",
            "lul",
            "hoer",
            "i hate this app"
        ]
        
        return bannedWords.filter { str.contains($0) }.count > 0
    }
    
    /// Does the string contains a phone number
    /// - Parameter str: String to be checked.
    /// - Returns: Contains phone number?
    public func containsPhoneNumber(str: String) -> Bool {
        do {
            let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector?.matches(
                in: str,
                options: [],
                range: NSRange(str.startIndex..., in: str)
            )
            
            if let res = matches?.first {
                return (res.resultType == .phoneNumber && res.range.length > 0)
            } else {
                return false
            }
        }
    }
    
    /// Does the string contains a email adress
    /// - Parameter str: String to be checked.
    /// - Returns: Contains email adress?
    public func containsEmailaddress(str: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        do {
            let regex = try? NSRegularExpression(pattern: emailRegEx, options: [])
            let nsString = NSString(string: str)
            let results = regex?.matches(
                in: str,
                options: [],
                range: NSRange(location: 0, length: nsString.length)
            )
            
            return (results?.count ?? 0) > 0
        }
    }
    
    /// Does the string contains a adress
    /// - Parameter str: String to be checked.
    /// - Returns: Contains adress?
    public func containsAddress(str: String) -> Bool {
        do {
            let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.address.rawValue)
            let matches = detector?.matches(
                in: str,
                options: [],
                range: NSRange(str.startIndex..., in: str)
            )
            
            if let res = matches?.first {
                return (res.resultType == .address && res.range.length > 0)
            } else {
                return false
            }
        }
    }
}
