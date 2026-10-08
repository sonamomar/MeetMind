//
//  CourseRepository.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import Foundation
import SwiftData

public final class CourseRepository: CourseRepositoryProtocol, @unchecked Sendable {
    private let apiService: CourseAPIServiceProtocol
    private let modelContainer: ModelContainer
    
    public init(
        apiService: CourseAPIServiceProtocol = CourseAPIService(),
        modelContainer: ModelContainer = SwiftDataContainer.shared.container
    ) {
        self.apiService = apiService
        self.modelContainer = modelContainer
    }
    
    @MainActor
    public func fetchCourses(forceRefresh: Bool = false) async throws -> [Course] {
        let context = modelContainer.mainContext
        let isOnline = NetworkMonitor.shared.isEffectiveConnected
        
        if isOnline {
            do {
                let remoteCourses = try await apiService.fetchCourses()
                try cacheCourses(remoteCourses, context: context)
                AppLogger.info("Fetched \(remoteCourses.count) courses from Remote API and updated local database.", category: AppLogger.database)
                return remoteCourses
            } catch {
                AppLogger.error("API Fetch failed. Attempting offline cache fallback.", error: error, category: AppLogger.network)
                let localCourses = fetchLocalCourses(context: context)
                if !localCourses.isEmpty {
                    return localCourses
                }
                throw error
            }
        } else {
            AppLogger.info("Offline mode active. Loading courses from local SwiftData cache.", category: AppLogger.database)
            let localCourses = fetchLocalCourses(context: context)
            if !localCourses.isEmpty {
                return localCourses
            }
            throw NetworkError.serverError(message: "No internet connection and no cached course data available.")
        }
    }
    
    @MainActor
    public func toggleLessonCompletion(courseId: Int, lessonId: String) async throws -> Course {
        let context = modelContainer.mainContext
        let fetchDescriptor = FetchDescriptor<SDCourse>(predicate: #Predicate { $0.id == courseId })
        
        guard let sdCourse = try context.fetch(fetchDescriptor).first else {
            throw NetworkError.serverError(message: "Course with ID \(courseId) not found in storage.")
        }
        
        if let sdLesson = sdCourse.lessons.first(where: { $0.id == lessonId }) {
            sdLesson.isCompleted.toggle()
        }
        
        // Re-calculate course progress dynamically
        let domainLessons = sdCourse.lessons.map { $0.toDomain() }
        let newProgress = CourseProgressCalculator.calculateProgress(lessons: domainLessons, fallbackProgress: sdCourse.progress)
        sdCourse.progress = newProgress
        
        try context.save()
        AppLogger.info("Updated lesson \(lessonId) completion. New progress: \(newProgress)%", category: AppLogger.database)
        
        return sdCourse.toDomain()
    }
    
    @MainActor
    public func getLocalCachedCourses() async -> [Course] {
        fetchLocalCourses(context: modelContainer.mainContext)
    }
    
    @MainActor
    private func fetchLocalCourses(context: ModelContext) -> [Course] {
        do {
            let descriptor = FetchDescriptor<SDCourse>(sortBy: [SortDescriptor(\.id)])
            let sdCourses = try context.fetch(descriptor)
            return sdCourses.map { $0.toDomain() }
        } catch {
            AppLogger.error("Failed to fetch local courses from SwiftData", error: error, category: AppLogger.database)
            return []
        }
    }
    
    @MainActor
    private func cacheCourses(_ courses: [Course], context: ModelContext) throws {
        // Clear existing courses to maintain single source of truth
        try context.delete(model: SDCourse.self)
        try context.delete(model: SDLesson.self)
        
        for course in courses {
            let sdCourse = SDCourse.fromDomain(course)
            context.insert(sdCourse)
        }
        try context.save()
    }
}

public final class MockCourseRepository: CourseRepositoryProtocol, @unchecked Sendable {
    public var courses: [Course]
    public var shouldFail: Bool = false
    
    public init(courses: [Course] = CourseAPIService.sampleCourses) {
        self.courses = courses
    }
    
    public func fetchCourses(forceRefresh: Bool) async throws -> [Course] {
        if shouldFail {
            throw NetworkError.serverError(message: "Mock repository failure")
        }
        return courses
    }
    
    public func toggleLessonCompletion(courseId: Int, lessonId: String) async throws -> Course {
        guard let index = courses.firstIndex(where: { $0.id == courseId }) else {
            throw NetworkError.serverError(message: "Course not found")
        }
        
        var course = courses[index]
        if let lessonIndex = course.lessons.firstIndex(where: { $0.id == lessonId }) {
            course.lessons[lessonIndex].isCompleted.toggle()
        }
        course.progress = CourseProgressCalculator.calculateProgress(lessons: course.lessons, fallbackProgress: course.progress)
        courses[index] = course
        return course
    }
    
    public func getLocalCachedCourses() async -> [Course] {
        courses
    }
}
