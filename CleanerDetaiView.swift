//
//  CleanerDetaiView.swift
//  PromotionApp
//
//  Created by Koichi Kishimoto on 2024/05/19.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct CleanerDetaiView: View {
    let modelName: String
    @Environment(AppState.self) var appState
    @State private var model: CleanerPartsModel?
    var body: some View {
        HStack {
            VStack {
                Text(modelName)
                RealityView { content, attachments in
                    content.add(appState.subRoot)
                } attachments: {
                    Attachment(id: "") {
                        Button("Close") {}
                    }
                }
            }
        }
        .onAppear {
            model = cleanerPartsModelList.first(where: { cleanerModel in
                cleanerModel.modelName == modelName
            })
        }
        .onDisappear {
            appState.returnToTemplateFromSubTemplate(entity: appState.subRoot)
            appState.cleanCleanerEntities()
        }
    }
}
