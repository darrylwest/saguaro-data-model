//
//  SAUserTests.swift
//  SaguaroDataModel
//
//  Created by darryl west on 7/23/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import XCTest
import SaguaroDataModel

class SAUserTests: XCTestCase {
    let randomData = RandomFixtureData()

    func testInstance() {
        let doi = SADocumentIdentifier()
        let username = randomData.username
        let session = SAUnique.createUUID()
        let user = SAUser(doi:doi, username: username, session: session)

        XCTAssertEqual(user.doi, doi, "doi match")
        XCTAssertEqual(user.username, username, "username match")
        XCTAssertEqual(user.session, session, "session match")
        XCTAssertEqual(user.status, .Active, "active")
    }
    
}
