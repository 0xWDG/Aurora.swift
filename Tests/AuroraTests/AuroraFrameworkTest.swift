// $$HEADER$$

import Foundation
import XCTest

@testable import Aurora

class AuroraTest: XCTestCase {
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
        XCTAssert(log("This is a test"), "Should be true")
    }
}
