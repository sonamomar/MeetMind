//
//  Course.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import Foundation

/// Represents a single lesson in a course.
public struct Lesson: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public let courseId: Int
    public let title: String
    public var isCompleted: Bool
    public let order: Int
    
    public init(id: String = UUID().uuidString, courseId: Int, title: String, isCompleted: Bool = false, order: Int = 0) {
        self.id = id
        self.courseId = courseId
        self.title = title
        self.isCompleted = isCompleted
        self.order = order
    }
}

/// Represents a course in the Learning Dashboard.
public struct Course: Identifiable, Codable, Hashable, Sendable {
    public let id: Int
    public let title: String
    public let instructor: String
    public var progress: Int
    public let lessonsCount: Int
    public var lessons: [Lesson]
    
    public init(id: Int, title: String, instructor: String, progress: Int, lessonsCount: Int, lessons: [Lesson] = []) {
        self.id = id
        self.title = title
        self.instructor = instructor
        self.progress = progress
        self.lessonsCount = lessonsCount
        self.lessons = lessons
    }
    
    /// Dynamically calculated progress based on completed lessons count
    public var calculatedProgress: Int {
        CourseProgressCalculator.calculateProgress(lessons: lessons, fallbackProgress: progress)
    }
}

/// Business logic helper for course progress calculations.
public enum CourseProgressCalculator {
    /// Calculates progress percentage (0 - 100) based on completed lessons.
    /// If no detailed lessons exist, returns fallback stored progress.
    public static func calculateProgress(lessons: [Lesson], fallbackProgress: Int = 0) -> Int {
        guard !lessons.isEmpty else { return max(0, min(100, fallbackProgress)) }
        let completedCount = lessons.filter { $0.isCompleted }.count
        let percentage = Double(completedCount) / Double(lessons.count) * 100.0
        return Int(round(percentage))
    }
}
