//
//  DocumentIdentifier.swift
//  SaguaroDataModel
//
//  Created by darryl west on 7/23/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import Foundation

public protocol SADataModelType {
    var doi:SADocumentIdentifier { get }
}

public protocol SADataModelListType {
    var list:[SADataModelType] { get }
}

public struct SADocumentIdentifier: CustomStringConvertible {
    public let id:String
    public let dateCreated:NSDate
    public private(set) var lastUpdated:NSDate
    public private(set) var version:Int

    // initializer used for new documents
    public init() {
        id = SADocumentIdentifier.createModelId()
        dateCreated = NSDate()
        lastUpdated = NSDate()
        version = 0
    }

    // initializer for documents that currently exist
    public init(id:String, dateCreated:NSDate, lastUpdated:NSDate, version:Int) {
        self.id = id
        self.dateCreated = dateCreated
        self.lastUpdated = lastUpdated
        self.version = version
    }

    // invoke this to bump the last updated and version values
    mutating func updateVersion() {
        lastUpdated = NSDate()
        ++version
    }

    public var description:String {
        return "id:\( id ), created:\( dateCreated ), updated:\( lastUpdated ), version: \( version )"
    }

    // convenience func for creating standard 32 character id's
    public static func createModelId() -> String {
        return SAUnique.createModelId()
    }

}

extension SADocumentIdentifier: Equatable { }
public func == (lhs:SADocumentIdentifier, rhs:SADocumentIdentifier) -> Bool {
    return lhs.id == rhs.id &&
        lhs.dateCreated == rhs.dateCreated &&
        lhs.lastUpdated == rhs.lastUpdated &&
        lhs.version == rhs.version
}
