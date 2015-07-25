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
    var url:String  { get }
    var assets:String  { get }
    var contactInfo:SAContactInfo { get }
    var contactList:[SAContactInfo] { get }
    var status:SADataModelStatus { get }
}

public struct SAOrg: SAOrgModel {
    public let doi:SADocumentIdentifier
    public let name:String
    public let url:String
    public let assets:String
    public let contactInfo:SAContactInfo
    public let contactList:[SAContactInfo]
    public let status:SADataModelStatus

    public init(doi:SADocumentIdentifier, name:String, url:String, assets:String, contactInfo:SAContactInfo, contactList:[SAContactInfo]? = [SAContactInfo](), status:SADataModelStatus? = .Active) {
        self.doi = doi
        self.name = name
        self.url = url
        self.assets = assets
        self.contactInfo = contactInfo

        self.contactList = contactList!
        self.status = status!
    }

    public func toMap() -> [String:AnyObject] {
        var map = doi.toMap()

        map[ "name" ] = name
        map[ "url" ] = url
        map[ "assets" ] = assets
        map[ "contactInfo" ] = contactInfo.toMap()
        map[ "contactList" ] = contactList.map { $0.toMap() }
        map[ "status" ] = status.rawValue

        return map
    }
}