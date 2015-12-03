//
//  SAUndoRedoTests.swift
//  SaguaroDataModel
//
//  Created by darryl west on 8/16/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import XCTest
@testable import SaguaroDataModel

class SAUndoRedoTests: XCTestCase {
    let dataset = TestDataset()

    func testInstance() {
        let undo = SAUndoRedo<Int>()

        XCTAssertEqual(undo.maxSize, 50, "default max size")
        XCTAssertEqual(undo.undoCount, 0, "zero undo's")
        XCTAssertEqual(undo.redoCount, 0, "zero redo's")
    }

    func testSave() {
        var undo = SAUndoRedo<SAOrgModel>()
        var org = dataset.createOrg()

        undo.save( org )

        XCTAssertEqual(undo.undoCount, 1, "one undo's")
        XCTAssertEqual(undo.redoCount, 0, "zero redo's")

        org = SAOrg(doi: org.doi, name:"My New Name", url:"http://new.org.com", assets:"new set of assets", contactInfo: org.contactInfo, contactList: org.contactList, status: org.status)

        undo.save( org )
        XCTAssertEqual(undo.undoCount, 2, "two undo's")
        XCTAssertEqual(undo.redoCount, 0, "zero redo's")

    }

    func testUndoRedo() {
        var undo = SAUndoRedo<SAOrg>()
        let org1 = dataset.createOrg()

        undo.save( org1 )

        XCTAssertEqual(undo.undoCount, 1, "one undos'")
        XCTAssertEqual(undo.redoCount, 0, "zero redo's")

        let org2 = SAOrg(doi: org1.doi, name:"My New Name", url:"http://new.org.com", assets:"new set of assets", contactInfo: org1.contactInfo, contactList: org1.contactList, status: org1.status)

        undo.save( org2 )
        XCTAssertEqual(undo.undoCount, 2, "two undos'")
        XCTAssertEqual(undo.redoCount, 0, "zero redo's")

        let org3 = undo.undo()!
        XCTAssertEqual(undo.undoCount, 1, "one")
        XCTAssertEqual(undo.redoCount, 1, "one")
        XCTAssertEqual(org3.name, org2.name, "My New Name")
        XCTAssertEqual(org3.url, org2.url, "http://new.org.com")

        let org4 = undo.redo()!
        XCTAssertEqual(undo.undoCount, 1, "two undos'")
        XCTAssertEqual(undo.redoCount, 0, "zero redo's")
        XCTAssertEqual(org4.name, org2.name, "name test")
        XCTAssertEqual(org4.url, org2.url, "url test")

    }
}
