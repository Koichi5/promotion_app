//
//  CleanerView.swift
//  PromotionApp
//
//  Created by Koichi Kishimoto on 2024/05/18.
//

import SwiftUI
import RealityKit

struct CleanerView: View {
    @Environment(AppState.self) var appState
    @Environment(\.openWindow) internal var openWindow
    @State private var isDetailShown = false
    
    enum AttachmentIDs: Int {
        case edit = 100
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            if (!isDetailShown) {
                VStack(alignment: .leading) {
                    Text("Robot Cleaner")
                        .font(.title)
                        .padding()
                    Text("Introducing the SmartClean 3000 Robot Vacuum - \n Your ultimate home cleaning companion. Equipped with advanced sensors and powerful suction, it effortlessly navigates around obstacles, ensuring every corner is spotless. The SmartClean 3000 offers customizable cleaning schedules, allowing you to set and forget. Upgrade your cleaning experience today!")
                        .padding()
                    Button("Show Detail") {
                        isDetailShown = true
                    }
                    .padding()
                }
                .padding(20)
                .glassBackgroundEffect()
                .offset(y: -70)
            }
            Spacer()
            RealityView { content, attachments in
                content.add(appState.root)
            } update: { content, attachments in
                if isDetailShown {
                    animateEntity(entityName: "back_left_wheel", position: SIMD3<Float>(-0.15, -0.1, 0), rotation: simd_quatf(angle: .pi / 2, axis: SIMD3<Float>(0, -1, 0)), duration: 3.0)
                    animateEntity(entityName: "back_right_wheel", position: SIMD3<Float>(0.15, -0.1, 0), rotation: simd_quatf(angle: .pi / 2, axis: SIMD3<Float>(0, -1, 0)), duration: 3.0)
                    animateEntity(entityName: "body", position: SIMD3<Float>(0, -0.2, 0), rotation: simd_quatf(angle: .pi / 2, axis: SIMD3<Float>(0, -1, 0)), duration: 3.0)
                    animateEntity(entityName: "brush", position: SIMD3<Float>(0.15, 0.28, 0), rotation: simd_quatf(angle: .pi / 2, axis: SIMD3<Float>(1, 0, 0)), duration: 3.0)
                    animateEntity(entityName: "bumper", position: SIMD3<Float>(0, -0.05, 0), rotation: simd_quatf(angle: .pi / 2, axis: SIMD3<Float>(0, -1, 0)), duration: 3.0)
                    animateEntity(entityName: "dust_box", position: SIMD3<Float>(0, 0.1, 0), rotation: simd_quatf(angle: .pi / 2, axis: SIMD3<Float>(0, 1, 0)), duration: 3.0)
                    animateEntity(entityName: "filter", position: SIMD3<Float>(-0.25, 0.1, 0), rotation: simd_quatf(angle: .pi / 2, axis: SIMD3<Float>(0, 1, 0)), duration: 3.0)
                    animateEntity(entityName: "front_wheel", position: SIMD3<Float>(0.15, -0.3, -0.15), rotation: simd_quatf(angle: .pi / 2, axis: SIMD3<Float>(0, -1, 0)), duration: 3.0)
                    animateEntity(entityName: "lid", position: SIMD3<Float>(0, 0.2, 0), rotation: simd_quatf(angle: .pi / 2, axis: SIMD3<Float>(0, -1, 0)), duration: 3.0)
                    animateEntity(entityName: "main_brush", position: SIMD3<Float>(-0.15, -0.3, 0), rotation: simd_quatf(angle: .pi / 2, axis: SIMD3<Float>(0, 1, 0)), duration: 3.0)
                    
//                    for model in cleanerModelList {
//                        if let entity = appState.root.findEntity(with: model.modelName) {
//                            if let attachment = attachments.entity(for: model.modelName) {
//                                content.add(attachment)
//                                // ワールド座標系でエンティティの位置を取得
////                                let worldPosition = entity.convert(position: entity.position, to: nil)
//                                // アタッチメントをエンティティの位置に移動（回転は無視）
//                                var transform = entity.transform
//                                transform.translation = entity.position
//                                attachment.move(to: transform, relativeTo: entity.parent, duration: 3)
//                            }
//                        }
//                    }
                }
            }
        attachments: {
            if (isDetailShown) {
                Attachment(id: AttachmentIDs.edit) {
                    Button("Close") {
                        isDetailShown = false
                    }
                }
                ForEach(cleanerPartsModelList, id: \.modelName) { model in
                    Attachment(id: model.modelName) {
                        Text(model.displayName)
                            .padding()
                            .cornerRadius(5)
                            .shadow(radius: 2)
                            .glassBackgroundEffect()
                    }
                }
            }
        }
        .gesture(SpatialTapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                self.onEntityTap(value: value)
            })
            Spacer()
        }
    }
    
    @MainActor func animateEntity(entityName: String, position newPosition: SIMD3<Float>, rotation newRotation: simd_quatf, duration: TimeInterval) {
        if let entity = appState.root.findEntity(with: entityName) {
            var transform = entity.transform
            
            transform.translation = newPosition
            transform.rotation = newRotation
            
            entity.move(to: transform, relativeTo: entity.parent, duration: duration, timingFunction: .easeInOut)
        }
    }
}

extension Entity {
    func findEntity(with modelName: String) -> Entity? {
        for child in self.children {
            if let identifiable = child.components[IdentifiableComponent.self], identifiable.id == modelName {
                return child
            }
            if let found = child.findEntity(with: modelName) {
                return found
            }
        }
        return nil
    }
}

#Preview {
    CleanerView()
}


