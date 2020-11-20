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
// Please note: this is a beta version.
// It can contain bugs, please report all bugs to https://github.com/AuroraFramework/Aurora.swift
//
// Thanks for using!
//
// Licence: Needs to be decided.

#if canImport(Foundation)
import Foundation

/// <#Description#>
public struct NilError: Error, CustomStringConvertible {
    let file: String
    let line: Int
    
    /// <#Description#>
    /// - Parameters:
    ///   - file: <#file description#>
    ///   - line: <#line description#>
    public init(file: String = #file, line: Int = #line) {
        self.file = file
        self.line = line
    }
    
    /// <#Description#>
    public var description: String {
        return "Nil returned at " + (file) + ":\(line)"
    }
}

public extension Optional {
    /// <#Description#>
    /// - Parameters:
    ///   - file: <#file description#>
    ///   - line: <#line description#>
    /// - Throws: <#description#>
    /// - Returns: <#description#>
    func unwrap(file: String = #file, line: Int = #line) throws -> Wrapped {
        guard let result = self else {
            throw NilError(file: file, line: line)
        }
        return result
    }
    
    /// <#Description#>
    ///
    /// Example:
    ///
    ///     myOptional.matching { $0.count > 2 }
    ///     // Or
    ///     myOptional.matching { $0.age > 18 }
    ///
    /// - Parameter predicate: <#predicate description#>
    /// - Returns: <#description#>
    func matching(_ predicate: (Wrapped) -> Bool) -> Wrapped? {
        guard let value = self else {
            return nil
        }
        
        guard predicate(value) else {
            return nil
        }
        
        return value
    }
    
    /// <#Description#>
    /// - Parameter errorExpression: <#errorExpression description#>
    /// - Throws: <#description#>
    /// - Returns: <#description#>
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
