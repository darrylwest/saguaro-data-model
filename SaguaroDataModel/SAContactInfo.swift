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
public func ==(lhs:SALabeledValue, rhs:SALabeledValue) -> Bool {
    return lhs.label == rhs.label && lhs.value == rhs.value
}

// MARK location

public typealias SALocationDegrees = Double
public protocol SALocationModel: SAMappable, Equatable {
    var latitude:SALocationDegrees { get }
    var longitude:SALocationDegrees { get }
}

public struct SALocation: SALocationModel {
    public let latitude:SALocationDegrees
    public let longitude:SALocationDegrees

    public init(latitude:SALocationDegrees, longitude:SALocationDegrees) {
        self.latitude = latitude
        self.longitude = longitude
    }

    public func toMap() -> [String:AnyObject] {
        let map = [
            "latitude":self.latitude,
            "longitude":self.longitude
        ]

        return map
    }

    public static func fromMap(map:[String:AnyObject]) -> SALocation? {
        guard let latitude = map["latitude"] as? SALocationDegrees,
            let longitude = map["longitude"] as? SALocationDegrees else {
                
                return nil
        }

        return SALocation(latitude: latitude, longitude: longitude)
    }
}

public func ==(lhs:SALocation, rhs:SALocation) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
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
    public private(set) var locations = [ SALocation ]()

    public var status:SADataModelStatus

    public init(doi:SADocumentIdentifier, givenName:String, status:SADataModelStatus? = .Active) {
        self.doi = doi
        self.givenName = givenName;
        self.status = status!
    }

    public mutating func addEmail(email:SALabeledValue) {
        if emails.contains( email ) == false {
            emails.append( email )
        }
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
        if phones.contains( phone ) == false {
            phones.append( phone )
        }
    }

    public mutating func addMailing(mail:SALabeledValue) {
        if mailing.contains( mail ) == false {
            mailing.append( mail )
        }
    }

    public mutating func addLocation(location:SALocation) {
        locations.append( location )
    }

    public func toMap() -> [String:AnyObject] {
        var map = doi.toMap()

        map[ "givenName" ] = givenName
        if let familyName = self.familyName {
            map[ "familyName" ] = familyName
        }

        map[ "emails" ] = self.emails.map { [ $0.label.rawValue : $0.value ] }
        map[ "phones" ] = self.phones.map { [ $0.label.rawValue : $0.value ] }
        map[ "mailing"] = self.mailing.map { [ $0.label.rawValue : $0.value ] }
        map[ "locations" ] = self.locations.map { $0.toMap() }

        map[ "status" ] = self.status.rawValue
        
        return map
    }

    public static func fromMap(map:[String:AnyObject]) -> SAContactInfo? {
        guard let doi = SADocumentIdentifier.fromMap( map ),
            givenName = map["givenName"] as? String,
            rawStatus = map["status"] as? String else {

            return nil
        }

        var info = SAContactInfo(doi:doi, givenName:givenName, status: SADataModelStatus(rawValue: rawStatus))

        if let familyName = map["familyName"] as? String {
            info.familyName = familyName
        }

        if let emails = map[ "emails" ] as? [ [ String:String ] ] {
            for obj in emails {
                if let labeledValue = SALabeledValue( keyValue: obj ) {
                    info.addEmail( labeledValue )
                } else {
                    // log.warn("failed to parse the email object: \( obj )")
                }
            }
        }

        if let phones = map[ "phones" ] as? [ [ String:String ] ] {
            for obj in phones {
                if let labeledValue = SALabeledValue( keyValue: obj ) {
                    info.addPhone( labeledValue )
                } else {
                    // log.warn("failed to parse the phone object: \( obj )")
                }
            }
        }

        if let mailing = map["mailing"] as? [ [ String:String ] ] {
            for obj in mailing {
                if let labeledValue = SALabeledValue( keyValue: obj ) {
                    info.addMailing( labeledValue )
                } else {
                    // log.warn...
                }
            }
        }

        if let locations = map["locations"] as? [ [ String:AnyObject ] ] {
            for obj in locations {
                if let location = SALocation.fromMap( obj ) {
                    info.addLocation( location )
                } else {
                    // print("failed to create location from \( obj )")
                }
            }
        }

        return info
    }
}

