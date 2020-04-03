// $$HEADER$$

import Foundation

extension Data {
    /// Data as hexidecimal string
    public var hexString: String {
        return self.map({
            return String(format: "%02hhx", $0)
        }).joined()
    }
}
