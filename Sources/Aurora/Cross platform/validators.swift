// $$HEADER$$

import Foundation

/// <#Description#>
open class Validator {
    /// <#Description#>
    public static let shared = Validator.init()
    
    /// <#Description#>
    public init() {}
    
    /// <#Description#>
    /// - Parameter str: <#str description#>
    /// - Returns: <#description#>
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
    
    /// <#Description#>
    /// - Parameter str: <#str description#>
    /// - Returns: <#description#>
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
            
            //            results.map {print("\"\(nsString.substring(with: $0.range))\" is an email adress!")}
            
            return (results?.count ?? 0) > 0
        }
    }
    
    /// <#Description#>
    /// - Parameter str: <#str description#>
    /// - Returns: <#description#>
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
