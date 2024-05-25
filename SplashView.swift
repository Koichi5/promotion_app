//
//  SplashView.swift
//  PromotionApp
//
//  Created by Koichi Kishimoto on 2024/05/18.
//

import SwiftUI

struct SplashView: View {
    @Environment(AppState.self) var appState
    
    var body: some View {
        VStack {
            Text("Promotion App")
                .font(.extraLargeTitle)
                .fontWeight(.bold)
                .padding(.vertical)
            Button("Start") {
                appState.startHome()
            }
        }
    }
}

#Preview {
    SplashView()
}
