// $$HEADER$$

import Foundation

extension Int {
    public func toString(_ i: Int) -> String {

        if (i == 16) {// hexadecimal
            return String(format: "%2X", self).lowerAndNoSpaces
        }
        else if (i == 8) {// octal
            return String(self, radix: 8, uppercase: false).lowerAndNoSpaces
        }
        else if (i == 2) {// binary
            return String(self, radix: 2, uppercase: false).lowerAndNoSpaces
        }
        else {
            return String(self)
        }
    }
    
}
