//
//  ContentView.swift
//  PromotionApp
//
//  Created by Koichi Kishimoto on 2024/05/16.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    @Environment(AppState.self) private var appState
    @Environment(\.scenePhase) private var scenePhase

    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false
    
    var body: some View {
        @Bindable var appState = appState
        switch appState.phase {
        case .startingUp, .waitingToStart, .loadingAssets:
            SplashView()
        case .home, .cleanerDetail:
            CleanerView()
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
