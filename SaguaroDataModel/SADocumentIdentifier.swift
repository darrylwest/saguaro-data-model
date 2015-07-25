//
//  DocumentIdentifier.swift
//  SaguaroDataModel
//
//  Created by darryl west on 7/23/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import Foundation

/// define a mappable to enable preparing for JSON stringify
public protocol SAMappable {
    func toMap() -> [String:AnyObject]
}

/// all sa data models should contain a doi
public protocol SADataModelType {
    var doi:SADocumentIdentifier { get }
}

/// a list of data models
public protocol SADataModelListType {
    var list:[SADataModelType] { get }
}

/// define the identifier type
public protocol SADocumentIdentifierType: Equatable, SAMappable {
    var id:String { get }
    var dateCreated:NSDate { get }
    var lastUpdated:NSDate { get }
    var version:Int { get }
}

/// equals operator
public func == (lhs:SADocumentIdentifier, rhs:SADocumentIdentifier) -> Bool {
    return lhs.id == rhs.id &&
        lhs.dateCreated == rhs.dateCreated &&
        lhs.lastUpdated == rhs.lastUpdated &&
        lhs.version == rhs.version
}

/// concrete implementation of document identifier
public struct SADocumentIdentifier: SADocumentIdentifierType, CustomStringConvertible {
    public let id:String
    public let dateCreated:NSDate
    public private(set) var lastUpdated:NSDate
    public private(set) var version:Int

    /// initializer used for new documents
    public init() {
        id = SADocumentIdentifier.createModelId()
        dateCreated = NSDate()
        lastUpdated = NSDate()
        version = 0
    }

    /// initializer for documents that currently exist
    public init(id:String, dateCreated:NSDate, lastUpdated:NSDate, version:Int) {
        self.id = id
        self.dateCreated = dateCreated
        self.lastUpdated = lastUpdated
        self.version = version
    }

    /// invoke this to bump the last updated and version values
    public mutating func updateVersion() {
        lastUpdated = NSDate()
        ++version
    }

    public var description:String {
        return "id:\( id ), created:\( dateCreated ), updated:\( lastUpdated ), version: \( version )"
    }

    /// convenience func for creating standard 32 character id's
    public static func createModelId() -> String {
        return SAUnique.createModelId()
    }
}

public extension SADocumentIdentifierType {
    public func toMap() -> [String:AnyObject] {
        let map = [
            "id": self.id,
            "dateCreated": self.dateCreated,
            "lastUpdated": self.lastUpdated,
            "version": self.version
        ]

        return map
    }
}

/*
public extension SADocumentIdentifierType {
    static func fromMap(map: [String:AnyObject]) -> SADocumentIdentifier? {
        let parser = JSONParser.parser
        guard let id = map[ "id" ] as? String,
            let dateCreated = parser.parseDate( map[ "dateCreated" ] ),
            let lastUpdated = parser.parseDate( map[ "lastUpdated" ] ),
            let version = map[ "version" ] as? Int else {

                return nil
        }

        let doi = SADocumentIdentifier(id: id, dateCreated: dateCreated, lastUpdated: lastUpdated, version: version)

        return doi
    }
}
*/

