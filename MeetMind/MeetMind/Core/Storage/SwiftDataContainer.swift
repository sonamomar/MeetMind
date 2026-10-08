//
//  SwiftDataContainer.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import Foundation
import SwiftData

/// Wrapper managing SwiftData container initialization for production and testing environments.
public final class SwiftDataContainer: @unchecked Sendable {
    public static let shared = SwiftDataContainer()
    
    public let container: ModelContainer
    
    public init(inMemory: Bool = false) {
        let schema = Schema([
            Item.self,
            SDCourse.self,
            SDLesson.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)
        
        do {
            self.container = try ModelContainer(for: schema, configurations: [config])
            AppLogger.info("SwiftData Container initialized (inMemory: \(inMemory))", category: AppLogger.database)
        } catch {
            AppLogger.error("Failed to initialize SwiftData Container", error: error, category: AppLogger.database)
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
