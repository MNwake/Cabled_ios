//
//  TrickListView.swift
//  Cabled
//
//  Created by Theo Koester on 3/28/24.
//

import SwiftUI

struct TrickListView: View {
    var tricks: [(key: String, value: TrickDetail)]
    @Binding var selectedTrickDetail: TrickDetail?
    @Binding var isShowingTrickDetail: Bool

    var body: some View {
        Section(header: Text("Trick List").font(.headline)) {
            ForEach(tricks, id: \.key) { trickName, trickDetail in
                trickButton(trickDetail: trickDetail, trickName: trickName)
            }
        }
    }

    @ViewBuilder
    private func trickButton(trickDetail: TrickDetail, trickName: String) -> some View {
        if let _ = tricks.first(where: { $0.key == trickName }) {
            Button(action: {
                self.selectedTrickDetail = trickDetail
                self.isShowingTrickDetail = true
            }) {
                HStack {
                    Text("\(Int(trickDetail.stats.count ?? 0))x:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(trickDetail.scorecard.trickName)
                        .font(.subheadline)
                    Spacer()
                    VStack {
                        Text("High Score:")
                            .font(.caption)
                            .padding(.bottom)
                            .underline()
                            .foregroundStyle(Color(.label))
                        Text("\(String(format: "%.2f", trickDetail.stats.max ?? 0))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
        } else {
            EmptyView()
        }
    }
}
