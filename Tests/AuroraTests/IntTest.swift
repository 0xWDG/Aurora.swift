//
//  IntTest.swift
//  Aurora
//
//  Created by Wesley de Groot on 19/06/2020.
//

#if !os(watchOS)
import XCTest

@testable import Aurora

/// Aurora Int Extension Tests.
class AuroraIntTest: XCTestCase {
    // XCTAssert is the same as XCTAssertTrue
    // True = good.
    // False = bad.

    /// A random odd number (1)
    let myOddNumber = 1

    /// A random even number (2)
    let myEvenNumber = 2

    /// A static number to convert
    let convertMe = 13

    /// This is a positive number
    let iAmPositive = 10

    /// This number is negative
    let iAmNegative = -10

    /// This number is a 'Double'
    let iAmADouble: Double = 1.0

    /// This number is a 'Float'
    let iAmAFloat: Float = 2.0

    /// This number is a 'String'
    let iAmAString: String = "3"

    /// This number is a 'UInt'
    let iAmAUInt: UInt = 4

    /// This number is a 'Int32'
    let iAmAInt32: Int32 = 5

    /// This number is a 'CountableRange'
    let myRange: CountableRange<Int> = 0..<10

    #if canImport(UIKit)
    /// This number is a 'CGFloat'
    let iAmACGFloat: CGFloat = 6
    #endif
    
    /// Test for function toString(...).
    /// toString is the same as the JavaScript equivallent
    func test_func_toString() {
        // This is a valid value
        XCTAssert(
            convertMe.toString(16) == "d",
            "[JS] The value should be d"
        )
        
        // This is a valid value
        XCTAssert(
            convertMe.toString(8) == "15",
            "[JS] The value should be 15"
        )
        
        // This is a valid value
        XCTAssert(
            convertMe.toString(2) == "1101",
            "[JS] The value should be 1101"
        )
        
        // This is a invalid value
        XCTAssert(
            convertMe.toString(12345) == "13",
            "[JS] The value should be 13"
        )
    }
    
    /// Test for "var isOdd"
    func test_isOdd() {
        XCTAssertTrue(
            myOddNumber.isOdd,
            "This number should be odd"
        )
        
        XCTAssertFalse(
            myEvenNumber.isOdd,
            "This number should be even"
        )
    }
        
    /// Test for "var isEven"
    func test_isEven() {
        XCTAssertFalse(
            myOddNumber.isEven,
            "This number should be odd"
        )
        
        XCTAssertTrue(
            myEvenNumber.isEven,
            "This number should be even"
        )
    }
    
    /// Test for "var isNegative"
    func test_isNegative() {
        XCTAssert(
            iAmNegative.isNegative,
            "This number should be negative"
        )
        
        XCTAssertFalse(
            iAmPositive.isNegative,
            "This number should be positive"
        )
    }

    /// Test for "var isPositive"
    func test_isPositive() {
        XCTAssert(
            iAmPositive.isPositive,
            "This number should be positive"
        )
        
        XCTAssertFalse(
            iAmNegative.isPositive,
            "This number should be negative"
        )
    }

    /// Test for "var toPositive"
    /// This tests if we can convert a negative number to a positive number
    func test_toPositive() {
        // We want to make sure it's negative,
        // otherwise the next test does not make sense at all
        XCTAssert(
            iAmNegative.isNegative,
            "This number should be negative"
        )
        
        // The actual test.
        XCTAssert(
            iAmNegative.toPositive.isPositive,
            "It number should be positive"
        )
    }
    
    /// Test for "var toDouble"
    func test_toDouble() {
        XCTAssert(
            1.toDouble == iAmADouble,
            "This number should be a Double"
        )
    }
    
    /// Test for "var toFloat"
    func test_toFloat() {
        XCTAssert(
            2.toFloat == iAmAFloat,
            "This number should be a Float"
        )
    }

    /// Test for "var toString"
    func test_toString() {
        XCTAssert(
            3.toString == iAmAString,
            "This number should be a String"
        )
    }

    /// Test for "var toUInt"
    func test_toUInt() {
        XCTAssert(
            4.toUInt == iAmAUInt,
            "This number should be a UInt"
        )
    }
    
    /// Test for "var toInt32"
    func test_toInt32() {
        XCTAssert(
            5.toInt32 == iAmAInt32,
            "This number should be a Int32"
        )
    }
    
    /// Test for "var range"
    func test_range() {
        XCTAssert(
            10.range == myRange,
            "This should be a range from 0<10"
        )
    }
    
    /// Test for "var toCGFloat"
    func test_toCGFloat() {
        #if canImport(UIKit)
        XCTAssert(
            6.toCGFloat == iAmACGFloat,
            "This should be a CGFloat now"
        )
        #else
        print("Test Case '-[AuroraTests.AuroraIntTest test_toCGFloat]' skipped. (not supported on this platform)")
        #endif
    }
    
    /// Test for "func times"
    func test_func_times() {
        var counter = 0
        
        10.times {
            counter += 1
        }
        
        XCTAssert(
            counter == 10,
            "it should have happend 10 times"
        )
    }
    
    /// Test for "func timesMake"
    func test_func_timesMake() {
        // This returns [5, 5, 5, 5, 5]
        let timesMake = 5.timesMake({ () -> Int in
            return 5
        })
        
        XCTAssert(
            timesMake == [5, 5, 5, 5, 5],
            "It should be an array with 5 times the number 5 in it"
        )
    }
}
#endif
