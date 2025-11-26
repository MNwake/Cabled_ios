//
//  MockData.swift
//  TheCWA_admin
//
//  Created by Theo Koester on 3/12/24.
//

import Foundation

struct MockData {
    
    static let sampleRider = Rider(
        email: "",
        first_name: "",
        last_name: "",
        date_of_birth: Calendar.current.date(from: DateComponents(year: 1988, month: 6, day: 15))!,
        gender: "",
        date_created: Date(),
        profile_image: URL(string: "https://via.placeholder.com/150")!,
        stance: "",
        year_started: 2024,
        division: 0,
        home_park: "",
        statistics: "",
        score: 0,
        is_registered: false)
    
    static let sampleRiderStat = RiderStat(
        id: "65fb36bbc940b677f9ae3e36",
        rider: "65fb2fb9c940b677f9ae3e32",
        year: 2024,
        division: 45.55,
        overall: OverallStats(
            section: ParkSection(
                airTrick: StatsDetails(count: 99, mean: 99.99, std: nil, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
                kicker: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
                rail: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil)
            ),
            score: RiderScore(
                division: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
                execution: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
                difficulty: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
                creativity: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil)
            )
        ),
        
        top_10: Top10Stats(
            section: ParkSection(
                airTrick: StatsDetails(count: 99, mean: 99.99, std: nil, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
                kicker: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
                rail: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil)
            ),
            score: RiderScore(
                division: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
                execution: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
                difficulty: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
                creativity: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil)
            )
        ),
        cwa: CWAStats(
            section: ParkSection(
                airTrick: StatsDetails(count: 99, mean: 99.99, std: nil, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
                kicker: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
                rail: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil)
            ),
            score: RiderScore(
                division: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
                execution: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
                difficulty: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
                creativity: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil)
            )
        ),
        attempted: AttemptedStats(
            section: ParkSection(
                airTrick: StatsDetails(count: 99, mean: 99.99, std: nil, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
                kicker: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
                rail: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil)
            ),
            score: RiderScore(
                division: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
                execution: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
                difficulty: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
                creativity: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil)
            )
        ),
        best_trick: BestTrickStats(
            section: ParkSection(
                airTrick: StatsDetails(count: 99, mean: 99.99, std: nil, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
                kicker: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
                rail: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil)
            ),
            score: RiderScore(
                division: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
                execution: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
                difficulty: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
                creativity: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil)
            )
        ),
        kicker_stats: KickerStats(
            division: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
            creativity: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
            execution: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
            difficulty: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil)
        ),
        rail_stats: RailStats(
            division: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
            creativity: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
            execution: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
            difficulty: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil)
        ),
        air_trick_stats: AirTrickStats(
            division: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
            creativity: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
            execution: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil),
            difficulty: StatsDetails(count: 99, mean: 99.99, std: 99.99, min: 99.99, percentile25: 99.99, percentile50: 99.99, percentile75: 99.99, max: 99.99, scorecard: nil)
        )
        
    )
    static let sampleRiderProfile = RiderProfile(
        rider: sampleRider,
        statistics: sampleRiderStat,
        trickCount: 0,
        scoredCount: 0,
        attemptedCount: 0,
        cwaRank: 0, // Example rank
        ageRank: 0, // Example rank
        divisionRank: 0, // Example rank
        experienceRank: 0, // Example rank
        
        tricks: [:]
    )
    static let sampleTrickDetail = TrickDetail(
            stats: StatsDetails(
                count: 10,
                mean: 75.0,
                std: 5.0,
                min: 70.0,
                percentile25: 72.0,
                percentile50: 75.0,
                percentile75: 78.0,
                max: 80.0,
                scorecard: sampleScorecard
            ),
            scorecard: sampleScorecard,
            scores: RiderScore(
                division: StatsDetails(count: 10,
                                       mean: 75.0,
                                       std: 5.0,
                                       min: 70.0,
                                       percentile25: 72.0,
                                       percentile50: 75.0,
                                       percentile75: 78.0,
                                       max: 80.0,
                                       scorecard: sampleScorecard),
                execution: StatsDetails(count: 10,
                                        mean: 75.0,
                                        std: 5.0,
                                        min: 70.0,
                                        percentile25: 72.0,
                                        percentile50: 75.0,
                                        percentile75: 78.0,
                                        max: 80.0,
                                        scorecard: sampleScorecard),
                difficulty: StatsDetails(count: 10,
                                         mean: 75.0,
                                         std: 5.0,
                                         min: 70.0,
                                         percentile25: 72.0,
                                         percentile50: 75.0,
                                         percentile75: 78.0,
                                         max: 80.0,
                                         scorecard: sampleScorecard),
                creativity: StatsDetails(count: 10,
                                         mean: 75.0,
                                         std: 5.0,
                                         min: 70.0,
                                         percentile25: 72.0,
                                         percentile50: 75.0,
                                         percentile75: 78.0,
                                         max: 80.0,
                                         scorecard: sampleScorecard)
            )
        )

        static let sampleScorecard = Scorecard(
            date: Date(),
            section: "Air Trick",
            division: 24.65,
            execution: 72.11,
            creativity: 73.23,
            difficulty: 33.87,
            score: 59.74,
            landed: true,
            approach: "Switch Toeside",
            trickType: "raley",
            spin: "360",
            spinDirection: "backside",
            modifiers: ["Boosted", "Wrapped"],
            park: "001",
            rider: "65ffb25d169e5f4b67df65b8",
            session: UUID(),
            riderObj: sampleRider,
            judge: "Judge 1"
        )
}

