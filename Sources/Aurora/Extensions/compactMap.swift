// $$HEADER$$

import Foundation

#if swift(>=4.1)
#else
extension Collection {
    /// <#Description#>
    /// - Parameter transform: <#transform description#>
    /// - Throws: <#description#>
    /// - Returns: <#description#>
    func compactMap<ElementOfResult>(_ transform: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult] {
        return try flatMap(transform)
    }
}
#endif
