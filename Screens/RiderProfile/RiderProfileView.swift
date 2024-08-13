//
//  RiderProfile.swift
//  TheCWA
//
//  Created by Theo Koester on 3/3/24.
//

import SwiftUI
import Charts


struct RiderProfileView: View {
    @ObservedObject var viewModel: RiderProfileViewModel
    @State var selectedSegment = "Overall"
    @State var rider: Rider
    @State private var selectedTrickDetail: TrickDetail?
    @State private var isShowingTrickDetail = false
    
    
    
    init(rider: Rider) {
        self.rider = rider
    
        viewModel = RiderProfileViewModel(riderID: rider.id ?? "", profile: MockData.sampleRiderProfile)
    }
    
    var body: some View {
        ZStack{
            ScrollView{
                VStack(spacing: 16) {
                    AsyncRiderImageView(urlString: rider.profile_image.absoluteString)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 4))
                        .padding(.top)
                    
                    
                    Text(viewModel.profile.rider.fullName)
                        .font(.title)
                    Text(viewModel.profile.rider.divisionLabel)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.bottom)
                    
                    RiderProfieInfoBar(age: viewModel.profile.rider.age, yearsRiding: viewModel.profile.rider.yearsRiding, stance: viewModel.profile.rider.stance) // Sets the corner radius. Adjust the value as needed
                    
                    RankingCardsGridView(cwaRank: viewModel.profile.cwaRank,
                                         ageGroup: viewModel.profile.rider.ageGroup,
                                         ageRank: viewModel.profile.ageRank,
                                         divisionLabel: viewModel.profile.rider.divisionLabel,
                                         divisionRank: viewModel.profile.divisionRank,
                                         experienceLabel: viewModel.profile.rider.experienceLabel,
                                         experienceRank: viewModel.profile.experienceRank)
                    
                    CompletionStatsView(total: viewModel.profile.trickCount, scored: viewModel.profile.scoredCount, attempted: viewModel.profile.attemptedCount)
                    
                    if !viewModel.graphData.isEmpty {
                        BarGraphView(graphData: viewModel.graphData)
                            .frame(height: 150)
                    }
                    
                    TrickListView(tricks: viewModel.sortedTricks,
                                                  selectedTrickDetail: $selectedTrickDetail,
                                                  isShowingTrickDetail: $isShowingTrickDetail)
//                    OverallView(viewModel: viewModel, profile: $viewModel.profile, scoreCounts: viewModel.scoreCounts, selectedTrickDetail: $selectedTrickDetail,
//                                isShowingTrickDetail: $isShowingTrickDetail)
//                        .padding(.vertical)
                    
                }
                .padding()
                .alert(item: $viewModel.alertItem) { alertItem in
                    Alert(title: alertItem.title,
                          message: alertItem.message,
                          dismissButton: alertItem.dismissButton)
                }
                // Consider adding .onAppear here to trigger data fetch in viewModel
                if viewModel.isLoading {
                    LoadingView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.45))
                }
            }
            .disabled(isShowingTrickDetail)
            .blur(radius: isShowingTrickDetail ? 20 : 0)
            if isShowingTrickDetail, let selectedTrickDetail = selectedTrickDetail {
                TrickDetailView(trickDetail: selectedTrickDetail, isShowingDetail: $isShowingTrickDetail)
            }
            
            if viewModel.isLoading {
                LoadingView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.45))
            }
        }
        
    }
}


struct BarGraphView: View {
    var graphData: [GraphData]
    
    var body: some View {
        VStack {
            Chart {
                ForEach(graphData) { graphData in
                    BarMark(
                        x: .value("Category", graphData.category),
                        y: .value("Score", graphData.value)
                    )
                    .foregroundStyle(graphData.scoreCategory?.color.gradient ?? Color.accentColor.gradient)
                }
            }
            .chartYAxis {
                AxisMarks(
                    preset: .aligned,
                    position: .leading
                )
            }
            .chartYScale(domain: (0...100))  /*Explicitly set the y-axis scale*/
            .frame(height: 150)
        }
    }
}

