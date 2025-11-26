//
//  Park.swift
//  TheCWA
//
//  Created by Theo Koester on 2/29/24.
//

import Foundation

struct Address: Codable, Hashable {
    var street: String
    var city: String
    var state: String?  // make optional if it might be null
    var zip: String
    var country: String?  // optional
}

struct Park: Codable, Identifiable, Hashable {
    var id: String?
    var name: String
    var abbreviation: String
    var cover_photo: URL?  // adjust type as needed
    var logo: URL?         // adjust type as needed
    var address: Address
    var maintenance: String?  // or whatever type
    var contacts: [Contact]   // you should define a Contact struct matching the JSON
    var cables: [String]?     // adjust type if needed
    var team: String?         // adjust type if needed
    var riders_checked_in: [String]?  // adjust type as needed

    // Add CodingKeys if you need to map between JSON keys and property names
}

struct Contact: Codable, Hashable {
    var phone_number: String
    var name: String
    var position: String
    var email: String

}
