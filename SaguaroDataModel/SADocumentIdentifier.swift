//
//  DocumentIdentifier.swift
//  SaguaroDataModel
//
//  Created by darryl west on 7/23/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import Foundation
import SaguaroJSON

/// define a mappable to enable preparing for JSON stringify
public protocol SAMappable {
    func toMap() -> [String:AnyObject]
}

/// all sa data models should contain a doi
public protocol SADataModelType  {
    var doi:SADocumentIdentifier { get }
}

/// a list of data models
public protocol SADataModelListType {
    var list:[SADataModelType] { get }
}

/// define the identifier type
public protocol SADocumentIdentifierType: Equatable, SAMappable, Comparable {
    var id:String { get }
    var dateCreated:Date { get }
    var lastUpdated:Date { get }
    var version:Int { get }
}

/// Equatable
public func == (lhs: SADocumentIdentifier, rhs: SADocumentIdentifier) -> Bool {
	return lhs.id == rhs.id &&
		lhs.dateCreated == rhs.dateCreated &&
		lhs.lastUpdated == rhs.lastUpdated &&
		lhs.version == rhs.version
}

/// Comparable
public func <(lhs: SADocumentIdentifier, rhs: SADocumentIdentifier) -> Bool {
	return
		lhs.version < rhs.version || (
			lhs.version == rhs.version &&
			lhs.lastUpdated < rhs.lastUpdated
		)
}

public func >(lhs: SADocumentIdentifier, rhs: SADocumentIdentifier) -> Bool {
	return
		lhs.version > rhs.version || (
			lhs.version == rhs.version &&
			lhs.lastUpdated > rhs.lastUpdated
		)
}

public func <=(lhs: SADocumentIdentifier, rhs: SADocumentIdentifier) -> Bool {
	return lhs < rhs || lhs == rhs
}

public func >=(lhs: SADocumentIdentifier, rhs: SADocumentIdentifier) -> Bool {
	return lhs > rhs || lhs == rhs
}

/// concrete implementation of document identifier
public struct SADocumentIdentifier: SADocumentIdentifierType, CustomStringConvertible {
    public let id:String
    public let dateCreated:Date
    public let lastUpdated:Date
    public let version:Int

    /// initializer used for new documents
    public init() {
        id = SADocumentIdentifier.createModelId()
        dateCreated = Date()
        lastUpdated = Date()
        version = 0
    }

    /// initializer for documents that currently exist
    public init(id:String, dateCreated:Date? = Date(), lastUpdated:Date? = Date(), version:Int? = 0) {
        self.id = id
        self.dateCreated = dateCreated!
        self.lastUpdated = lastUpdated!
        self.version = version!
    }

    /// invoke this to bump the last updated and version values
    public func updateVersion() -> SADocumentIdentifier {
        let updated = Date()
        let vers = self.version + 1
        
        return SADocumentIdentifier( id:self.id, dateCreated:self.dateCreated, lastUpdated: updated, version: vers )
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
        ] as [String : Any]

        return map as [String : AnyObject]
    }
}

public extension SADocumentIdentifierType {
    static func fromMap(_ map: [String:AnyObject]) -> SADocumentIdentifier? {
        let parser = JNParser()
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


