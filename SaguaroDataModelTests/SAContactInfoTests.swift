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

        XCTAssertEqual(emails.count, 3, "email count")
        XCTAssertEqual(phones.count, 3, "phone count")

        XCTAssertEqual(map[ "status" ] as! String, SADataModelStatus.Active.rawValue, "test status")
    }
}
