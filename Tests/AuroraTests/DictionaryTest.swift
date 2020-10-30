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

#if !os(watchOS)
import Foundation

import XCTest

@testable import Aurora

class AuroraDictionaryTest: XCTestCase {
    func testDictionary() {
        let dict: [String: String] = [
            "This": "Is",
            "a": "test",
            "Dictionary": "!"
        ]
        
        XCTAssert(dict["Dictionary"] == "!", "Should be \"!\"")
    }
}
#endif
