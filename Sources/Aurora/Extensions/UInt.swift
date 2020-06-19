// $$HEADER$$

import Foundation

extension UInt {
    /// Convert UInt to Int
    public var toInt: Int { return Int(self) }
    
    /// Greatest common divisor of two integers using the Euclid's algorithm.
    /// Time complexity of this in O(log(n))
    public static func gcd(_ firstNum: UInt, _ secondNum: UInt) -> UInt {
        let remainder = firstNum % secondNum
        if remainder != 0 {
            return gcd(secondNum, remainder)
        } else {
            return secondNum
        }
    }
    
    /// Least common multiple of two numbers. LCM = n * m / gcd(n, m)
    public static func lcm(_ firstNum: UInt, _ secondNum: UInt) -> UInt {
        return firstNum * secondNum / UInt.gcd(firstNum, secondNum)
    }
}
