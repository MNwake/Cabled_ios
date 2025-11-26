//
//  Rider.swift
//  TheCWA
//
//  Created by Theo Koester on 2/29/24.
//

import UIKit

import SwiftData
import SwiftUI


struct Rider: Codable, Identifiable, Equatable, Hashable {
    var id: String?
    var email: String
    var first_name: String
    var last_name: String
    var date_of_birth: Date
    var gender: String
    var date_created: Date
    var profile_image: URL
    var stance: String
    var year_started: Int
    var division: Double? = 0
    var home_park: String? = ""
    var statistics: String? = ""
    var waiver_date: Date?
    var waiver_url: URL?
    
    var score: Double? = 0
    var is_registered: Bool? = false
    
    
    init(email: String = "", first_name: String = "", last_name: String = "", date_of_birth: Date? = nil, gender: String = "", date_created: Date = Date(), profile_image: URL = URL(string: "https://firebasestorage.googleapis.com/v0/b/the-cwa.appspot.com/o/default-avatar.png?alt=media&token=c069e515-fb20-48eb-847b-b3ef48f58c7e")!, stance: String = "", year_started: Int = 0, division: Double? = nil, home_park: String = "", statistics: String? = nil, score: Double? = nil, is_registered: Bool? = false, waiver_date: Date? = nil) {
        self.id = nil
        self.email = email
        self.first_name = first_name
        self.last_name = last_name
        self.date_of_birth = date_of_birth ?? Date() // Or some other default date
        self.gender = gender
        self.date_created = date_created
        self.profile_image = profile_image // This should be `profile_image`, not `profile_view`
        self.stance = stance
        self.year_started = year_started
        self.division = division
        self.home_park = home_park
        self.statistics = statistics
        
        self.score = score
        self.is_registered = is_registered
    }
    
    var age: Int {
            let calendar = Calendar.current
            let now = Date()
            let ageComponents = calendar.dateComponents([.year], from: date_of_birth, to: now)
            return ageComponents.year ?? 0
        }
    
    var experienceLabel: String {
            let currentYear = Calendar.current.component(.year, from: Date())
            let yearsExperience = currentYear - year_started
            return get_experience_label(years_experience: yearsExperience)
        }
    
    func teamName(from parks: [Park]) -> String? {
            guard let homeParkID = self.home_park, !homeParkID.isEmpty else {
                return nil
            }
            return parks.first { $0.id == homeParkID }?.abbreviation
        }
    
    var birthYear: Int {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self.date_of_birth)
        return year
    }
    
    var fullName: String {
        return "\(first_name) \(last_name)"
    }
    
    var ageGroup: String {
        // Assuming calculateAgeGroup function exists
        return calculateAgeGroup(dob: self.date_of_birth)
    }
    
    var divisionLabel: String {
        // Assuming calculateDivision function exists
        return calculateDivision(score: Int(division ?? 0.0))
    }
    var displayName: String {
            let firstNameInitial = first_name.first.map { String($0) + ". " } ?? ""
            return "\(firstNameInitial)\(last_name)"
        }
    
    static func == (lhs: Rider, rhs: Rider) -> Bool {
            lhs.id == rhs.id
        }
    
    var yearsRiding: Int {
            let currentYear = Calendar.current.component(.year, from: Date())
            return currentYear - year_started
        }
    
    
}

struct Riders: Codable {
    let data: [Rider]
}




