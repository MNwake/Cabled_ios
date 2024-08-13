//
//  RiderRankingsViewModel.swift
//  TheCWA
//
//  Created by Theo Koester on 2/29/24.
//

import SwiftUI
import Combine


final class RiderRankingsViewModel: ObservableObject, WebSocketObserver {
    @Published var isShowingFilterSheet: Bool = false
    @Published var selectedDivision: String = "All"
    @Published var selectedCategory: String = "CWA"
    @Published var selectedAgeGroup: String = "All"
    @Published var selectedGender: String = "All"
    @Published var selectedStance: String = "All"
    
    @Published var rankingList: [Rider] = []
    @Published var riders: [Rider] = []
    @Published var riderStats: [RiderStat] = []
    
    @Published var isLoading = false
    @Published var alertItem: AlertItem?
    
    private var networkManager = NetworkManager.shared
    
    private var cancellables = Set<AnyCancellable>()
    
    
    private var websocketHandler: WebSocketHandler
    
    init() {
        self.websocketHandler = WebSocketHandler.shared
        setupWebSocketListener()
        setupPublishers()
    }
    
    deinit {
        WebSocketHandler.shared.removeObserver(self)
    }
    
    private func setupWebSocketListener() {
        websocketHandler.addObserver(self)
    }
    
    func didReceiveWebSocketMessage(_ message: WebSocketMessage) {
        print("Received WebSocket message in Rankings: \(message.type)")
        DispatchQueue.main.async {
            switch message.type {
            case "stats":
                self.handleStatsUpdate(from: message)
            default:
                break
            }
        }
    }
    
    private func handleStatsUpdate(from message: WebSocketMessage) {
        guard let jsonData = message.data?.data(using: .utf8) else { return }
//        print("JSON Data String: \(String(data: jsonData, encoding: .utf8) ?? "Invalid Data")")
        do {
            let updatedStats = try JSONDecoder().decode(RiderStat.self, from: jsonData)
            if let index = self.riderStats.firstIndex(where: { $0.rider == updatedStats.rider }) {
                DispatchQueue.main.async {  // Ensure UI updates happen on the main thread
                    self.riderStats[index] = updatedStats
                    self.createRankingList()
                    
                }
            } else {
                DispatchQueue.main.async {  // Append new stats and update UI on the main thread
                    self.riderStats.append(updatedStats)
                    self.createRankingList()
                    
                }
            }
        } catch DecodingError.dataCorrupted(let context) {
            print("Data corrupted: \(context)")
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Key '\(key)' not found: \(context.debugDescription)")
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type '\(type)' mismatch: \(context.debugDescription) \(String(describing: context.underlyingError)) \(context.codingPath)")
        } catch DecodingError.valueNotFound(let type, let context) {
            print("Value '\(type)' not found: \(context.debugDescription)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    

    private func setupPublishers() {
        $selectedDivision
            .merge(with: $selectedCategory, $selectedAgeGroup, $selectedGender, $selectedStance)
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.createRankingList()
                }
            }
            .store(in: &cancellables)
    }
    
    func getRiderData() {
        if self.riders.isEmpty || self.riderStats.isEmpty {
            self.isLoading = true
        }
        
        Task {
            do {
                let fetchedRiders = try await networkManager.fetchRiders()
                let fetchedRiderStats = try await networkManager.fetchRiderStats()
                
                DispatchQueue.main.async {
                    self.riders = fetchedRiders
                    self.riderStats = fetchedRiderStats
                    self.isLoading = false
                    self.createRankingList()
                }
            } catch {
                print("Error fetching data: \(error)")
                DispatchQueue.main.async {
//                    self.alertItem = AlertContext.alert(for: .unableToComplete)
                    self.isLoading = false
                }
            }
        }
    }
    
    //
    func createRankingList() {
        guard !riders.isEmpty && !riderStats.isEmpty else {
            print("Data not available for creating ranking list")
            return
        }
        print("Creating ranking list")
        print("RiderStats Count: \(riderStats.count), Riders Count: \(riders.count)")
        // Start with an empty list
        rankingList = []
        
        // Iterate over riderStats
        for stat in riderStats {
            // Find the corresponding rider and update stats
            if let index = riders.firstIndex(where: { $0.id == stat.rider }) {

                // Check if the rider matches the filters
                let rider = riders[index]
                
                if stat.divisionLabel == selectedDivision || selectedDivision == "All",
                   rider.ageGroup == selectedAgeGroup || selectedAgeGroup == "All",
                   rider.gender == selectedGender || selectedGender == "All",
                   rider.stance == selectedStance || selectedStance == "All" {
                    // Set the score based on the selected category
                    let calculatedScore = scoreForRider(stat: stat, category: selectedCategory)
                    riders[index].score = calculatedScore
                    
                    rankingList.append(riders[index])
                }
            }
        }
        
        // Sort the rankingList based on the score
        sortRankingListBySelectedCategory()
    }
    
    private func scoreForRider(stat: RiderStat, category: String) -> Double {
        print("Calculating Score for Category: \(category)")
        switch category {
        case "Best 10":
            return stat.top10Score
        case "Overall":
            return stat.overallScore
        case "CWA":
            return stat.cwaScore
        case "Attempted":
            return stat.attemptedScore
        case "Best Trick":
            return stat.bestTrickScore
        default:
            return 0
        }
    }
    
    private func sortRankingListBySelectedCategory() {
        print("Sorting Ranking List")
        rankingList.sort { ($0.score ?? 0) > ($1.score ?? 0) }
        
    }
    
}

func prettyPrint(_ object: Any, indent: Int = 0) {
    let mirror = Mirror(reflecting: object)
    let indentString = String(repeating: "  ", count: indent)

    if mirror.children.isEmpty {
        print("\(indentString)\(object)")
    } else {
        print("\(indentString)\(mirror.subjectType) {")
        for child in mirror.children {
            if let label = child.label {
                print("\(indentString)  \(label): ", terminator: "")
                prettyPrint(child.value, indent: indent + 1)
            } else {
                prettyPrint(child.value, indent: indent + 1)
            }
        }
        print("\(indentString)}")
    }
}
