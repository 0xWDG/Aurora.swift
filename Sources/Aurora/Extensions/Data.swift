// $$HEADER$$

import Foundation

extension Data {
    public var hexString: String {
        return self.map({ return String(format: "%02hhx", $0) }).joined()
    }
}
