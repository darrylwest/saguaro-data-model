//
//  SAUpdateQueueTests.swift
//  SaguaroDataModel
//
//  Created by darryl west on 9/20/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import XCTest
@testable import SaguaroDataModel

class SAUpdateQueueTests: XCTestCase {
    let dataset = TestDataset()

    func noopAction(user:SAUserModel) {
        print("user: \( user.doi )")
    }

    func testInstance() {
        let queue = SAUpdateQueue<SAUserModel>(updateAction: noopAction)

        XCTAssertEqual(queue.count, 0, "should be empty")
    }

    func testQueue() {
        let queue = SAUpdateQueue<SAUserModel>(updateAction: noopAction, quietTimeout: NSTimeInterval( 0.5 ))

        for n in 1...5 {
            let user = dataset.createUser()

            queue.queue(user.doi.id, item: user)

            XCTAssertEqual(queue.count, n, "should match iteration count")
            XCTAssert( NSDate().isBeforeDate( queue.lastQueueTime ), "should always bump up the last time")
            XCTAssertEqual(queue.checkUpdateQueue(), false, "should not be ready for updates")
        }

        queue.flushQueue()
        XCTAssertEqual(queue.count, 0, "should be zero again")

    }

    func testDupQueue() {

        let queue = SAUpdateQueue<SAUserModel>(updateAction: noopAction, quietTimeout: NSTimeInterval( 0.5 ))

        let user = dataset.createUser()

        for _ in 1...5 {
            let user = user.updateVersion()
            queue.queue(user.doi.id, item: user)

            XCTAssertEqual(queue.count, 1, "should match iteration count")
            XCTAssert( NSDate().isBeforeDate( queue.lastQueueTime ), "should always bump up the last time")
            XCTAssertEqual(queue.checkUpdateQueue(), false, "should not be ready for updates")
        }

        queue.flushQueue()
        XCTAssertEqual(queue.count, 0, "should be zero again")
    }
    
}
