//
//  RiderProfile.swift
//  Cabled
//
//  Created by Theo Koester on 3/26/24.
//

import Foundation

struct RiderProfile: Decodable {
    let rider: Rider
    let statistics: RiderStat
    let trickCount: Int
    let scoredCount: Int
    let attemptedCount: Int
    let cwaRank: Int
    let ageRank: Int
    let divisionRank: Int
    let experienceRank: Int
    let tricks: [String: TrickDetail]

    enum CodingKeys: String, CodingKey {
        case rider, statistics
        case trickCount = "trick_count"
        case scoredCount = "scored_count"
        case attemptedCount = "attempted_count"
        case cwaRank = "cwa_rank"
        case ageRank = "age_rank"
        case divisionRank = "division_rank"
        case experienceRank = "experience_rank"
        case tricks
        
        
        
    }
    
    
}

// Struct for each trick's details
struct TrickDetail: Decodable {
    let stats: StatsDetails
    let scorecard: Scorecard
    let scores: RiderScore

    enum CodingKeys: String, CodingKey {
        case stats
        case scorecard = "highest_scorecard"
        case scores
    }
}
