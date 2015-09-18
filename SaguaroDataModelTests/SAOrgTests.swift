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
        let url = randomData.url
        let assets = "myassets"
        let info = SAContactInfo(doi: SADocumentIdentifier(), givenName: name)
        let org = SAOrg(doi:doi, name: name, url: url, assets: assets, contactInfo: info)

        XCTAssertEqual(org.doi, doi, "doi match")
        XCTAssertEqual(org.name, name, "name match")
        XCTAssertEqual(org.status, SADataModelStatus.Active, "active")
    }
    
}
