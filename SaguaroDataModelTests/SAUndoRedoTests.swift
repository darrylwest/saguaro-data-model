//
//  SAUndoRedoTests.swift
//  SaguaroDataModel
//
//  Created by darryl west on 8/16/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import XCTest
import SaguaroDataModel

class SAUndoRedoTests: XCTestCase {
    let dataset = TestDataset()

    func testInstance() {
        let undo = SAUndoRedo<Int>()

        XCTAssertEqual(undo.maxSize, 20, "default max size")
    }
    
}
