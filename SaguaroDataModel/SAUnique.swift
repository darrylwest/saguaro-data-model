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
        let uuid = UUID()

        return uuid.uuidString.lowercased()
    }

    static public func createModelId() -> String {
        let uuid = NSUUID().uuidString.lowercased()
        let mid = uuid.replacingOccurrences(of: "-", with:"")

        return mid
    }
}
