//
//  RiderProfileViewModel.swift
//  Cabled
//
//  Created by Theo Koester on 3/27/24.
//

import SwiftUI

final class RiderProfileViewModel: ObservableObject, WebSocketObserver {
    
    @Published var profile: RiderProfile 
    @Published var isLoading = false
    @Published var alertItem: AlertItem?
    @Published var graphData: [GraphData] = []
    
    
    
    
    private let networkManager = NetworkManager.shared
    
    init(riderID: String, profile: RiderProfile) {
        self.profile = profile
        
        // Fetch data when the ViewModel is initialized
        Task {
            await getData(for: riderID)
        }
    }
    
    var sortedTricks: [(key: String, value: TrickDetail)] {
           profile.tricks.sorted { (first, second) -> Bool in
               let firstMaxScore = first.value.stats.max ?? 0
               let secondMaxScore = second.value.stats.max ?? 0
               return firstMaxScore > secondMaxScore
           }
       }
    
    func createGraphData() -> [GraphData] {
        
        let data = [
            //            GraphData(category: "Overall", value: stats.overallScore),
            GraphData(category: "Kickers", value: profile.statistics.overall.section.kicker?.mean ?? 0, scoreCategory: .none),
            GraphData(category: "Rails", value: profile.statistics.overall.section.rail?.mean ?? 0, scoreCategory: .none),
            GraphData(category: "Air Tricks", value: profile.statistics.overall.section.airTrick?.mean ?? 0, scoreCategory: .none),
            GraphData(category: "Creativity", value: profile.statistics.overall.score.creativity.mean ?? 0, scoreCategory: .creativity),
            GraphData(category: "Execution", value: profile.statistics.overall.score.execution.mean ?? 0, scoreCategory: .execution),
            GraphData(category: "Difficulty", value: profile.statistics.overall.score.difficulty.mean ?? 0, scoreCategory: .difficulty)
        ]
        for datum in data {
                print("Graph Data: \(datum.category), Value: \(datum.value)")
            }
        return data.filter { $0.value.isFinite }
    }
 
    
    
    func didReceiveWebSocketMessage(_ message: WebSocketMessage) {
        print("received message:")
        print(message.type)
    }
    
    
    func getData(for riderID: String) async {
        self.isLoading = true
        do {
            let fetchedProfile = try await networkManager.fetchRiderProfile(riderID: riderID)
            
            DispatchQueue.main.async { // Make sure UI updates are on the main thread
                self.profile = fetchedProfile
                self.graphData = self.createGraphData() // Set graph data here
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                print("Error fetching data: \(error)")
                self.alertItem = AlertContext.alert(for: .invalidProfile)
            }
        }
    }
}
