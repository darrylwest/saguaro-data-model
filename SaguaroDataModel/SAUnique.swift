//
//  SAUnique.swift
//  SaguaroDataModel
//
//  Created by darryl west on 7/23/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import Foundation

public struct SAUnique {
    static public func createUUID() -> String {
        let uuid = NSUUID()

        return uuid.UUIDString.lowercaseString
    }

    static public func createModelId() -> String {
        let uuid = NSUUID().UUIDString.lowercaseString
        let mid = uuid.stringByReplacingOccurrencesOfString("-", withString:"")

        return mid
    }
}
