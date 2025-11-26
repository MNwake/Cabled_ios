//
//  CabledApp.swift
//  Cabled
//
//  Created by Theo Koester on 3/19/24.
//

import SwiftUI

@main
struct CabledApp: App {
    @Environment(\.scenePhase) var scenePhase
    let websocketHandler = WebSocketHandler.shared

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onChange(of: scenePhase) { oldScenePhase, newScenePhase in
                    switch newScenePhase {
                    case .active:
                        // App has become active
                        print("App is active")
                        websocketHandler.connect(to: URL(string: WEBSOCKET_URL)!)
                    case .background:
                        // App has moved to the background
                        print("App is in background")
                        websocketHandler.disconnect()
                    case .inactive:
                        break
                    @unknown default:
                        break
                    }
                }
        }
    }
}
