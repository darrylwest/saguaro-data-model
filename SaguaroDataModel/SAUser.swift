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

public protocol SAUser: SADataModelType, SAMappable {
    var doi:SADocumentIdentifier { get }
    var username:String { get }
    var session:String { get }
    var status:SAUserStatus { get }
}

