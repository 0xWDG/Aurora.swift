// $$HEADER$$

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
