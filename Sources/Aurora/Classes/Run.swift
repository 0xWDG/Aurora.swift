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

import Foundation

/// <#Description#>
public class Run {
    typealias Action = () -> Void
    /// <#Description#>
    var queue: [Action] = [Action]()
    
    /// <#Description#>
    /// - Parameter act: <#act description#>
    init(act: @escaping Action) {
        queue.append(act)
    }
    
    /// <#Description#>
    /// - Parameter act: <#act description#>
    /// - Returns: <#description#>
    func then(act: @escaping Action) -> Self {
        queue.append(act)
        return self
    }
    
    /// <#Description#>
    deinit {
        for item in queue {
            item()
        }
    }
}
