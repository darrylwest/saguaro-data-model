//
//  SAUniqueTests.swift
//  SaguaroDataModel
//
//  Created by darryl west on 7/23/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import XCTest
import SaguaroDataModel

class SAUniqueTests: XCTestCase {
    
    func testCreateUUID() {
        let uuid = SAUnique.createUUID()

        XCTAssertNotNil( uuid, "uuid should not be null")
        let size = uuid.characters.count;

        XCTAssertEqual( size, 36, "uuid should have a predictable size")
    }

    func testCreateModelId() {
        let mid = SAUnique.createModelId()

        XCTAssertNotNil( mid, "model id should not be null")
        let size = mid.characters.count;

        XCTAssertEqual( size, 32, "uuid should have a predictable size")
    }
    
}
