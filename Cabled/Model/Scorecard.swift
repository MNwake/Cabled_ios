//
//  Scorecard.swift
//  TheCWA
//
//  Created by Theo Koester on 3/1/24.
//

import Foundation

struct Scorecard: Codable, Identifiable, Hashable {
    var id: String?
    var date: Date
    var section: String = "" // non-optional
    var division: Double = 0
    var execution: Double = 0
    var creativity: Double = 0
    var difficulty: Double = 0
    var score: Double = 0
    var landed: Bool = false
    var approach: String = "" // corrected
    var trickType: String = ""
    var spin: String = ""
    var spinDirection: String = ""
    var modifiers: [String] = []
    var park: String?
    var rider: String?
    var session: UUID?
    
    
    var riderObj: Rider?
    var judge: String?
    
    
    private enum CodingKeys: String, CodingKey {
            case id, date, section, division, execution, creativity, difficulty, score, landed, approach, spin, modifiers, park, rider, session, riderObj, judge

            case trickType = "trick_type"
            case spinDirection = "spin_direction"
        }
    
    
    // Custom initializer
    init(date: Date = Date(), section: String = "", division: Double = 0, execution: Double = 0, creativity: Double = 0, difficulty: Double = 0, score: Double = 0, landed: Bool = false, approach: String = "", trickType: String = "", spin: String = "", spinDirection: String = "", modifiers: [String] = [], park: String? = nil, rider: String? = nil, session: UUID? = nil, riderObj: Rider? = nil, judge: String? = nil) {
        self.id = nil
        self.date = date
        self.section = section
        self.division = division
        self.execution = execution
        self.creativity = creativity
        self.difficulty = difficulty
        self.score = score
        self.landed = landed
        self.approach = approach
        self.trickType = trickType
        self.spin = spin
        self.spinDirection = spinDirection
        self.modifiers = modifiers
        self.park = park
        self.rider = rider
        self.session = session  // Correctly assigning the parameter to the property
        self.riderObj = riderObj
        self.judge = judge
    }
    
    var trickName: String {
        print("Trick Name")
        
        // Ignore spin and spin direction if spin amount is "0"
        if spin == "0" {
            print("Spin is 0, ignoring spin and spin direction")
            return "\(approach.capitalized) \(trickType.capitalized)"
        }

        // Handle different sections
        if section == "Kicker" {
            print("Section == kicker")
            if trickType == "spin" {
                print("Trick type == spin")
                // Exclude "spin" from the name for spin tricks
                return "\(approach.capitalized) \(spinDirection.capitalized) \(spin)"
            } else {
                print("not spin")
                // Include trick type if it's not "spin"
                let components = [approach.capitalized, trickType.capitalized, spinDirection.capitalized, spin]
                return components.filter { !$0.isEmpty }.joined(separator: " ")
            }
        } else if section == "Rail" {
            print("section == rail")
            // For rails, format the spin and spin direction properly
            let spinDirections = spinDirection.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            let spins = spin.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }

            var components = [approach.capitalized, trickType.capitalized]

            if spinDirections.count == 2 && spins.count == 2 {
                print("spin dir has 2 values")
                components.append(contentsOf: [spinDirections[0].capitalized, spins[0], "On,", spinDirections[1].capitalized, spins[1], "Off"])
            } else {
                print("doesn't have 2 values")
                print(spinDirections)
                print(spins)
                // Fallback to default formatting if the data doesn't match the expected pattern
                components.append(contentsOf: [spinDirection.capitalized, spin])
            }

            return components.filter { !$0.isEmpty }.joined(separator: " ")
        } else {
            // Fallback for other sections
            let components = [approach.capitalized, trickType.capitalized, spinDirection.capitalized, spin]
            return components.filter { !$0.isEmpty }.joined(separator: " ")
        }
    }


}
struct Scorecards: Decodable {
    var data: [Scorecard]
    var cursor: String?  // Make cursor optional

    enum CodingKeys: String, CodingKey {
        case data
        case cursor
    }
}
