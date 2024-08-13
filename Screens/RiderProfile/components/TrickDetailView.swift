//
//  TrickDetailView.swift
//  Cabled
//
//  Created by Theo Koester on 3/27/24.
//

import SwiftUI


struct TrickDetailView: View {
    let trickDetail: TrickDetail
    @Binding var isShowingDetail: Bool
    
    private let gridLayout: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    private let columns = [
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            Spacer().frame(height: 80) // Adjust the top spacing
            
            
            Text(trickDetail.scorecard.section)
            
            // Trick Name
            Text(trickDetail.scorecard.trickName.capitalized)
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.bottom, 10)
            
            // Donut Chart and Scores
            HStack(spacing: 20) {
                
                DonutChartView(creativityScore: trickDetail.scores.creativity.mean ?? 0,
                               executionScore: trickDetail.scores.execution.mean ?? 0,
                               difficultyScore: trickDetail.scores.difficulty.mean ?? 0)
                .frame(width: 60, height: 60)
                
                VStack(alignment: .leading) {
                    Score(value: trickDetail.scores.division.mean ?? 0, category: .division, style: .full)
                    Score(value: trickDetail.scores.creativity.mean ?? 0, category: .creativity, style: .full)
                    Score(value: trickDetail.scores.difficulty.mean ?? 0, category: .difficulty, style: .full)
                    Score(value: trickDetail.scores.execution.mean ?? 0, category: .execution, style: .full)
                }
            }
            .padding(.vertical, 20)
            
            
            
            // Chart for Stats
            LazyVGrid(columns: columns, alignment: .leading, spacing: 15) {
                // Headers
                Group {
                    Text("Category")
                    Text("Low")
                    Text("Average")
                    Text("High")
                }
                .font(.caption)
                .fontWeight(.semibold)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            

                
                // Overall
                statsRow(title: "Overall:", stats: trickDetail.stats)
                // Execution
                statsRow(title: "Execution:", stats: trickDetail.scores.execution)
                // Difficulty
                statsRow(title: "Difficulty:", stats: trickDetail.scores.difficulty)
                // Creativity
                statsRow(title: "Creativity:", stats: trickDetail.scores.creativity)
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Dismiss Button
            Button(action: { isShowingDetail = false }) {
                Text("Close")
                    .fontWeight(.semibold)
            }
            .padding(.bottom, 20)
        }
        .frame(width: 350, height: 525)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 40)
        .overlay(XDismissButton(isShowingDetail: $isShowingDetail), alignment: .topTrailing)

    }
    
    @ViewBuilder
    private func statsRow(title: String, stats: StatsDetails) -> some View {
        Text(title).font(.caption).fontWeight(.semibold)

        if title == "Division" {
            // For Division, display label instead of number
            Text(divisionLabel(forValue: stats.mean ?? 0)).font(.caption)
            Text(divisionLabel(forValue: stats.min ?? 0)).font(.caption)
            Text(divisionLabel(forValue: stats.max ?? 0)).font(.caption)
        } else {
            // For other categories, display numerical values
            Text(String(format: "%.2f", stats.min ?? 0)).font(.caption)
            Text(String(format: "%.2f", stats.mean ?? 0)).font(.caption)
            Text(String(format: "%.2f", stats.max ?? 0)).font(.caption)
        }
    }
}

struct XDismissButton: View {
    @Binding var isShowingDetail: Bool

    var body: some View {
        Button(action: { isShowingDetail = false }) {
            ZStack {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .opacity(0.2)
                
                Image(systemName: "xmark")
                    .imageScale(.small)
                    .frame(width: 44, height: 44)
                    .foregroundColor(.black)
            }
        }
    }
}





struct TrickDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a binding variable for the preview. This is just for the sake of the preview.
        @State var isShowingDetail = true
        
        // Provide the TrickDetailView with the sampleTrickDetail and the binding variable.
        TrickDetailView(trickDetail: MockData.sampleTrickDetail, isShowingDetail: $isShowingDetail)
    }
}
