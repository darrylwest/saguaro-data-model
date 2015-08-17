//
//  SAStackTests.swift
//  SaguaroDataModel
//
//  Created by darryl west on 8/16/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import XCTest
import SaguaroDataModel

class SAStackTests: XCTestCase {
    let dataset = TestDataset()

    func testInstance() {
        var stack = SAStack<String>()

        stack.push("this string")
        stack.push("that string thing")
        stack.push("my third string")

        XCTAssertEqual(stack.count, 3, "stack now has three elements")

        for _ in 0...stack.count {
            if let v:String = stack.pop() {
                print("v = \( v )")
            } else {
                print("value is nil")
                break
            }
        }
    }

    func testIntStack() {
        var stack = SAStack<Int>()

        stack.push( 545 )
        stack.push( 443 )
        stack.push( 222 )

        XCTAssertEqual(stack.count, 3, "should have 3 elements")

        var item = stack.pop()!
        XCTAssertEqual(item, 222, "should equal the last value pushed")

        item = stack.pop()!
        XCTAssertEqual(item, 443, "second item from stack")

        item = stack.pop()!
        XCTAssertEqual(item, 545, "last item from stack")

        XCTAssertEqual(stack.isEmpty, true, "stack empty")
        XCTAssertEqual(stack.count, 0, "zero")
    }

    func testPeek() {
        var stack = SAStack<Int>()

        if let item = stack.peek() {
            XCTFail("should return nil but returned \( item )")
        }

        stack.push( 1 )
        stack.push( 2 )
        stack.push( 3 ) /// 3 should be on top of stack

        XCTAssertEqual(stack.count, 3, "should have 3 elements")
        XCTAssertEqual(stack.peek()!, 3, "should return top of stack")
        XCTAssertEqual(stack.count, 3, "should still have 3 elements")
    }

    func testObjectStack() {
        var stack = SAStack<SAOrg>()

        let list = [ dataset.createOrg(), dataset.createOrg(), dataset.createOrg(), dataset.createOrg() ]
        for org in list {
            stack.push( org )
        }

        XCTAssertEqual(stack.count, list.count, "should match")

        var idx = list.count
        while (idx > 0) {
            idx--
            let org = stack.pop()!
            print( org.doi.id )
            XCTAssertEqual(org.doi, list[ idx ].doi, "doi check" )
        }

    }

    func testCappedStack() {
        var stack = SAStack<Int>( capLimit: 3 )

        for (var i = 0; i < 10; i++) {
            stack.push( i )
            XCTAssert( stack.count <= 3 )
            XCTAssertEqual( stack.peek()!, i, "verify value")
        }
    }
}
