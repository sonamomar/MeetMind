//
//  CourseDashboardView.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import SwiftUI

public struct CourseDashboardView: View {
    @State private var viewModel: CourseDashboardViewModel
    @Bindable var router: AppRouter
    @Bindable var appState: AppState
    
    public init(repository: CourseRepositoryProtocol, router: AppRouter, appState: AppState) {
        _viewModel = State(initialValue: CourseDashboardViewModel(repository: repository, router: router))
        self.router = router
        self.appState = appState
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Offline Simulator Banner
            HStack {
                Image(systemName: viewModel.isSimulatingOffline ? "wifi.slash" : "wifi")
                    .foregroundColor(viewModel.isSimulatingOffline ? .orange : .green)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(viewModel.isSimulatingOffline ? "Offline Mode (Simulated Cache)" : "Online Mode")
                        .font(AppTypography.captionBold)
                        .foregroundColor(AppColors.textPrimary)
                    Text(viewModel.isSimulatingOffline ? "Data loaded from SwiftData local database." : "Connected to remote course API.")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                Toggle("", isOn: $viewModel.isSimulatingOffline)
                    .labelsHidden()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(viewModel.isSimulatingOffline ? Color.orange.opacity(0.12) : Color.green.opacity(0.08))
            
            // Content Body based on View State
            Group {
                switch viewModel.state {
                case .loading:
                    LoadingView(message: "Loading your dashboard courses...")
                        .frame(maxHeight: .infinity, alignment: .center)
                    
                case .empty:
                    EmptyStateView(
                        title: "No Courses Found",
                        description: "There are no learning courses available at this moment.",
                        actionTitle: "Refresh Dashboard",
                        action: {
                            Task { await viewModel.loadCourses(forceRefresh: true) }
                        }
                    )
                    .frame(maxHeight: .infinity, alignment: .center)
                    
                case .error(let message):
                    ErrorView(
                        message: message,
                        retryAction: {
                            Task { await viewModel.loadCourses(forceRefresh: true) }
                        }
                    )
                    .frame(maxHeight: .infinity, alignment: .center)
                    
                case .success:
                    courseContentList
                        .frame(maxHeight: .infinity, alignment: .top)
                case .idle:
                    ProgressView()
                        .frame(maxHeight: .infinity, alignment: .top)
                }
            }
            
        }
        .navigationTitle("Learning Dashboard")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    Task {
                        appState.isAuthenticated = false
                        appState.currentUser = nil
                        router.showToast("Signed out successfully.")
                    }
                }) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(.red)
                }
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Search courses or instructors")
        .task {
            if viewModel.state == .idle {
                await viewModel.loadCourses()
            }
        }
    }
    
    private var courseContentList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if viewModel.filteredCourses.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 40))
                            .foregroundColor(AppColors.textSecondary)
                        Text("No courses match '\(viewModel.searchText)'")
                            .font(AppTypography.bodyBold)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .padding(.top, 40)
                } else {
                    ForEach(viewModel.filteredCourses) { course in
                        CourseCard(
                            course: course,
                            onContinueTap: {
                                viewModel.selectCourse(course)
                            }
                        )
                    }
                }
            }
            .padding(16)
        }
        .refreshable {
            await viewModel.loadCourses(forceRefresh: true)
        }
    }
}

#Preview {
    NavigationStack {
        CourseDashboardView(
            repository: MockCourseRepository(),
            router: AppRouter(),
            appState: AppState(isAuthenticated: true, currentUser: User.sample)
        )
    }
}
