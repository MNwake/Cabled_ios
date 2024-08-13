//
//  RiderStat.swift
//  TheCWA
//
//  Created by Theo Koester on 3/1/24.
//

import Foundation

struct RiderStat: Decodable {
    let id: String
    let rider: String
    let year: Int
    let division: Double?
    let overall: OverallStats
    let top_10: Top10Stats
    let cwa: CWAStats
    let attempted: AttemptedStats
    let best_trick: BestTrickStats
    let kicker_stats: KickerStats
    let rail_stats: RailStats
    let air_trick_stats: AirTrickStats
    
    
    var top10Score: Double {
        calculateScore(for: top_10)
    }
    
    var overallScore: Double {
        calculateScore(for: overall)
    }
    
    var cwaScore: Double {
        calculateScore(for: cwa)
    }
    
    var attemptedScore: Double {
        calculateScore(for: attempted)
    }
    
    var bestTrickScore: Double {
        calculateScore(for: best_trick)
    }
    var bestKickerScore: Double {
        return self.best_trick.section.kicker?.mean ?? 0
    }
    var bestAirTrickScore: Double {
        return self.best_trick.section.kicker?.mean ?? 0
        
    }
    var bestRailScore: Double {
        return self.best_trick.section.kicker?.mean ?? 0
        
    }
    
    var divisionLabel: String {
        // Assuming calculateDivision function exists
        return calculateDivision(score: Int(cwa.score.division.mean ?? 0.0))
    }
    
    // Add similar properties for CWA, Attempted, and BestTrick
    
    private func calculateScore(for stat: StatsType) -> Double {
        let meanValues = [
            stat.section.airTrick?.mean ?? 0,
            stat.section.kicker?.mean ?? 0,
            stat.section.rail?.mean ?? 0,
            stat.score.difficulty.mean ?? 0,
            stat.score.execution.mean ?? 0,
            stat.score.creativity.mean ?? 0,
        ].compactMap { $0 }  // Remove nil values, if any
        
        guard !meanValues.isEmpty else { return 0 }
        let totalMean = meanValues.reduce(0, +)
        
        // Multiply by 10, round, and then divide by 10 to get one decimal place
        return (totalMean * 10).rounded() / 10
    }
}
struct KickerStats: Decodable {
    let division: StatsDetails
    let creativity: StatsDetails
    let execution: StatsDetails
    let difficulty: StatsDetails
}

struct RailStats: Decodable {
    let division: StatsDetails
    let creativity: StatsDetails
    let execution: StatsDetails
    let difficulty: StatsDetails
}

struct AirTrickStats: Decodable {
    let division: StatsDetails
    let creativity: StatsDetails
    let execution: StatsDetails
    let difficulty: StatsDetails
}

struct RiderStats: Decodable {
    let data: [RiderStat]
    let cursor: String
}

struct OverallStats: Decodable {
    let section: ParkSection
    let score: RiderScore


        
}

struct Top10Stats: Decodable {
    let section: ParkSection
    let score: RiderScore

    
}

struct CWAStats: Decodable {
    let section: ParkSection
    let score: RiderScore

}

struct AttemptedStats: Decodable {
    let section: ParkSection
    let score: RiderScore

    
}

struct BestTrickStats: Decodable {
    let section: ParkSection
    let score: RiderScore


}

struct ParkSection: Decodable {
    let airTrick: StatsDetails?
    let kicker: StatsDetails?
    let rail: StatsDetails?
 
    enum CodingKeys: String, CodingKey {
        case airTrick = "Air Trick"
        case kicker = "Kicker"
        case rail = "Rail"
    }
}

struct StatsDetails: Decodable {
    let count: Int?
    let mean: Double?
    let std: Double?
    let min: Double?
    let percentile25: Double?
    let percentile50: Double?
    let percentile75: Double?
    let max: Double?
    let scorecard: Scorecard?

    enum CodingKeys: String, CodingKey {
            case count, mean, std, min, max
            case percentile25 = "25%"
            case percentile50 = "50%"
            case percentile75 = "75%"
            case scorecard
        }
}

struct RiderScore: Decodable {
    let division: StatsDetails
    let execution: StatsDetails
    let difficulty: StatsDetails
    let creativity: StatsDetails
}


protocol StatsType {
    var section: ParkSection { get }
    var score: RiderScore { get }
}

extension OverallStats: StatsType { }
extension Top10Stats: StatsType { }
extension CWAStats: StatsType { }
extension AttemptedStats: StatsType { }
extension BestTrickStats: StatsType { }

// Define similar structs for Top10Stats, CWAStats, AttemptedStats, and BestTrickStats
