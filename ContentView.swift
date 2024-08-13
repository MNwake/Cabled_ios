//
//  ContentView.swift
//  Cabled
//
//  Created by Theo Koester on 3/19/24.
//

import SwiftUI


import SwiftUI

struct ContentView: View {
    var body: some View {
        
        TabView {
            LiveFeedView()
                .tabItem {
                    Label("Live Feed", systemImage: "livephoto")
                }

            RiderRankingsView()
                .tabItem {
                    Label("Riders", systemImage: "person.fill")
                }

//            TeamRankingsView()
//                .tabItem {
//                    Label("Teams", systemImage: "person.3.fill")
//            }
        }.onAppear {

            
        }
        
    }
    
}


        

struct BackgroundView: View {
    var topColor: Color
    var bottomColor: Color
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [topColor, bottomColor]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
        
    }
}




struct TeamRankingsView: View {
    var body: some View {
        Text("Team Rankings")
    }
}

#Preview {
    ContentView()
}
