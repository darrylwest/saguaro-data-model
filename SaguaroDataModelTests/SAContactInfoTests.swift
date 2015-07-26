//
//  SAContactInfoTests.swift
//  SaguaroDataModel
//
//  Created by darryl west on 7/24/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import XCTest
import SaguaroDataModel

class SAContactInfoTests: XCTestCase {
    
    let randomData = RandomFixtureData()
    let dataset = TestDataset()

    func testInstance() {
        let doi = SADocumentIdentifier()
        let givenName = randomData.firstName

        var info = SAContactInfo(doi: doi, givenName: givenName)

        info.familyName = randomData.lastName

        XCTAssertEqual(info.doi.id, doi.id, "id should match")
        XCTAssertEqual(info.doi.dateCreated, doi.dateCreated, "id should match")
        XCTAssertEqual(info.givenName, givenName, "names should match")
        XCTAssertEqual(info.fullName, "\( givenName ) \( info.familyName! )", "full name")
    }

    func testAddEmail() {
        let doi = SADocumentIdentifier()
        let givenName = randomData.firstName

        var info = SAContactInfo(doi: doi, givenName: givenName)

        let emails = [
            SALabeledValue( label: .Home, value: randomData.email ),
            SALabeledValue( label: .Work, value: randomData.email )
        ]

        for email in emails {
            print("email: \(email.label) \( email.value )")

            info.addEmail( email )
        }

        XCTAssertEqual(info.emails.count, 2, "count should match")
    }

    func testRemoveEmail() {
        let doi = SADocumentIdentifier()
        let givenName = randomData.firstName

        var info = SAContactInfo(doi: doi, givenName: givenName)

        let emails = [
            SALabeledValue( label: .Home, value: randomData.email ),
            SALabeledValue( label: .Primary, value: randomData.email ),
            SALabeledValue( label: .Work, value: randomData.email )
        ]

        for email in emails {
            print("email: \(email.label) \( email.value )")
            info.addEmail( email )
        }

        if let removed = info.removeEmail( emails[ 0 ] ) {
            XCTAssertEqual(emails[ 0 ], removed, "emails should match")
            XCTAssertEqual(info.emails.count, 2, "count should match")
        } else {
            XCTFail("email remove failed")
        }
    }

    func testToMap() {
        let info = dataset.createComplexContactInfo()

        let map = info.toMap()
        
        XCTAssertEqual(map["id"] as! String, info.doi.id, "id match")
        XCTAssertEqual(map["version"] as! Int, 0, "version check")

        XCTAssertEqual(map["givenName"] as! String, info.givenName, "name check")

        let emails = map[ "emails" ] as! [[String:String]]
        let phones = map[ "phones" ] as! [[String:String]]
        let mailing = map[ "mailing" ] as! [[String:String]]
        let locations = map[ "locations" ] as! [String]

        // verify three emails and phones
        XCTAssertEqual(emails.count, info.emails.count, "email count")
        XCTAssertEqual(phones.count, info.phones.count, "phone count")
        XCTAssertEqual(mailing.count, info.mailing.count, "one mailing addresses")
        XCTAssertEqual(locations.count, info.locations.count, "one locations")

        // find each type and confirm the count
        for type in dataset.createInfoTypes() {
            XCTAssertEqual( emails.filter { return $0[ type.rawValue ] != nil }.count, 1, "should find one \( type ) email")
            XCTAssertEqual( phones.filter { return $0[ type.rawValue ] != nil }.count, 1, "should find one \( type ) phones")
        }

        XCTAssertEqual(map[ "status" ] as! String, SADataModelStatus.Active.rawValue, "test status")
    }

    func testFromMap() {
        let map = dataset.createContactInfoMap()

        guard let info = SAContactInfo.fromMap( map ) else {
            XCTFail("could not create map")
            return
        }

        XCTAssertEqual(info.doi.id, map["id"] as! String, "id match")
        XCTAssertEqual(info.doi.version, map["version"] as! Int, "version")
        XCTAssertEqual(info.givenName, map["givenName"] as! String, "given name")
        XCTAssertEqual(info.familyName!, map["familyName"] as! String, "family name")
        XCTAssertEqual(info.status.rawValue, map["status"] as! String, "status")

        XCTAssertEqual(info.emails.count, 3, "email count")
        XCTAssertEqual(info.phones.count, 3, "phone count")
        XCTAssertEqual(info.mailing.count, 1, "mailing count")
        XCTAssertEqual(info.locations.count, 1, "locations count")
    }
}
