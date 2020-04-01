// $$HEADER$$

import Foundation

extension Array {
    mutating func shuffle()
    {
        for _ in 0..<10
        {
            sort {(_, _) in arc4random() < arc4random()}
        }
    }
}
