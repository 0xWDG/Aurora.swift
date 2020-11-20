// $$HEADER$$

import Foundation

postfix operator %
postfix func % (percentage: Int) -> Float {
    return (Float(percentage) / 100)
}
