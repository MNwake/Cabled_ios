//
//  RiderFilterSheet.swift
//  TheCWA
//
//  Created by Theo Koester on 2/29/24.
//

import SwiftUI
struct RiderFilterSheet: View {
    @Binding var isShowingFilter: Bool
    @Binding var selectedDivision: String
    @Binding var selectedCategory: String
    @Binding var selectedAgeGroup: String
    @Binding var selectedStance: String
    @Binding var selectedGender: String

    private let divisions = ["All", "Beginner", "Novice", "Intermediate", "Advanced", "Pro"]
    private let ageGroups = ["All","Groms", "Juniors", "Adults", "Masters", "Veterans"]
    private let categories = ["CWA", "Best Trick", "Best 10"]
    private let genders = ["All", "Male", "Female"]
    private let stances = ["All", "Regular", "Goofy"]

    var body: some View {
        VStack(spacing: 15, content: {
            ExitButtonRight(isShowingFilter: $isShowingFilter)
            createFilterSectionView(title: "Category:", items: categories, selectedItem: $selectedCategory)
            Divider()
            createFilterSectionView(title: "Division:", items: divisions, selectedItem: $selectedDivision)
            Divider()
            createFilterSectionView(title: "Age Group:", items: ageGroups, selectedItem: $selectedAgeGroup)
            Divider()
            createFilterSectionView(title: "Gender:", items: genders, selectedItem: $selectedGender)
            Divider()
            createFilterSectionView(title: "Stance:", items: stances, selectedItem: $selectedStance)
            Divider()
        })
        .padding(12)
        .frame(maxWidth: .infinity)
//        .background(Color.white)
        .cornerRadius(10)
    }

    private func createFilterSectionView(title: String, items: [String], selectedItem: Binding<String>) -> some View {
        FilterSectionView(title: title, items: items, selectedItem: selectedItem)
    }
}


struct Chip: View {
    var text: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Text(text)
            .font(.subheadline)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(isSelected ? Color.blue : Color.clear)
            // Set the foreground color based on selection
            .foregroundColor(isSelected ? Color(.white) : Color(.label))
            .cornerRadius(10)
            // Add a border when not selected
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.clear : Color.blue, lineWidth: 1)
            )
            .onTapGesture(perform: action)
    }
}

struct FilterSectionView: View {
    var title: String
    var items: [String]
    @Binding var selectedItem: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)

                .font(.title2)
                .padding([.leading])

            // Horizontal ScrollView
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(items, id: \.self) { item in
                        Chip(text: item, isSelected: selectedItem == item) {
                            selectedItem = item
                        }
                    }
                }
                .padding([.leading, .trailing])
            }
        }
    }
}


struct ExitButtonRight: View {
    @Binding var isShowingFilter: Bool

    var body: some View {
        HStack {
            Spacer()
            Button(action: { isShowingFilter = false }) {
                Image(systemName: "xmark")
                    .foregroundColor(Color(.label))
                    .imageScale(.large)
                    .frame(width: 44, height: 44)
            }
        }
    }
}

struct RiderFilterSheet_Previews: PreviewProvider {
    static var previews: some View {
        // Dummy @State variables for the preview
        @State var isShowingFilter = true
        @State var selectedDivision = "All"
        @State var selectedCategory = "CWA"
        @State var selectedAgeGroup = "All"
        @State var selectedStance = "All"
        @State var selectedGender = "All"

        // RiderFilterSheet view with bindings to the dummy variables
        RiderFilterSheet(isShowingFilter: $isShowingFilter,
                         selectedDivision: $selectedDivision,
                         selectedCategory: $selectedCategory,
                         selectedAgeGroup: $selectedAgeGroup,
                         selectedStance: $selectedStance,
                         selectedGender: $selectedGender)
    }
}
