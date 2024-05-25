//
//  PromotionAppApp.swift
//  PromotionApp
//
//  Created by Koichi Kishimoto on 2024/05/16.
//

import SwiftUI


@main
@MainActor
struct PromotionApp: App {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissWindow) var dismissWindow
    
    @State private var appState = AppState()
    @State private var immersionStyle: ImmersionStyle = .full
    var body: some Scene {
        WindowGroup(id: ViewIDs.contetView) {
            ContentView()
                .environment(appState)
        }
        .windowStyle(.plain)
        .defaultSize(width: 1200, height: 1200, depth: 1000)
        
        WindowGroup(id: ViewIDs.cleanerDetailView, for: String.self) { value in
            CleanerDetaiView(modelName: value.wrappedValue!)
                .environment(appState)
        }
    }
}

struct ViewIDs {
    static let contetView = "ContentViewID"
    static let cleanerDetailView = "CleanerDetailViewID"
}
