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
        Aurora.Keychain().set(true, forKey: "inTest")
        Aurora.Keychain().set("testing", forKey: "testValue")
    }

//    func testRead() {
//        XCTAssertEqual(
//            Aurora.Keychain().getBool("inTest"),
//            true
//        )
//
//        XCTAssertEqual(
//            Aurora.Keychain().get("testValue"),
//            "testValue"
//        )
//    }

    func testReset() {
        Aurora.Keychain().delete("inTest")

        XCTAssertEqual(
            Aurora.Keychain().getBool("inTest"),
            nil
        )
    }
}
#endif
