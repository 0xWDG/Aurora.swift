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

import Foundation

/// Run actions after another
public class Run {
    /// Alias for closire
    typealias Action = () -> Void

    /// The queue
    var queue: [Action] = [Action]()

    /// Initialize the first action
    /// - Parameter act: Action closure
    init(action: @escaping Action) {
        queue.append(action)
    }

    /// Append execution in the queue
    /// - Parameter action: Action closure
    /// - Returns: Self (for appending)
    func then(action: @escaping Action) -> Self {
        queue.append(action)
        return self
    }

    /// Run all the queue items.
    deinit {
        for item in queue {
            item()
        }
    }
}
