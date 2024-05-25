//
//  AppState.swift
//  PromotionApp
//
//  Created by Koichi Kishimoto on 2024/05/18.
//

import Foundation
import SwiftUI
import RealityKit

@Observable
@MainActor
public class AppState {
    var phase: AppPhase = .startingUp
    var isImmersiveViewShown = false
    public var root = Entity()
    public var subRoot = Entity()
    var cleanerEntityTemplates = [Entity]()
    var cleanerEntitySubTemplate = Entity()
    var preEntityPosition = SIMD3<Float>(0, 0, 0)
    
    init() {
        Task.detached(priority: .high) {
            await self.loadModels()
        }
    }
}
