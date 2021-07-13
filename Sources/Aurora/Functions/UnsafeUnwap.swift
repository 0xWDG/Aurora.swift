//
//  UnsafeUnwap.swift
//  Aurora
//
//  Created by Wesley de Groot on 13/07/2021.
//

#if canImport(Foundation)
import Foundation
public func unsafeUnwrap<T>(_ optional: T?, _ reason: String, file: String = #file, line: Int = #line) -> T {
    guard let unwrapped = optional else {
        fatalError("Forced unwrap for \(reason) at \(file):\(line) failed")
    }
    return unwrapped
}
#endif
