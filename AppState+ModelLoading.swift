//
//  AppState+ModelLoading.swift
//  PromotionApp
//
//  Created by Koichi Kishimoto on 2024/05/18.
//

import Foundation
import RealityKit
import RealityKitContent

actor EntityContainer {
    var entity: Entity?
    func setEntity(newEntity: Entity?) {
        entity = newEntity
    }
}

struct LoadResult: Sendable {
    var entity: Entity
    var key: String
}

extension AppState {
    private func loadFromRCPro(named entityName: String, fromSceneNamed sceneName: String, scaleFactor: Float? = nil) async throws -> Entity? {
        var ret: Entity? = nil
        logger.info("Loading entity \(entityName) from Reality Composer Pro scene \(sceneName)")
        do {
            let scene = try await Entity(named: sceneName, in: realityKitContentBundle)
            let entityContainer = EntityContainer()
            let entity = scene.findEntity(named: entityName)
            if let scaleFactor = scaleFactor {
                entity?.scale = SIMD3<Float>(repeating: scaleFactor)
            }
            await entityContainer.setEntity(newEntity: entity)
            ret = await entityContainer.entity
        } catch {
            fatalError("Encountered fatal error: \(error.localizedDescription)")
        }
        return ret
    }
    
    public func loadModels() async {
        defer {
            finishedLoadingAssets()
        }
        _ = Date.timeIntervalSinceReferenceDate
        logger.info("Starting load from Reality Composer Pro Project.")
        finishedStartingUp()
        
        await withTaskGroup(of: LoadResult.self) { taskGroup in
            loadCleanerModels(taskGroup: &taskGroup)
            for await result in taskGroup {
                if cleanerPartsModelList.first(where: { $0.modelName == result.key }) != nil {
                    addCleanerEntitiesToState(result: result)
                }
            }
        }
    }
    
    // return loaded entity from reality composer pro
    public func loadedEntity(modelName: String, sceneName: String) async throws -> Entity? {
        return try await self.loadFromRCPro(named: modelName, fromSceneNamed: sceneName)
    }
    
    private func loadCleanerModels(taskGroup: inout TaskGroup<LoadResult>) {
        logger.info("Loading cleaner models")
        for cleanerModel in cleanerPartsModelList {
            taskGroup.addTask {
                do {
                    guard let cleanerEntity = try await self.loadFromRCPro(named: cleanerModel.modelName, fromSceneNamed: cleanerSceneName, scaleFactor: 1.0) else {
                        fatalError("Attempted to load piece entity \(cleanerModel.modelName) but failed.")
                    }
                    await self.setImageBasedLishtForEntity(entity: cleanerEntity, intensityExponent: 0.8)
                    await self.setModelTappable(entity: cleanerEntity)
                    await self.setIdentifiableComponent(entity: cleanerEntity, id: cleanerModel.modelName, displayName: cleanerModel.displayName)
                    return LoadResult(entity: cleanerEntity, key: cleanerModel.modelName)
                } catch {
                    fatalError("Attempted to load \(cleanerModel.modelName)")
                }
            }
        }
    }
    
    private func setIdentifiableComponent(entity: Entity, id: String, displayName: String)  {
        let identifiableComponent = IdentifiableComponent(
            id: id, displayName: displayName)
        entity.components.set(identifiableComponent)
    }
    
    private func addCleanerEntitiesToState(result: LoadResult) {
        self.addToTemplate(template: result.entity)
    }
    
    public func addCleanerEntitiesToRoot() {
        for cleanerEntity in cleanerEntityTemplates {
            root.addChild(cleanerEntity)
        }
    }
    
    public func addCleanerEntitiesToSubState(entityName: String) {
        guard let entity = findEntityFromTemplates(entityName: entityName) else {
            fatalError("Attempted to find \(entityName)")
        }
        self.preEntityPosition = addToSubTemplate(entity: entity)
    }
    
    public func addCleanerEntitiesToSubRoot() {
        subRoot.addChild(cleanerEntitySubTemplate)
    }
    
    public func cleanCleanerEntities() {
        self.cleanerEntitySubTemplate = Entity()
        subRoot = Entity()
    }
    
    public func findEntityFromTemplates(entityName: String) -> Entity? {
        return self.cleanerEntityTemplates.first(where: { $0.name == entityName })
    }
    
    // set entity lighting
    @MainActor
    private func setImageBasedLishtForEntity(entity: Entity, intensityExponent: Float) async {
        guard let env = try? await EnvironmentResource( named: "ImageBasedLight") else { return }
        
        let iblComponent = ImageBasedLightComponent(source: .single(env), intensityExponent: intensityExponent)
        
        entity.components[ImageBasedLightComponent.self] = iblComponent
        entity.components.set(ImageBasedLightReceiverComponent(imageBasedLight: entity))
    }
    
    @MainActor
    private func setModelTappable(entity: Entity) async {
        entity.components[CollisionComponent.self] = CollisionComponent(shapes: [.generateBox(size: [0.1, 0.1, 0.1])], mode: .trigger, filter: .sensor)
        entity.components[InputTargetComponent.self] = InputTargetComponent()
    }
}

public var cleanerPartsModelList = [
    CleanerPartsModel(modelName: "back_left_wheel", displayName: "Back Left Wheel", description: ""),
    CleanerPartsModel(modelName: "back_right_wheel", displayName: "Back Right Wheel", description: ""),
    CleanerPartsModel(modelName: "body", displayName: "Body", description: ""),
    CleanerPartsModel(modelName: "brush", displayName: "Brush", description: ""),
    CleanerPartsModel(modelName: "bumper", displayName: "Bumper", description: ""),
    CleanerPartsModel(modelName: "dust_box", displayName: "Dust Box", description: ""),
    CleanerPartsModel(modelName: "filter", displayName: "Filter", description: ""),
    CleanerPartsModel(modelName: "front_wheel", displayName: "Front Wheel", description: ""),
    CleanerPartsModel(modelName: "lid", displayName: "Lid", description: ""),
    CleanerPartsModel(modelName: "main_brush", displayName: "Main Brush", description: "")
]

public var cleanerSceneName = "CleanerScene"


