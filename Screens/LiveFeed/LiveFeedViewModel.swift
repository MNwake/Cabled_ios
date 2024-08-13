//
//  LiveFeedViewModel.swift
//  TheCWA
//
//  Created by Theo Koester on 3/1/24.
//

import SwiftUI
import Combine

final class LiveFeedViewModel: ObservableObject, WebSocketObserver {
    private var networkManager = NetworkManager.shared
    var websocketHandler: WebSocketHandler
    
    @Published var showRiderProfile = false
    @Published var isRidersPanelExpanded = false {
        didSet {
            if isRidersPanelExpanded {
                selectRiderAtScrollPosition()
            }
            liveFeed = updateFilteredLiveFeed()
        }
    }
    @Published var scrollPosition: Int? = 0
    
    @Published var carriers: [ContestCarrier] = [] {
        didSet {
            fetchScorecardsForCarriers()
        }
    }
    @Published var parks: [Park] = []
    @Published var scorecards: [Scorecard] = [] {
        didSet {
            liveFeed = updateFilteredLiveFeed()
        }
    }
    
    @Published var selectedRider: Rider? {
        didSet {
            liveFeed = updateFilteredLiveFeed()
        }
    }
    @Published var riders: [Rider] = []
    @Published var liveFeed: [Scorecard] = []
    
    @Published var isLoading = false
    @Published var alertItem: AlertItem?
    @Published var cursor: String?
    
    
    
    init() {
        self.websocketHandler = WebSocketHandler.shared
        websocketHandler.addObserver(self)
        
    }
    
    deinit {
        WebSocketHandler.shared.removeObserver(self)
    }
    
    func selectRider(forIndex index: Int) {
        guard index >= 0 && index < carriers.count else {
            selectedRider = nil
            self.liveFeed = self.updateFilteredLiveFeed()
            
            return
        }
        let carrier = carriers[index]
        
        if let riderID = carrier.rider_id {
            selectedRider = riders.first { $0.id == riderID }
            self.liveFeed = self.updateFilteredLiveFeed()
        } else {
            // Set selectedRider to nil if carrier.rider_id is nil
            selectedRider = nil
            self.liveFeed = self.updateFilteredLiveFeed()
        }
        
    }
    
    func didReceiveWebSocketMessage(_ message: WebSocketMessage) {
        print("recieved message \(message.type)")
        DispatchQueue.main.async {
            switch message.type {
            case "scorecard":
                self.handleScorecard(from: message)
                
            case "carrier":
                self.handleCarrier(from: message)
                
            default:
                break
            }
        }
    }
    
    func getLiveFeedData() {
        if scorecards.isEmpty || riders.isEmpty {
            DispatchQueue.main.async {
                self.isLoading = true
            }
        }
        print("get live feed data")
        Task {
            do {
                let fetchedRiders = try await NetworkManager.shared.fetchRiders()
                let fetchedCarriers = try await NetworkManager.shared.fetchContestCarriers()
                let fetchedParks = try await NetworkManager.shared.fetchParks()
                let fetchedScorecards = try await NetworkManager.shared.fetchScorecards()
                
                DispatchQueue.main.async {
                    self.riders = fetchedRiders
                    self.carriers = fetchedCarriers
                    self.parks = fetchedParks
                    self.handleNewScorecards(fetchedScorecards)
//                    self.liveFeed = self.updateFilteredLiveFeed()
                    self.isLoading = false
                }
            } catch let error as RequestError {
                DispatchQueue.main.async {
                    print("Throwing request error")
                    self.alertItem = AlertContext.alert(for: error)
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    print("cathing second error")
                    self.alertItem = AlertContext.alert(for: .unableToComplete)
                    self.isLoading = false
                }
            }
        }
    }
    
    private func handleScorecard(from message: WebSocketMessage) {
        guard let jsonData = message.data?.data(using: .utf8) else { return }
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMddTHHmmss)
            var newScorecard = try decoder.decode(Scorecard.self, from: jsonData)

            if let rider = self.riders.first(where: { $0.id == newScorecard.rider }) {
                newScorecard.riderObj = rider
            }

            print("Before \(self.scorecards.count)")
            
