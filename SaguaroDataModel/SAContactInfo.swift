//
//  SAContactInfo.swift
//  SaguaroDataModel
//
//  Created by darryl west on 7/23/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import Foundation

public enum SAInfoType: String {
    case Home = "home"
    case Work = "work"
    case Primary = "primary"
    case Secondary = "secondary"
    case Mobile = "mobile"
    case Other = "other"
}

public struct SALabeledValue: SAMappable {
    public let label:SAInfoType
    public let value:String

    public init(label: SAInfoType, value:String) {
        self.label = label
        self.value = value
    }

    /// create from keyValue pair as saved in json database
    public init?(keyValue: [String:String]) {
        guard let value = keyValue.values.first else {
            return nil
        }

        self.value = value

        if let key = keyValue.keys.first, let lbl = SAInfoType(rawValue: key) {
            self.label = lbl
        } else {
            self.label = .Other
        }
    }

    public func toMap() -> [String : AnyObject] {
        return [ label.rawValue : value ]
    }
}

extension SALabeledValue: Equatable { }
public func == (lhs:SALabeledValue, rhs:SALabeledValue) -> Bool {
    return lhs.label == rhs.label && lhs.value == rhs.value
}

public struct SAContactInfo: SADataModelType, SAMappable {
    public let doi:SADocumentIdentifier
    public var givenName:String
    public var familyName:String?

    public var fullName:String {
        if let lastName = self.familyName {
            return "\( givenName ) \( lastName )"
        } else {
            return givenName
        }
    }

    public private(set) var emails = [ SALabeledValue ]()
    public private(set) var phones = [ SALabeledValue ]()
    public private(set) var mailing = [ SALabeledValue ]()

    public private(set) var locations = [ String ]()

    public var status:SADataModelStatus

    public init(doi:SADocumentIdentifier, givenName:String, status:SADataModelStatus? = .Active) {
        self.doi = doi
        self.givenName = givenName;
        self.status = status!
    }

    public mutating func addEmail(email:SALabeledValue) {
        // validate?

        emails.append( email )
    }

    public mutating func removeEmail(email:SALabeledValue) -> SALabeledValue? {
        for (idx, obj) in emails.enumerate() {
            if obj == email {
                emails.removeAtIndex( idx )
                return obj
            }
        }

        return nil
    }

    public func findEmail(email:SALabeledValue) -> SALabeledValue? {
        for obj in emails {
            if obj == email {
                return obj
            }
        }

        return nil
    }

    public mutating func addPhone(phone:SALabeledValue) {
        phones.append( phone )
    }

    public func toMap() -> [String:AnyObject] {
        var map = doi.toMap()

        map[ "givenName" ] = givenName
        if let familyName = self.familyName {
            map[ "familyName" ] = familyName
        }

        var emails = [ [ String: String ]]()
        for labeledValue in self.emails {
            let obj = [ labeledValue.label.rawValue : labeledValue.value ]
            emails.append( obj )
        }
        map[ "emails" ] = emails

        var phones = [ [ String:String ] ]()
        for labeledValue in self.phones {
            let obj = [ labeledValue.label.rawValue : labeledValue.value ]
            phones.append( obj )
        }
        
        map[ "phones" ] = phones
        map[ "status" ] = self.status.rawValue
        
        return map
    }
}

