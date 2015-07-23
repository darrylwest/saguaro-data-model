//
//  SADocumentIdentifier.swift
//  SaguaroDataModel
//
//  Created by darryl west on 7/23/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import XCTest
import SaguaroDataModel

class SADocumentIdentifierTests: XCTestCase {

    func createModelId() -> String {
        return NSUUID().UUIDString.lowercaseString.stringByReplacingOccurrencesOfString("-", withString:"")
    }

    func testInstance() {
        let doi = SADocumentIdentifier()

        XCTAssertNotNil(doi.id, "doi should not be nil")
        XCTAssertNotNil(doi.dateCreated, "doi should not be nil")
        XCTAssertNotNil(doi.lastUpdated, "doi should not be nil")
        XCTAssertNotNil(doi.version, "doi should not be nil")

        XCTAssertEqual(doi.dateCreated, doi.lastUpdated, "dates should match")
        XCTAssertEqual(doi.version, 0, "version is zero")
    }

    func testInstanceWithInputs() {
        let id = createModelId()
        let created = NSDate().dateByAddingTimeInterval( -120.5 )
        let updated = NSDate().dateByAddingTimeInterval( -60.0 )
        let version = 5

        let doi = SADocumentIdentifier(id: id, dateCreated: created, lastUpdated: updated, version: version)

        XCTAssertEqual(doi.id, id, "doi should match")
        XCTAssertEqual(doi.dateCreated, created, "doi should match")
        XCTAssertEqual(doi.lastUpdated, updated, "doi should match")
        XCTAssertEqual(doi.version, version, "doi should match")

    }

    func testUpdateVersion() {
        let id = createModelId()
        let created = NSDate().dateByAddingTimeInterval( -120.5 )
        let updated = NSDate().dateByAddingTimeInterval( -60.0 )
        let version = 10

        var doi = SADocumentIdentifier(id: id, dateCreated: created, lastUpdated: updated, version: version)

        doi.updateVersion()

        XCTAssertEqual(doi.id, id, "doi should match")
        XCTAssertEqual(doi.dateCreated, created, "doi should match")

        XCTAssertNotEqual(doi.lastUpdated, updated, "doi should match")
        XCTAssertEqual(doi.version, version + 1, "doi should match")

    }

    func testCreateModelId() {
        let id = SADocumentIdentifier.createModelId()

        XCTAssertNotNil(id, "id should not be nil")
        XCTAssertEqual(id.characters.count, 32, "should be 32 chars")
    }
    
}
