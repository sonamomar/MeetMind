//
//  CourseDashboardViewModel.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import Foundation
import SwiftUI

public enum DashboardViewState: Equatable {
    case idle
    case loading
    case success([Course])
    case empty
    case error(String)
}

@Observable
public final class CourseDashboardViewModel {
    public var state: DashboardViewState = .idle
    public var searchText: String = ""
    public var isSimulatingOffline: Bool = false {
        didSet {
            NetworkMonitor.shared.isSimulatedOffline = isSimulatingOffline
            Task { @MainActor in
                await loadCourses(forceRefresh: true)
            }
        }
    }
    
    private let repository: CourseRepositoryProtocol
    private let router: AppRouter
    
    public init(repository: CourseRepositoryProtocol, router: AppRouter) {
        self.repository = repository
        self.router = router
    }
    
    public var filteredCourses: [Course] {
        guard case .success(let courses) = state else { return [] }
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return courses
        }
        return courses.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.instructor.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    @MainActor
    public func loadCourses(forceRefresh: Bool = false) async {
        state = .loading
        
        do {
            let courses = try await repository.fetchCourses(forceRefresh: forceRefresh)
            if courses.isEmpty {
                state = .empty
            } else {
                state = .success(courses)
            }
        } catch {
            AppLogger.error("Failed to load courses in CourseDashboardViewModel", error: error, category: AppLogger.network)
            state = .error(error.localizedDescription)
        }
    }
    
    public func selectCourse(_ course: Course) {
        router.navigate(to: .courseDetail(course: course))
    }
}
