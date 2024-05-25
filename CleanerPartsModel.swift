//
//  CleanerModel.swift
//  PromotionApp
//
//  Created by Koichi Kishimoto on 2024/05/19.
//

import Foundation

public struct CleanerPartsModel: Identifiable {
    public var id: UUID
    var modelName: String
    var displayName: String
    var description: String
    
    init(modelName: String, displayName: String, description: String) {
        self.id = UUID()
        self.modelName = modelName
        self.displayName = displayName
        self.description = description
    }
}
