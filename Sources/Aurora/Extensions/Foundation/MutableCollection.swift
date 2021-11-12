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
public extension MutableCollection {
    /// Calls the provided closure for each element in self,
    /// passing in the index of an element and a reference to it
    /// that can be mutated.
    ///
    /// Example usage:
    /// ```
    /// var numbers = [0, 2, 4, 6, 8, 10]
    ///
    /// numbers.mutateEach { indx, element in
    ///   if [1, 5].contains(indx) { return }
    ///   element *= 2
    /// }
    ///
    /// print(numbers) // [0, 4, 4, 6, 8, 10]
    /// ```
    mutating func mutateEach(_ modifyElement: (Index, inout Element) throws -> Void) rethrows {
        for indx in self.indices {
            try modifyElement(indx, &self[indx])
        }
    }
}
