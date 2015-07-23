//
//  SAValidationDelegateTests.swift
//  SaguaroDataModel
//
//  Created by darryl west on 7/23/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import XCTest
import SaguaroDataModel

class SAValidationDelegateTests: XCTestCase {


    func testInstance() {
        let validator = SAValidationDelegate()

        XCTAssertNotNil(validator, "should not be nil")
    }

    func testIsValidUsername() {
        let validator = SAValidationDelegate()

        for _ in 0..<10 {
            let username = "fred@gmail.com"

            XCTAssert(validator.isEmail( username ), "email \( username ) should validate")
            XCTAssert(validator.isValidUsername( username ), "username \( username ) should validate")
        }
    }

    func testBadUsernames() {
        let validator = SAValidationDelegate()

        let badList = [
            "splat",
            "splat.com",
            "@domain.com",
            "fdfsdomain.comcomx"
        ]

        for username in badList {
            XCTAssertFalse(validator.isEmail( username ), "username \( username ) should validate")
        }
    }

    func testIsValidPassword() {
        let validator = SAValidationDelegate()
        let list = [
            "secret!",
            "m y p a s s w o r d!",
            "theLordIsMyShep",
            "- 63Sf9rsWtS!~B"
        ]

        for password in list {
            XCTAssert(validator.isValidPassword( password ), "\( password ) should be valid")
        }
    }

    func testBadPasswords() {
        let validator = SAValidationDelegate()
        let list = [
            "sv!",
            "m y p a s s w o r d ! t h a t has too many characters..."
        ]

        for password in list {
            XCTAssertFalse(validator.isValidPassword( password ), "\( password ) should not be valid")
        }
    }

    func testMinMaxStringRange() {
        let range = SAMinMaxRange( min: 2, max: 12 )

        XCTAssert( range.isValid( "my string" ), "should be in the range")
        // test the bounds
        XCTAssert( range.isValid( "my" ), "should be in the range")
        XCTAssert( range.isValid( "1234567890" ), "should be in the range")

        // test the fails
        XCTAssertFalse( range.isValid( "x" ), "should be too small")
        XCTAssertFalse(range.isValid( "a way long string thing" ), "should be too big")
    }

    func testMinMaxIntRange() {
        let range = SAMinMaxRange( min: 10, max: 100 )

        XCTAssert( range.isValid( 55 ), "should be in the range")
        // test the bounds
        XCTAssert( range.isValid( 10 ), "should be in the range")
        XCTAssert( range.isValid( 100 ), "should be in the range")

        // test the fails
        XCTAssertFalse( range.isValid( 9 ), "should be too small")
        XCTAssertFalse(range.isValid( 101 ), "should be too big")
    }

    func testRegexLiterals() {
        XCTAssert("abcdefg" =~ "abc", "match literal")
        XCTAssertFalse("abcdefg" =~ "fgh", "match literal")
    }

    func testEmail() {
        XCTAssert("dpw@roundpeg.com" =~ SARegExPatterns.Email, "email test")
        XCTAssertFalse("fkdlsldk@xc" =~ SARegExPatterns.Email, "fail email test")
        XCTAssertFalse("fkdlsldk@x." =~ SARegExPatterns.Email, "fail email test")
        XCTAssertFalse("f@kdlsldk1234567890" =~ SARegExPatterns.Email, "fail email test")
    }

    func testRegexWildcards() {

        XCTAssert("abcdefg" =~ "a.c", "match dot")
        XCTAssert("abcdefg" =~ "a.*b", "match dot star")
        XCTAssert("abcdefg" =~ "a.*g", "match dot star")
        XCTAssert("abcdefg" =~ "a.+g", "match dot plus")
        XCTAssertFalse("abcdefg" =~ "a.+b", "match dot plus")
    }

    func testRegexAnchor() {
        XCTAssert("abcdefg" =~ "^abc", "start anchor")
        XCTAssertFalse("abcdefg" =~ "^efg", "start anchor")
        XCTAssert("abcdefg" =~ "efg$", "end anchor")
        XCTAssertFalse("abcdefg" =~ "abc$", "end anchor")
    }

    func testUnicodeRange() {
        let value = "Hello, 火星, 🔥🌠!"
        let pattern = "[\\u6620-\\U0001F500]"
        let pattern2 = "[\\U0001F550-\\U0001FFFF]"
        var count = 0
        let matches = value =~ pattern
        for _ in matches {
            count++
        }
        XCTAssertEqual(count, 2, "count of range matches")
        XCTAssertEqual(matches[0], "火", "match (1/2)")
        XCTAssertEqual(matches[1], "🌠", "match (2/2)")

        XCTAssert(value =~ pattern, "LogicValue (1/2)")
        XCTAssertFalse(value =~ pattern2, "LogicValue (1/2)")
    }
}
