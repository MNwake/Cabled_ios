//
//  LiveFeedView.swift
//  TheCWA
//
//  Created by Theo Koester on 2/29/24.
//

import SwiftUI

struct LiveFeedView: View {
    @ObservedObject var viewModel = LiveFeedViewModel()
    
    
    
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    Section(header: Text("View By Carrier:")
                        .foregroundColor(viewModel.isRidersPanelExpanded ? .primary : .secondary)) {
                        if viewModel.isRidersPanelExpanded {
                            RidersOnWaterView(scrollPosition: $viewModel.scrollPosition,
                                              carriers: $viewModel.carriers,
                                              riders: $viewModel.riders,
                                              parks: $viewModel.parks,
                                              onRiderTap: { rider in
                                viewModel.selectedRider = rider
                                viewModel.showRiderProfile = true
                                
                            }
                            )
                        }
                    }
                    .onTapGesture {
                        // Toggle the panel expansion
                        viewModel.isRidersPanelExpanded.toggle()
                        
                        // If the panel is being closed, set the selectedRider to nil
                        if !viewModel.isRidersPanelExpanded {
                            viewModel.selectedRider = nil
                        }
                    }
                    
                    
                    // Scorecard List Section
                    Section(header: Text("Live Feed: \(String(describing: viewModel.selectedRider?.fullName ?? "All"))")) {
                        ForEach(viewModel.liveFeed, id: \.id) { scorecard in
                            LiveFeedScorecard(scorecard: scorecard)
                                .onAppear {
                                    if viewModel.liveFeed.last == scorecard {
                                        viewModel.fetchMoreScorecards()
                                        print("fetch scorecards")
                        }
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("🏄‍♂️ Live:")
                
                .onAppear {
                    viewModel.getLiveFeedData()
                }
            }
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: alertItem.dismissButton)
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
            
            
        }
        .onChange(of: viewModel.scrollPosition) { oldIndex, newIndex in
            viewModel.selectRider(forIndex: newIndex ?? 0)
        }
        .sheet(isPresented: $viewModel.showRiderProfile) {
            if let selectedRider = viewModel.selectedRider {
                
                RiderProfileView(rider: selectedRider)
            }
        }
        
    }
    
}


struct CarrierView: View {
    var rider: Rider?
    var carrier: ContestCarrier?
    var park: Park?
    
    var body: some View {
        if let rider = rider {
            occupiedView(rider: rider)
        } else {
            unoccupiedView()
        }
    }
    
    
    @ViewBuilder
    private func occupiedView(rider: Rider) -> some View {
        HStack {
            // Rider Image
            AsyncRiderImageView(urlString: rider.profile_image.absoluteString)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 2)) // Adding a border to the image
                .shadow(radius: 3) // Adding a subtle shadow for depth
            
            // Rider Info
            VStack(alignment: .leading, spacing: 8) { // Aligned to the leading edge and spaced
                Text(rider.fullName)
                    .font(.headline) // Making the name stand out
                    .foregroundColor(.primary) // Adapting color for light/dark mode
                
                Text("Division: \(rider.divisionLabel)")
                    .font(.subheadline)
                    .foregroundColor(.secondary) // Subdued color for less important information
                
                Text("Age Group: \(rider.ageGroup)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                
                Text("Team: \(park?.abbreviation ?? "")")
                    .font(.subheadline)
                    .fontWeight(.semibold) // Emphasizing team name
                    .foregroundColor(.blue) // A different color for distinction
            }
        }
        
        .padding() // Padding to give some breathing room
        .background(carrier?.bibColor.opacity(0.6)) // Light background to distinguish the widget
        .cornerRadius(10) // Rounded corners for a softer look
        //        .shadow(color: carrier?.bibColor ?? .black, radius: 10) // Shadow for depth
        
    }
    
    @ViewBuilder
    private func unoccupiedView() -> some View {
        VStack {
            Text("Empty")
            Text("Carrier #\(carrier?.number ?? 0)")
        }
        
        .frame(width: 160, height: 210)
    }
    
    
}
struct CircleIndicator: View {
    var isSelected: Bool
    
    var body: some View {
        Circle()
            .fill(isSelected ? Color.blue : Color.gray)
            .frame(width: isSelected ? 12 : 8, height: isSelected ? 12 : 8)
            .transition(.scale)
    }
}



#Preview {
    LiveFeedView()
}


struct RidersOnWaterView: View {
    @Binding var scrollPosition: Int?
    @Binding var carriers: [ContestCarrier]
    @Binding var riders: [Rider]
    @Binding var parks: [Park]
    var onRiderTap: (Rider) -> Void
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(Array(carriers.enumerated()), id: \.1.id) { index, carrier in
                        let rider = riders.first { $0.id == carrier.rider_id }
                        let riderPark = parks.first { $0.id == rider?.home_park }
                        CarrierView(rider: rider, carrier: carrier, park: riderPark)
                            .id(index)
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1.0 : 0.2)
                                    .scaleEffect(x: phase.isIdentity ? 1.0: 0.3,
                                                 y:phase.isIdentity ? 1.0: 0.3)
                                    .offset(y: phase.isIdentity ? 0 : 50)
                                
                            }
                            .onTapGesture {
                                print("Tap")
                                if let rider = rider {
                                    onRiderTap(rider)
                                }
                            }
                    }
                }
                .scrollTargetLayout()
                
            }
            .scrollPosition(id: $scrollPosition)
            .contentMargins(.vertical, 10, for: .scrollContent)
            .scrollTargetBehavior(.paging)
            
            HStack {
                Spacer()
                HStack(spacing: 8) {
                    ForEach(carriers.indices, id: \.self) { index in
                        CircleIndicator(isSelected: scrollPosition == index)
                    }
                }
                Spacer()
            }
        }
        
    }
}

