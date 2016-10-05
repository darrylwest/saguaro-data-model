//
//  SATimerTests.swift
//  SaguaroDataModel
//
//  Created by darryl west on 9/20/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import XCTest
@testable import SaguaroDataModel

class SATimerTests: XCTestCase {
    let timeout = TimeInterval( 8.0 )
    let expectationName = "timerComplete"
    
    func testAfterInstance() {
        func action() {
            XCTFail("should not fire if not started")
        }

        let interval = TimeInterval( 0.1 )
        let timer = SATimer(after: interval, action:action)

        XCTAssertEqual(timer.valid, true, "valid")
        XCTAssertEqual(timer.interval, interval, "int check")
        XCTAssertEqual(timer.oneShot, true)
    }

    func testEveryInstance() {
        func action() {
            XCTFail("should not fire if not started")
        }

        let interval = TimeInterval( 0.1 )
        let timer = SATimer(every: interval, action:action)

        XCTAssertEqual(timer.valid, true, "valid")
        XCTAssertEqual(timer.interval, interval, "int check")
        XCTAssertEqual(timer.oneShot, false)
    }

    func testIntervalTimer() {
        let expectation = self.expectation( description: expectationName )

        var timer:SATimer?
        var count = 5

        func callback() -> Void {
            count -= 1
            if count == 0 {
                expectation.fulfill()

                if let t = timer {
                    t.stop()

                    XCTAssertEqual(t.valid, false, "should be invalid")
                }

                print("testIntervalTimer() done")
            } else {
                print("count: \( count ) \( Date().timeIntervalSince1970 )")
            }
        }

        let interval = TimeInterval( 0.25 )
        timer = SATimer(every: interval, action: callback )

        if let t = timer {
            t.start()
            XCTAssertEqual(t.valid, true, "timer should be valid")
        } else {
            XCTFail("timer is not valid")
        }

        waitForExpectations(timeout: timeout, handler: { error in
            XCTAssertNil(error, "async error: \( error )")
        })
    }

    func testOneShotTimer() {
        let expectation = self.expectation( description: expectationName )

        func callback() -> Void {
            expectation.fulfill()

            print("testWithNew() done")
        }

        let timer = SATimer(after: TimeInterval( 0.25 ), action: callback )
        timer.start()

        waitForExpectations(timeout: timeout, handler: { error in
            XCTAssertNil(error, "async error: \( error )")
        })
    }
    
}
