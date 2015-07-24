//
//  SAOrg.swift
//  SaguaroDataModel
//
//  Created by darryl west on 7/23/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import Foundation

public enum SADataModelStatus:String {
    case Active = "active"
    case Inactive = "inactive"
    case Deleted = "deleted"
}

public protocol SAOrgModel: SADataModelType {
    var doi:SADocumentIdentifier { get }
    var name:String { get }
    // var contactInfo:SAContactInfo
    var status:SADataModelStatus { get }
}

public struct SAOrg: SAOrgModel {
    public let doi:SADocumentIdentifier
    public let name:String
    public let status:SADataModelStatus

    public init(doi:SADocumentIdentifier, name:String, status:SADataModelStatus? = .Active) {
        self.doi = doi
        self.name = name
        self.status = status!
    }
}