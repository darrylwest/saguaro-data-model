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
    // let jnparser = JNParser()

    func createModelId() -> String {
        return NSUUID().uuidString.lowercased().replacingOccurrences(of: "-", with:"")
    }

    func testInstance() {
        let doi = SADocumentIdentifier()

        XCTAssertNotNil(doi.id, "doi should not be nil")
        XCTAssertNotNil(doi.dateCreated, "doi should not be nil")
        XCTAssertNotNil(doi.lastUpdated, "doi should not be nil")
        XCTAssertNotNil(doi.version, "doi should not be nil")

        // XCTAssert(doi.dateCreated == doi.lastUpdated, "dates should match")
        XCTAssertEqual(doi.version, 0, "version is zero")
    }
    
    func testInstanceWithOptionalInputs() {
        let id = createModelId()
        
        let doi = SADocumentIdentifier( id: id )
        
        XCTAssertNotNil(doi.id, "doi should not be nil")
        XCTAssertEqual(doi.id, id, "id match")
        XCTAssertNotNil(doi.dateCreated, "doi should not be nil")
        XCTAssertNotNil(doi.lastUpdated, "doi should not be nil")
        XCTAssertNotNil(doi.version, "doi should not be nil")
        
        // XCTAssert(doi.dateCreated == doi.lastUpdated, "dates should match")
        XCTAssertEqual(doi.version, 0, "version is zero")
        
    }

    func testInstanceWithInputs() {
        let id = createModelId()
        let created = Date().addingTimeInterval( -120.5 )
        let updated = Date().addingTimeInterval( -60.0 )
        let version = 5

        let doi = SADocumentIdentifier(id: id, dateCreated: created, lastUpdated: updated, version: version)

        XCTAssertEqual(doi.id, id, "doi should match")
        XCTAssertEqual(doi.dateCreated, created, "doi should match")
        XCTAssertEqual(doi.lastUpdated, updated, "doi should match")
        XCTAssertEqual(doi.version, version, "doi should match")

    }

    func testUpdateVersion() {
        let id = createModelId()
        let created = Date().addingTimeInterval( -120.5 )
        let updated = Date().addingTimeInterval( -60.0 )
        let version = 10

        let ref = SADocumentIdentifier(id: id, dateCreated: created, lastUpdated: updated, version: version)

        let doi = ref.updateVersion()

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

    func testToMap() {
        let id = SAUnique.createModelId()
        let created = Date() // jnparser.dateFromString( "2015-01-01T00:00:00.000Z" )!
        let updated = Date() // jnparser.dateFromString( "2015-02-20T00:00:00.000Z" )!
        let version = 99

        let doi = SADocumentIdentifier(id: id, dateCreated: created, lastUpdated: updated, version: version)
        
        let map = doi.toMap()

        XCTAssertEqual(map["id"] as? String, id, "id match")
        XCTAssertEqual(map["dateCreated"] as? Date, created, "created")
        XCTAssertEqual(map["lastUpdated"] as? Date, updated, "updated")
        XCTAssertEqual(map["version"] as? Int, version, "version")
    }

    func testFromMap() {
		let map: [String : AnyObject] = [
            "id": SAUnique.createModelId() as AnyObject,
            "dateCreated": Date().addingTimeInterval(-10.5) as AnyObject,
            "lastUpdated": Date().addingTimeInterval(-6.0) as AnyObject,
            "version": 2 as AnyObject
        ]

        guard let doi = SADocumentIdentifier.fromMap( map ) else {
            XCTFail("could not create doi from map: \( map )")
            return
        }

        XCTAssertEqual(doi.id, map["id"] as? String, "id")
        XCTAssertEqual(doi.dateCreated, map["dateCreated"] as? Date, "created")
        XCTAssertEqual(doi.lastUpdated, map["lastUpdated"] as? Date, "updated")
        XCTAssertEqual(doi.version, map["version"] as? Int, "version")
    }
    
}
