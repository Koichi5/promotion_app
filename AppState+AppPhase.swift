//
//  AppState+AppPhase.swift
//  PromotionApp
//
//  Created by Koichi Kishimoto on 2024/05/18.
//

import Foundation
import RealityKit

extension AppState {
    public func finishedStartingUp() {
        phase.transition(to: .loadingAssets)
    }
    
    public func finishedLoadingAssets() {
        phase.transition(to: .waitingToStart)
    }
    
    public func startHome() {
        phase.transition(to: .home)
        self.addCleanerEntitiesToRoot()
    }
    
    public func cleanerDetail(modelName: String) {
        phase.transition(to: .cleanerDetail)
        self.addCleanerEntitiesToSubState(entityName: modelName)
        self.addCleanerEntitiesToSubRoot()
    }
}
