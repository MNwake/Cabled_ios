//
//  SwiftUIView.swift
//  TheCWA
//
//  Created by Theo Koester on 2/29/24.
//

import SwiftUI


struct RiderRankingsView: View {
    @ObservedObject var viewModel = RiderRankingsViewModel()
    @State private var selectedRider: Rider?
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    RidersTopNavBar(isShowingFilter: $viewModel.isShowingFilterSheet,
                                    selectedCategory: $viewModel.selectedCategory)
                    
                    RankingListView(viewModel: viewModel, selectedRider: $selectedRider)
                }
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
                .sheet(isPresented: $viewModel.isShowingFilterSheet, content: {
                    RiderFilterSheet(isShowingFilter: $viewModel.isShowingFilterSheet,
                                     selectedDivision: $viewModel.selectedDivision,
                                     selectedCategory: $viewModel.selectedCategory,
                                     selectedAgeGroup: $viewModel.selectedAgeGroup,
                                     selectedStance: $viewModel.selectedStance,
                                     selectedGender: $viewModel.selectedGender)
                })
                //                .presentationDragIndicator(.visible)
                .alert(item: $viewModel.alertItem) { alertItem in
                    Alert(title: alertItem.title,
                          message: alertItem.message,
                          dismissButton: alertItem.dismissButton)
                }
                
                if viewModel.isLoading {
                    LoadingView()  // Show loading view when data is being fetched
                }
            }
            .sheet(item: $selectedRider) { rider in
                RiderProfileView(rider: rider)
            }
        }
        .onAppear {
            viewModel.getRiderData()
        }
    }
}



struct RankingListView: View {
    @ObservedObject var viewModel: RiderRankingsViewModel
    @Binding var selectedRider: Rider?
    @State private var showProfile = false
    
    var body: some View {
        List {
            ForEach(Array(viewModel.rankingList.enumerated()), id: \.element.id) { index, rider in
                Button(action: {
                    self.selectedRider = rider
                }) {
                    RiderRankingCard(rider: rider, index: index)
                }
            }
            .listStyle(PlainListStyle())
            .onAppear {
                viewModel.createRankingList()
            }
            .refreshable {
                viewModel.getRiderData()
            }
        }
    }
    
}

struct RidersTopNavBar: View {
    @Binding var isShowingFilter: Bool
    @Binding var selectedCategory: String
    
    var body: some View {
        HStack {
            Text("🏆 \(selectedCategory)")
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
            
            Button(action: {
                isShowingFilter = true
            }) {
                Image(systemName: "line.horizontal.3.decrease.circle")
                    .imageScale(.large)
            }
        }.padding(18)
    }
}

struct RiderRankingCard: View {
    let rider: Rider
    let index: Int
    
    
    var body: some View {
        HStack {
            Text("\(index+1)")
                .fontWeight(.bold)
                .padding(12)
            
            VStack(alignment: .leading) {
                Text(rider.fullName)
                    .fontWeight(.bold)
                Text("\(rider.divisionLabel)") // Convert division to String
                    .font(.subheadline)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(String(format: "%.1f", rider.score ?? 0.0)) // Placeholder score, replace with actual score
                    .fontWeight(.bold)
                Text("Score")
                    .font(.subheadline)
            }
        }
    }
}




// SwiftUI Preview
struct RiderRankingsView_Previews: PreviewProvider {
    static var previews: some View {
        RiderRankingsView()
    }
}
