//
//  ModelIdentifier.swift
//  PromotionApp
//
//  Created by Koichi Kishimoto on 2024/05/18.
//

import Foundation

public struct ModelIdentifier: Identifiable {
    public var id: UUID
    var modelName: String
    var displayName: String
    
    init(modelName: String, displayName: String) {
        self.modelName = modelName
        self.displayName = displayName
        self.id = UUID()
    }
}
