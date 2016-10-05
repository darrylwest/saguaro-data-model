//
//  TestDataset.swift
//  SaguaroDataModel
//
//  Created by darryl west on 7/24/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import Foundation
import SaguaroJSON
import SaguaroDataModel

class TestDataset {
    let randomData = RandomFixtureData()
    let jnparser = JNParser()

    func createSimpleContactInfo(_ name:String? = "Sammy") -> SAContactInfo {
        let doi = SADocumentIdentifier()
        let info = SAContactInfo(doi: doi, givenName: name!)

        return info
    }

    func createInfoTypes() -> [SAInfoType] {
        return [ SAInfoType.Work, SAInfoType.Home, SAInfoType.Other ]
    }

    func createComplexContactInfo() -> SAContactInfo {
        var info = self.createSimpleContactInfo( randomData.firstName )
        info.familyName = randomData.lastName
        
        let types = createInfoTypes()

        for type in types {
            info.addEmail( SALabeledValue( keyValue: [ type.rawValue : randomData.email ] )! )
            info.addPhone( SALabeledValue( keyValue: [ type.rawValue : randomData.phone ] )! )
        }

        info.addMailing( SALabeledValue( label: .Primary, value: "123 State Street, Winston, MA, 00433"))

        info.addLocation(SALocation(latitude: 37.2909813, longitude: -121.890413599 ))

        return info
    }

    func createContactInfoMap() -> [String:AnyObject] {
        let info = createComplexContactInfo()
        return info.toMap()
    }

    func createOrg() -> SAOrg {
        let info = createComplexContactInfo()
        return SAOrg(doi: SADocumentIdentifier(), name: randomData.companyName, url: randomData.url, assets: "myassets", contactInfo: info)
    }

    func createUser() -> SAUserModel {
        let org = createOrg()

        let doi = SADocumentIdentifier()
        let username = randomData.username
        let session = SAUnique.createUUID()
        let info = SAContactInfo(doi: SADocumentIdentifier(), givenName: randomData.firstName)
        let user = SAUser(doi:doi, username: username, session: session, contactInfo: info, org: org)

        return user
    }
}
