//
//  RandomFixtureData.swift
//  SaguaroDataModel
//
//  Created by darryl west on 7/24/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import Foundation

struct RandomFixtureData {
    // TODO: create a random fixture data framework/module
    let firstNames:[String] = [ "John", "Adam", "Sam", "Henry", "James", "Penny", "Noah", "Luca",
        "David", "Leon", "Leandro", "Nico", "Levin", "Julian", "Tim", "Ben", "Gian", "Jonas", "Lukas",
        "Dario", "Jan", "Elias", "Liam", "Lionel", "Samuel", "Fabio", "Nevio", "Matteo", "Nils",
        "Joel", "Livio", "Fabian", "Finn", "Laurin", "Robin", "Simon", "Elia", "Gabriel", "Alexander",
        "Nino", "Luis", "Andrin", "Benjamin", "Louis", "Diego", "Lars", "Rafael", "Aaron", "Janis",
        "Loris", "Colin", "Nicolas", "Lian", "Leo", "Manuel", "Noel", "Mia", "Alina", "Laura", "Julia",
        "Anna", "Emma", "Leonie", "Lena", "Lara", "Elin", "Elena", "Lea", "Sara", "Nina", "Chiara", "Sophia",
        "Livia", "Lia", "Lina", "Giulia", "Jana", "Sophie", "Elina", "Selina", "Sofia", "Luana", "Nora",
        "Alessia", "Emilia", "Melina", "Lisa", "Amélie", "Lorena", "Noemi", "Fiona", "Valentina", "Ronja",
        "Luisa", "Sarah", "Zoe", "Mila", "Olivia", "Emily", "Leana", "Ladina", "Mara", "Ella", "Hanna",
        "Amelie", "Elisa" ]

    let lastNames:[String] = [ "Smith", "Jones", "East", "South", "Builderberg", "Abernathy", "Bates", "Cats", "Dersharwitz" ]
    let domains:[String] = [ "com", "org", "net", "co.uk", "us", "ca", "biz", "info", "name", "io", "tv", "me" ]
    let companies:[String] = [ "IBM", "Apple", "Oracle", "Coca Cola", "Pepsi", "Best Buy", "Microsoft", "Benjamin Parker", "Google", "Amazon", "Wiki", "Photo Shape", "Molly Stone" ]

    func stripWhiteSpace(_ str:String) -> String {
        let chars = str.characters.filter { return $0 != " " }

        return String( chars )
    }

    var firstName: String {
        return firstNames[ Int( arc4random_uniform( UInt32( firstNames.count )) ) ]
    }

    var lastName: String {
        return lastNames[ Int( arc4random_uniform( UInt32( lastNames.count )) ) ]
    }

    var fullName: String {
        return "\( firstName ) \( lastName )"
    }

    var companyName: String {
        return companies[ Int( arc4random_uniform( UInt32( companies.count )) ) ]
    }

    var domain: String {
        return domains[ Int( arc4random_uniform( UInt32( domains.count )) ) ]
    }

    var url: String {
        return "http://\( stripWhiteSpace( companyName.lowercased() )).\( domain )"
    }

    var email: String {
        return "\( firstName.lowercased() )@\( stripWhiteSpace( companyName.lowercased() )).\( domain )"
    }

    var username: String {
        return email
    }

    var phone: String {
        let areaCode = arc4random_uniform( UInt32( 900 ) + 100 )
        let prefix = arc4random_uniform( UInt32( 900 ) + 100 )
        let number = arc4random_uniform( UInt32( 9000 ) + 1000 )

        return "\( areaCode )-\( prefix )-\( number )"
    }
}
