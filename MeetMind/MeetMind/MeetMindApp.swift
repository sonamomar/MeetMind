//
//  MeetMindApp.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import SwiftUI
import SwiftData

@main
struct MeetMindApp: App {
    @State private var appState = AppState()
    @State private var router = AppRouter()
    private let dependencies = DependencyContainer.shared
    private let databaseContainer = SwiftDataContainer.shared

    var body: some Scene {
        WindowGroup {
            MainTabView(router: router, appState: appState)
                .environment(\.dependencies, dependencies)
                .tint(AppColors.primary)
        }
        .modelContainer(databaseContainer.container)
    }
}
