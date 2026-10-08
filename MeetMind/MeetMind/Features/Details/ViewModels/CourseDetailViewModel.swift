//
//  CourseDetailViewModel.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import Foundation
import SwiftUI

@Observable
public final class CourseDetailViewModel {
    public var course: Course
    public var isUpdating: Bool = false
    public var errorMessage: String?
    
    private let repository: CourseRepositoryProtocol
    private let router: AppRouter
    
    public init(course: Course, repository: CourseRepositoryProtocol, router: AppRouter) {
        self.course = course
        self.repository = repository
        self.router = router
    }
    
    public var completedLessonsCount: Int {
        course.lessons.filter { $0.isCompleted }.count
    }
    
    public var totalLessonsCount: Int {
        course.lessons.count
    }
    
    @MainActor
    public func toggleLesson(_ lesson: Lesson) async {
        isUpdating = true
        errorMessage = nil
        
        do {
            let updatedCourse = try await repository.toggleLessonCompletion(courseId: course.id, lessonId: lesson.id)
            self.course = updatedCourse
            self.isUpdating = false
            
            let statusText = course.lessons.first(where: { $0.id == lesson.id })?.isCompleted == true ? "completed" : "pending"
            router.showToast("Lesson '\(lesson.title)' marked as \(statusText). Progress: \(course.calculatedProgress)%")
        } catch {
            self.isUpdating = false
            self.errorMessage = error.localizedDescription
            AppLogger.error("Failed to update lesson completion state", error: error, category: AppLogger.database)
        }
    }
}
