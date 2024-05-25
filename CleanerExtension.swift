//
//  CleanerExtension.swift
//  PromotionApp
//
//  Created by Koichi Kishimoto on 2024/05/19.
//

import SwiftUI
import RealityKit

extension CleanerView {
    @MainActor
    public func onEntityTap(value: EntityTargetValue<SpatialTapGesture.Value>) {
        if let idComponent = value.entity.components[IdentifiableComponent.self] {
            debugPrint("Tapped Entity ID: \(idComponent.id)")
            self.appState.cleanerDetail(modelName: idComponent.id)
            self.openWindow(id: ViewIDs.cleanerDetailView, value: idComponent.id)
        }
    }
    
    @MainActor
    public func onDismiss(entity: Entity) {
        self.appState.returnToTemplateFromSubTemplate(entity: entity)
    }
}
