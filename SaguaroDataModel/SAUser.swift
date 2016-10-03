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
    var org:SAOrgModel { get }
    var contactInfo:SAContactInfo { get set }
    var status:SAUserStatus { get }

    func toMap() -> [String:AnyObject]
    func updateVersion() -> SAUserModel
}

public struct SAUser: SAUserModel {
    public let doi:SADocumentIdentifier
    public let username:String
    public let session:String
    public let org:SAOrgModel
    public var contactInfo:SAContactInfo
    public let status:SAUserStatus

    public init(doi:SADocumentIdentifier, username:String, session:String, contactInfo:SAContactInfo, org:SAOrgModel, status:SAUserStatus? = .Active) {
        self.doi = doi
        self.username = username
        self.session = session
        self.org = org
        self.contactInfo = contactInfo
        self.status = status!
    }

    public func toMap() -> [String:AnyObject] {
        var map = doi.toMap()

        map["username"] = username as AnyObject
        map["session"] = session as AnyObject
        map["orgId"] = org.doi.id as AnyObject
        map["contactInfo"] = contactInfo.toMap() as AnyObject
        map["status"] = status.rawValue as AnyObject

        return map
    }

    public func updateVersion() -> SAUserModel {
        return SAUser(
            doi: self.doi.updateVersion(),
            username: self.username,
            session: self.session,
            contactInfo: self.contactInfo,
            org: self.org,
            status: self.status
        )
    }
}

