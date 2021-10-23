//
//  File.swift
//  File
//
//  Created by Wesley de Groot on 06/09/2021.
//

#if !os(watchOS)
import Foundation

import XCTest

@testable import Aurora

class AuroraKeychainTest: XCTestCase {
    func testSet() {
        AuroraKeychain().set(true, forKey: "inTest")
        AuroraKeychain().set("testing", forKey: "testValue")
    }

//    func testRead() {
//        XCTAssertEqual(
//            AuroraKeychain().getBool("inTest"),
//            true
//        )
//
//        XCTAssertEqual(
//            AuroraKeychain().get("testValue"),
//            "testValue"
//        )
//    }

    func testReset() {
        AuroraKeychain().delete("inTest")

        XCTAssertEqual(
            AuroraKeychain().getBool("inTest"),
            nil
        )
    }
}
#endif
