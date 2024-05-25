//
//  AppPhase.swift
//  PromotionApp
//
//  Created by Koichi Kishimoto on 2024/05/18.
//

import SwiftUI
import OSLog

public enum AppPhase: String, Codable, Sendable, Equatable, Hashable, CaseIterable {
    case startingUp
    case loadingAssets
    case waitingToStart
    case home
    case cleanerDetail
    
    var isImmersrd: Bool {
        switch self {
        case .startingUp, .loadingAssets, .waitingToStart:
            return false
        case .home, .cleanerDetail:
            return true
        }
    }
    
    @discardableResult
    mutating public func transition(to newPhase: AppPhase) -> Bool {
        logger.info("Phase change to \(newPhase.rawValue)")
        guard self != newPhase else {
            logger.debug("Attempting to change phase to \(newPhase.rawValue) but already in that state. Trating as a no-op")
            return false
        }
        self = newPhase
        return true
    }
}

let logger = Logger()
