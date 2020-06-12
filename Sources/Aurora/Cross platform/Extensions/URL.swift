// $$HEADER$$

import Foundation

extension URL: ExpressibleByStringLiteral {
    /// <#Description#>
    /// - Parameter value: <#value description#>
    public init(stringLiteral value: String) {
        guard let url = URL(string: value) else {
            fatalError("\(value) is an invalid url")
        }
        self = url
    }
    
    /// <#Description#>
    /// - Parameter value: <#value description#>
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
    
    /// <#Description#>
    /// - Parameter value: <#value description#>
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
}
