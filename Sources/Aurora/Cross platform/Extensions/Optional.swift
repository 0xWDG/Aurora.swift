// $$HEADER$$

#if canImport(Foundation)
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

// From: https://www.instagram.com/p/Bi46gJjD8i2/
extension Optional where Wrapped == Bool {
    /// Unwrap if possible
    /// - Parameter value: value
    /// - Returns: unwrapped value (if possible)
    ///
    /// Exampe
    ///
    ///    var isFavorite: Bool = nil
    ///    print(!isFavorite)
    ///    // nil
    ///
    ///    isFavorite = true
    ///    print(!isFavorite)
    ///    // false
    static prefix func ! (value: Bool?) -> Bool? {
        return value.flatMap { $0 }
    }
}
#endif
