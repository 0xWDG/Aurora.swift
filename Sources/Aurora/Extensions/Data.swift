// $$HEADER$$

import Foundation

public extension Data {
    /// Data as hexidecimal string
    var hexString: String {
        return self.map({
            return String(format: "%02hhx", $0)
        }).joined()
    }
}
