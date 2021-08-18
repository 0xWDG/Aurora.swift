// Aurora framework for Swift
//
// The **Aurora.framework** contains a base for your project.
//
// It has a lot of extensions built-in to make development easier.
//
// - Version: 1.0
// - Copyright: [Wesley de Groot](https://wesleydegroot.nl) ([WDGWV](https://wdgwv.com))\
//  and [Contributors](https://github.com/AuroraFramework/Aurora.swift/graphs/contributors).
//
// Thanks for using!
//
// Licence: MIT

#if canImport(Foundation)
import Foundation

/// NilError
public struct NilError: Error, CustomStringConvertible {
    let file: String
    let line: Int

    /// Nil
    /// - Parameters:
    ///   - file: File
    ///   - line: Line
    public init(file: String = #file, line: Int = #line) {
        self.file = file
        self.line = line
    }

    /// Description
    public var description: String {
        return "Nil returned at " + (file) + ":\(line)"
    }
}

public extension Optional {
    /// Unwrap optional
    /// - Parameters:
    ///   - file: file
    ///   - line: line
    /// - Throws: Error if cannot unwrap
    /// - Returns: Result
    func unwrap(file: String = #file, line: Int = #line) throws -> Wrapped {
        guard let result = self else {
            throw NilError(file: file, line: line)
        }
        return result
    }

    /// Does a optional match something?
    ///
    /// Example:
    ///
    ///     myOptional.matching { $0.count > 2 }
    ///     // Or
    ///     myOptional.matching { $0.age > 18 }
    ///
    /// - Parameter predicate: what do you want to check
    /// - Returns: items which match the predicate
    func matching(_ predicate: (Wrapped) -> Bool) -> Wrapped? {
        guard let value = self else {
            return nil
        }

        guard predicate(value) else {
            return nil
        }

        return value
    }

    /// unwrap or throw
    /// - Parameter errorExpression: Unwrap to error
    /// - Throws: Error if cannot unwrap
    /// - Returns: Result
    func unwrapOrThrow(_ errorExpression: @autoclosure () -> Error) throws -> Wrapped {
        guard let value = self else {
            throw errorExpression()
        }

        return value
    }
}

// From: https://www.instagram.com/p/Bi46gJjD8i2/
public extension Optional where Wrapped == Bool {
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