            if let newScorecardID = newScorecard.id {
                print("Checking for newScorecard ID: \(newScorecardID) in existing scorecards")

                if !self.scorecards.contains(where: { $0.id == newScorecardID }) {
                    DispatchQueue.main.async {
                        self.scorecards.append(newScorecard)
                        print("After appending: \(self.scorecards.count)")
                        self.liveFeed = self.updateFilteredLiveFeed()
                    }
                } else {
                    print("Duplicate scorecard ID detected: \(newScorecardID)")
                }
            } else {
                print("Received scorecard with no ID")
            }
        } catch {
            print("Decoding error: \(error)")
        }
    }
    
    private func handleCarrier(from message: WebSocketMessage) {
        guard let jsonData = message.data?.data(using: .utf8) else { return }
        do {
            let updatedCarrier = try JSONDecoder().decode(ContestCarrier.self, from: jsonData)
            if let index = self.carriers.firstIndex(where: { $0.id == updatedCarrier.id }) {
                let oldRiderId = self.carriers[index].rider_id
                self.carriers[index] = updatedCarrier // does this update need to be on the main thread?
                if let newRiderId = updatedCarrier.rider_id, oldRiderId != newRiderId {
                    // Fetch new scorecards for the rider
                    Task {
                        do {
                            let newScorecards = try await networkManager.fetchScorecards(forRiders: [newRiderId])
                            
                            // Update the scorecards array with these new scorecards
                            // Ensure no duplicates and handle the data accordingly
                            self.handleNewScorecards(newScorecards)
                        } catch {
                            print("Error fetching scorecards: \(error)")
                        }
                    }
                }
            }
        } catch {
            print("Decoding error: \(error)")
        }
    }
    
    private func handleNewScorecards(_ newScorecards: [Scorecard]) {
        for var newScorecard in newScorecards {
            
            // Find the corresponding Rider and assign it to the new Scorecard
            if let rider = self.riders.first(where: { $0.id == newScorecard.rider }) {
                newScorecard.riderObj = rider
            }
            
            // Check if this scorecard is already in the list
            if !self.scorecards.contains(where: { $0.id == newScorecard.id }) {
                DispatchQueue.main.async {
                    self.scorecards.append(newScorecard)
//                    self.liveFeed = self.updateFilteredLiveFeed()
                    
                    
                }
                
                
                
            }
        }
    }
    
    func updateFilteredLiveFeed() -> [Scorecard] {
        var filteredScorecards: [Scorecard]
        print("update Filtered")
        print(scorecards.count)
        
        if let selectedRider = selectedRider {
            // Filter the scorecards to show only those associated with the selected rider
            filteredScorecards = scorecards.filter { $0.rider == selectedRider.id }
        } else {
            // If there's no selected rider, use all scorecards
            filteredScorecards = scorecards
        }
        
        // Sort the scorecards by date, most recent first
        return filteredScorecards.sorted { $0.date > $1.date }
    }
    
    private func fetchScorecardsForCarriers() {
        let riderIDs = carriers.compactMap { $0.rider_id }
        Task {
            do {
                let fetchedScorecards = try await networkManager.fetchScorecards(forRiders: riderIDs)
                DispatchQueue.main.async {
                    // Update your scorecards array
                    self.handleNewScorecards(fetchedScorecards)
                }
            } catch {
                DispatchQueue.main.async {
                    // Handle any errors, maybe update an alertItem to show an error message
                    self.alertItem = AlertContext.alert(for: .unableToComplete) // Modify as needed
                }
            }
        }
    }
    
    private func selectRiderAtScrollPosition() {
        guard let scrollPosition = scrollPosition, scrollPosition >= 0, scrollPosition < carriers.count else {
            selectedRider = nil
            return
        }
        
        let carrier = carriers[scrollPosition]
        if let riderID = carrier.rider_id {
            selectedRider = riders.first { $0.id == riderID }
        } else {
            selectedRider = nil
        }
    }
    
    func fetchMoreScorecards() {
        guard !isLoading, let cursor = getCursorPosition() else { return }
//        isLoading = true
        Task {
            do {
                let riderIds = selectedRider != nil ? [selectedRider!.id].compactMap { $0 } : []
                let newScorecards = try await networkManager.fetchScorecards(forRiders: riderIds, cursor: cursor)
                DispatchQueue.main.async {
                    self.handleNewScorecards(newScorecards)
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.alertItem = AlertContext.alert(for: .unableToComplete)
                    self.isLoading = false
                }
            }
        }
    }
    
    func getCursorPosition() -> String? {
        // Ensure there are at least 3 scorecards
        guard liveFeed.count >= 3 else {
            return nil
        }

        // Fetch the third-to-last scorecard
        let targetScorecard = liveFeed[liveFeed.count - 3]

        // Return the cursor or identifier of the third-to-last scorecard
        let dateFormatter = ISO8601DateFormatter()
        let targetScorecardDate = dateFormatter.string(from: targetScorecard.date)
        print("Third-to-last Scorecard Date: \(targetScorecardDate)")
        return targetScorecardDate
    }
    
    func fetchAllScorecards() {
        isLoading = true
            Task {
                do {
                    let allScorecards = try await networkManager.fetchScorecards()
                    DispatchQueue.main.async {
                        self.handleNewScorecards(allScorecards)
                        self.isLoading = false
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        // Handle any errors, perhaps by updating an alertItem to show an error message
                        self.alertItem = AlertContext.alert(for: .unableToComplete) // Modify as needed
                    }
                }
            }
        }

}