struct GraphData: Identifiable {
    let id = UUID()
    let category: String
    let value: Double
    let scoreCategory: ScoreCategory?
}


struct RankingCard: View {
    var label: String
    var rank: Int
    
    var body: some View {
        HStack {
            Text("\(label):")
                .font(.headline)
            Spacer()
            Text(rankAsString(rank))
                .font(.subheadline)
                .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func rankAsString(_ rank: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(for: rank) ?? "\(rank)"
    }
}

struct ScoreCounts {
    var overall: Int
    var cwa: Int
    var attempted: Int
}


struct RiderProfieInfoBar: View {
    var age: Int
    var yearsRiding: Int
    var stance: String
    var body: some View {
        HStack(spacing: 40) {
            // VStack 1: Basic Info
            VStack {
                Text("Age")
                    .font(.callout)
                    .padding(.bottom)
                    .underline()
                Text("\(age)") // Ensure you have a formatted date of birth in your ViewModel
                    .font(.caption)
            }
            
            
            // VStack 2: Performance Stats
            VStack {
                
                Text("Years Riding")
                    .font(.callout)
                    .padding(.bottom)
                    .underline()
                
                
                Text("\(yearsRiding)") // Calculate based on the current year and year_started
                    .font(.caption)
                
            }
            
            // VStack 3: Competition Details
            VStack {
                
                Text("Stance")
                    .font(.callout)
                    .padding(.bottom)
                    .underline()
                Text(stance)
                    .font(.caption)
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1)) // Sets the secondary background color with some opacity
        .clipShape(.buttonBorder)
    }
}























struct RiderProfileView_Previews: PreviewProvider {
    static var previews: some View {
        // Prepare mock data
        let sampleRider = MockData.sampleRider

        // Pass the ViewModel to the View
        RiderProfileView(rider: sampleRider)
    }
}

struct RankingCardsGridView: View {
    var cwaRank: Int
    var ageGroup: String
    var ageRank: Int
    var divisionLabel: String
    var divisionRank: Int
    var experienceLabel: String
    var experienceRank: Int
    
    var body: some View {
        Section(header: Text("Rankings").font(.headline)) {
            VStack(spacing: 20) {
                // First row of cards
                HStack(spacing: 20) {
                    RankingCard(label: "National", rank: cwaRank)
                    RankingCard(label: ageGroup, rank: ageRank)
                }

                // Second row of cards
                HStack(spacing: 20) {
                    RankingCard(label: divisionLabel, rank: divisionRank)
                    RankingCard(label: experienceLabel, rank: experienceRank)
                }
            }
        }
    }
}

struct CompletionStatsView: View {
    var total: Int
    var scored: Int
    var attempted: Int
    
    
    var body: some View {
        Section(header: Text("Stats").font(.headline)) {
            HStack(spacing: 40) {
                // VStack 1: Tricks Scored
                VStack {
                    Text("Total")
                        .font(.callout)
                        .padding(.bottom)
                        .underline()
                    Text("\(total)")
                        .font(.caption)
                }
                
                // VStack 2: % Counted
                VStack {
                    Text("Scored")
                        .font(.callout)
                        .padding(.bottom)
                        .underline()
                    
                    let countedPercent = scored != 0 ? Double(scored) / Double(total) * 100 : 0
                    Text("\(String(format: "%.0f", countedPercent))%")
                        .font(.caption)
                }
                
                // VStack 3: % Landed
                VStack {
                    Text("Landed")
                        .font(.callout)
                        .padding(.bottom)
                        .underline()
                    
                    let successfulAttempts = total - attempted
                    let landedPercent = total != 0 ? Double(successfulAttempts) / Double(total) * 100 : 0
                    Text("\(String(format: "%.0f", landedPercent))%")
                        .font(.caption)
                }
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .clipShape(.buttonBorder)
        }
    }
}
