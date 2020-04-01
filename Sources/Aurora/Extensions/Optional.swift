// $$HEADER$$

import Foundation
public struct NilError: Error, CustomStringConvertible {
    let file: String
    let line: Int
    
    public init(file: String = #file, line: Int = #line) {
        self.file = file
        self.line = line
    }
    
    public var description: String {
        return "Nil returned at " + (file) + ":\(line)"
    }
}

extension Optional {
    public func unwrap(file: String = #file, line: Int = #line) throws -> Wrapped {
        guard let result = self else {
            throw NilError(file: file, line: line)
        }
        return result
    }
}
