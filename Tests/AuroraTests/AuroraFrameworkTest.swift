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

#if !os(watchOS)
import Foundation
import XCTest

@testable import Aurora

public class TestObserver: NSObject, XCTestObservation {
    public static func observe() {
        let observer = TestObserver()
        XCTestObservationCenter.shared.addTestObserver(observer)
    }

    public func testCase(
        _ testCase: XCTestCase,
        didFailWithDescription description: String,
        inFile filePath: String?,
        atLine lineNumber: Int) {
        print("🚫 \(description) line:\(lineNumber)")
    }

    public func testCaseDidFinish(_ testCase: XCTestCase) {
        if testCase.testRun?.hasSucceeded == true {
            print("✅ \(testCase)")
        }
    }

}

class AuroraTest: XCTestCase {
    func testAAAStartObserver() {
        TestObserver.observe()
    }

    func disabledtestKCReset() {
        try? Aurora.Keychain.delete(account: "itemName")
    }

    func disabledtestKCRead() {
        // testKCReset()

        @KeychainItem("itemName", default: Aurora.AFnil)
        var itemName: String

        // Since property wrappers can't be nil.
        // Use this for a nil check:
        if itemName == Aurora.AFnil {
           // No value set.
            print("No value")
        }

        XCTAssertEqual(itemName, Aurora.AFnil)
    }

    func disabledtestKCWrite() {
        @KeychainItem("itemName", default: Aurora.AFnil)
        var itemName: String

        itemName = "Hello"

        XCTAssertEqual(itemName, "Hello")
    }

    func testAuroraLog() {
        Aurora.shared.log("This is a test")
    }

    func testRegexTrue() {
        let regexMatch = "qqqqlOldddd" =~ "l(o|O)l"
        XCTAssert(regexMatch == true)
    }

    func testRegexFalse() {
        let regexMatch = "qqqqlxldddd" =~ "l(o|O)l"
        XCTAssert(regexMatch != true, "Regex must fail")
    }

    func testLocalLog() {
        XCTAssert(Aurora.shared.log("This is a test"), "Should be true")
    }
}

#endif
