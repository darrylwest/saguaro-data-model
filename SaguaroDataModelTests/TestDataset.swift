//
//  TestDataset.swift
//  SaguaroDataModel
//
//  Created by darryl west on 7/24/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import Foundation
import SaguaroDataModel

class TestDataset {
    let randomData = RandomFixtureData()

    func createSimpleContactInfo(name:String) -> SAContactInfo {
        let doi = SADocumentIdentifier()
        let info = SAContactInfo(doi: doi, givenName: name)

        return info
    }

    func createInfoTypes() -> [SAInfoType] {
        return [ SAInfoType.Work, SAInfoType.Home, SAInfoType.Other ]
    }

    func createComplexContactInfo() -> SAContactInfo {
        var info = self.createSimpleContactInfo( randomData.firstName )
        let types = createInfoTypes()

        for type in types {
            info.addEmail( SALabeledValue( keyValue: [ type.rawValue : randomData.email ] )! )
            info.addPhone( SALabeledValue( keyValue: [ type.rawValue : randomData.phone ] )! )
        }

        return info
    }
}