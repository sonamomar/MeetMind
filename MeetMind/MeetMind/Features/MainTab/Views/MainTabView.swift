//
//  MainTabView.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import SwiftUI
import SwiftData

public struct MainTabView: View {
    @Bindable var router: AppRouter
    @Bindable var appState: AppState
    @Environment(\.dependencies) private var dependencies
    
    public init(router: AppRouter, appState: AppState) {
        self.router = router
        self.appState = appState
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            if !appState.isAuthenticated {
                LoginView(
                    authService: dependencies.authService,
                    appState: appState,
                    router: router
                )
                .transition(.opacity.combined(with: .scale))
            } else {
                NavigationStack(path: $router.path) {
                    CourseDashboardView(
                        repository: dependencies.courseRepository,
                        router: router,
                        appState: appState
                    )
                    .navigationDestination(for: AppDestination.self) { destination in
                        switch destination {
                        case .courseDetail(let course):
                            CourseDetailView(
                                course: course,
                                repository: dependencies.courseRepository,
                                router: router
                            )
                        }
                    }
                }
                .transition(.opacity)
            }
            
            // Global Toast Overlay
            if let toastMessage = router.toastMessage {
                ToastView(message: toastMessage)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.bottom, 60)
                    .animation(.easeInOut, value: router.toastMessage)
            }
        }
        .animation(.default, value: appState.isAuthenticated)
    }
}

#Preview {
    MainTabView(router: AppRouter(), appState: AppState(isAuthenticated: true, currentUser: User.sample))
        .environment(\.dependencies, .mock)
        .modelContainer(for: SDCourse.self, inMemory: true)
}
