//
//  File.swift
//  
//
//  Created by Wesley de Groot on 03/06/2020.
//

import Foundation
#if canImport(UIKit)
import UIKit

extension Aurora {
    /// Measure time for a task
    /// - Parameters:
    ///   - tag: taskName/function
    ///   - work: the work to do
    /// - Returns: the input
    ///
    /// Example:
    ///
    ///     func doHardWork {
    ///         Aurora.shared.measure {
    ///             (0..<1000000).reduce(0, +)
    ///         }
    ///     }
    func measure<T>(tag: String = #function, work: () -> T) -> T {
        let begin = CACurrentMediaTime()
        
        defer {
            let time = CACurrentMediaTime() - begin
            self.log("[Measure] \(tag) = \(time)")
        }
        
        return work()
    }
}
#endif
