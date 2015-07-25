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
    var org:SAOrg { get }
    var contactInfo:SAContactInfo { get set }
    var status:SAUserStatus { get }

    func toMap() -> [String:AnyObject]
}

public struct SAUser {
    public let doi:SADocumentIdentifier
    public let username:String
    public let session:String
    public let org:SAOrg
    public let contactInfo:SAContactInfo
    public let status:SAUserStatus

    public init(doi:SADocumentIdentifier, username:String, session:String, contactInfo:SAContactInfo, org:SAOrg, status:SAUserStatus? = .Active) {
        self.doi = doi
        self.username = username
        self.session = session
        self.org = org
        self.contactInfo = contactInfo
        self.status = status!
    }

    public func toMap() -> [String:AnyObject] {
        var map = doi.toMap()

        map["username"] = username
        map["session"] = session
        map["orgId"] = org.doi.id
        map["contactInfo"] = contactInfo.toMap()
        map["status"] = status.rawValue

        return map
    }
}

