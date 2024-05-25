//
//  AppState+CleanerView.swift
//  PromotionApp
//
//  Created by Koichi Kishimoto on 2024/05/18.
//

import Foundation
import RealityKit

extension AppState {
    public func addToTemplate(template: Entity) {
        cleanerEntityTemplates.append(template)
    }
    
    public func addToSubTemplate(entity: Entity) -> SIMD3<Float> {
        let preEntityPosition = entity.position
        cleanerEntitySubTemplate = entity
        entity.position = SIMD3<Float>(0,0,0)
        return preEntityPosition
    }
    
    public func returnToTemplateFromSubTemplate(entity: Entity) {
        entity.position = preEntityPosition
        self.addToTemplate(template: entity)
        self.addCleanerEntitiesToRoot()
    }
}

