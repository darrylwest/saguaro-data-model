//
//  SAUser.swift
//  SaguaroDataModel
//
//  Created by darryl west on 7/23/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import Foundation

public enum SAUserStatus: String {
    case Active = "active"
    case Inactive = "inactive"
    case Banned = "banned"
    case Deleted = "deleted"
}

public protocol SAUserModel: SADataModelType, SAMappable {
    var doi:SADocumentIdentifier { get }
    var username:String { get }
    var session:String { get }
    var status:SAUserStatus { get }
}

public struct SAUser {
    public let doi:SADocumentIdentifier
    public let username:String
    public let session:String
    public let status:SAUserStatus

    public init(doi:SADocumentIdentifier, username:String, session:String, status:SAUserStatus? = .Active) {
        self.doi = doi
        self.username = username
        self.session = session
        self.status = status!
    }
}

