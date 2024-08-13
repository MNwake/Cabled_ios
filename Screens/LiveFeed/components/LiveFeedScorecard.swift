//
//  LiveFeedScorecard.swift
//  TheCWA
//
//  Created by Theo Koester on 2/29/24.
//

import SwiftUI

struct LiveFeedScorecard: View {
    let scorecard: Scorecard
    @Environment(\.colorScheme) var colorScheme
    
    var landingStatus: String {
            scorecard.landed ? "Landed" : "Fell"
        }
    
    private let redModifiers = ["Repeat", "Sketchy", "Lazy", "Zeached", "Over/Under Rotated", "Wild", "Bailed", "Rushed", "911", "Off-Early"]
    private let blueModifiers = ["Grabbed", "Ole", "Wrapped", "Boosted", "Stomped", "Tweaked", "High-Stakes", "Technical", "Innovative", "Pressed", "Switch-Up", "MJ'd", "Handdrag", "Double-Flip" ]
    
    func colorForModifier(_ modifier: String) -> Color {
        let modifierCapitalized = modifier.capitalized
        if redModifiers.contains(modifierCapitalized) {
            return Color.red.opacity(0.6)
        } else if blueModifiers.contains(modifierCapitalized) {
            return Color.blue.opacity(0.6)
        } else {
            return Color.gray.opacity(0.6)
        }
    }
    
    var backgroundColor: Color {
            if !scorecard.landed {
                return Color.red.opacity(0.3) // Semi-transparent red when not landed
            } else {
                return colorScheme == .dark ? Color(UIColor.secondarySystemBackground) : Color(UIColor.systemBackground)
            }
        }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                AsyncRiderImageView(urlString: scorecard.riderObj?.profile_image.absoluteString ?? "default-avatar")
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2)) // Adding a border to the image
                    .shadow(radius: 3)
                    .padding(4)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(scorecard.riderObj?.fullName ?? "John Doe")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("\(divisionLabel(forValue: scorecard.division))")
                        .font(.callout)
                        .foregroundColor(.secondary)
                
                }
                
                Spacer()
                
                VStack(spacing: 1) {
                    Spacer()
                    Score(value: scorecard.creativity, category: .creativity, style: .shortened)
                    Score(value: scorecard.difficulty, category: .difficulty, style: .shortened)
                    Score(value: scorecard.execution, category: .execution, style: .shortened)
                    Spacer()
                }
                
                
                DonutChartView(creativityScore: scorecard.creativity, executionScore: scorecard.execution, difficultyScore: scorecard.difficulty)
                    .frame(width: 60, height: 60)
            }
            .padding([.top, .horizontal])
            
            Text(scorecard.section.capitalized)
                .font(.subheadline)
                .padding(.horizontal)
                .foregroundColor(.primary)
            
            Text(scorecard.trickName)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                
            
            HStack(spacing: 10) {
                Text("\(landingStatus): ")
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    
                    
                
                ForEach(Array(scorecard.modifiers.prefix(3)), id: \.self) { modifier in
                    Text(modifier.capitalized)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(colorForModifier(modifier)))
                        .foregroundColor(colorForModifier(modifier) == Color.gray.opacity(0.2) ? .black : .white)
                }
            }
            .padding(.bottom)
            .padding(.horizontal)
        }
        .background(backgroundColor)
        .cornerRadius(12)
        .shadow(color: Color.gray.opacity(0.4), radius: 6, x: 0, y: 2)
        //        .padding(.horizontal)
    }
}

enum ScoreStyle {
    case shortened
    case full
}

struct Score: View {
    var value: Double
    var category: ScoreCategory
    var style: ScoreStyle
    
    var body: some View {
        HStack {
            Text(formattedLabel)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(category.color)
        }
        .padding(.trailing)
    }
    
    private var formattedLabel: String {
        switch category {
        case .division:
            let divisionLabel = divisionLabel(forValue: value)
            return style == .shortened ? "D: \(divisionLabel)" : "Division: \(divisionLabel)"
        default:
            let scoreFormat = style == .shortened ? "\(category.rawValue.prefix(1).uppercased()): %.0f" : "\(category.rawValue): %.0f"
            return String(format: scoreFormat, value)
        }
    }
}


struct DonutChartSlice: Shape {
    var startAngle: Angle
    var endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: rect.width / 2,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false)
        return path.strokedPath(.init(lineWidth: rect.width / 4, lineCap: .round))
    }
}

struct DonutChartView: View {
    var creativityScore: Double
    var executionScore: Double
    var difficultyScore: Double
    
    private var totalScore: Double {
        creativityScore + executionScore + difficultyScore
    }
    
    private var averageScore: Double {
        totalScore / 3
    }
    
    var body: some View {
        ZStack {
            // Creativity slice
            DonutChartSlice(startAngle: .degrees(0), endAngle: .degrees((creativityScore / totalScore) * 360))
                .fill(ScoreCategory.creativity.color.gradient)
            // Execution slice
            DonutChartSlice(startAngle: .degrees((creativityScore / totalScore) * 360),
                            endAngle: .degrees(((creativityScore + executionScore) / totalScore) * 360))
            .fill(ScoreCategory.execution.color.gradient)
            // Difficulty slice
            DonutChartSlice(startAngle: .degrees(((creativityScore + executionScore) / totalScore) * 360),
                            endAngle: .degrees(360))
            .fill(ScoreCategory.difficulty.color.gradient)
            
            // Average score in the middle
            Text(String(format: "%.1f", averageScore))
                .font(.body)
        }
    }
}
