//
//  SAOrg.swift
//  SaguaroDataModel
//
//  Created by darryl west on 7/23/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import XCTest
import SaguaroDataModel

class SAOrgTests: XCTestCase {
    let randomData = RandomFixtureData()

    func testInstance() {
        let doi = SADocumentIdentifier()
        let name = randomData.companyName
        let org = SAOrg(doi:doi, name: name)

        XCTAssertEqual(org.doi, doi, "doi match")
        XCTAssertEqual(org.name, name, "name match")
        XCTAssertEqual(org.status, .Active, "active")
    }
    
}
