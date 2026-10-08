//
//  CourseAPIService.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import Foundation

public final class CourseAPIService: CourseAPIServiceProtocol, @unchecked Sendable {
    public var shouldSimulateError: Bool = false
    public var simulatedDelayNanoseconds: UInt64 = 600_000_000
    
    public init() {}
    
    public func fetchCourses() async throws -> [Course] {
        if simulatedDelayNanoseconds > 0 {
            try await Task.sleep(nanoseconds: simulatedDelayNanoseconds)
        }
        
        if shouldSimulateError || !NetworkMonitor.shared.isEffectiveConnected {
            throw NetworkError.serverError(message: "Network request failed. Unable to reach Course API.")
        }
        
        return CourseAPIService.sampleCourses
    }
    
    public static var sampleCourses: [Course] {
        [
            Course(
                id: 1,
                title: "Python Programming",
                instructor: "John Smith",
                progress: 50, // 2 out of 4 lessons completed = 50%
                lessonsCount: 20,
                lessons: [
                    Lesson(id: "py_1", courseId: 1, title: "Introduction", isCompleted: true, order: 1),
                    Lesson(id: "py_2", courseId: 1, title: "Variables & Data Types", isCompleted: true, order: 2),
                    Lesson(id: "py_3", courseId: 1, title: "Functions", isCompleted: false, order: 3),
                    Lesson(id: "py_4", courseId: 1, title: "OOP", isCompleted: false, order: 4)
                ]
            ),
            Course(
                id: 2,
                title: "Generative AI",
                instructor: "Sarah Williams",
                progress: 40,
                lessonsCount: 16,
                lessons: [
                    Lesson(id: "ai_1", courseId: 2, title: "Prompt Engineering Basics", isCompleted: true, order: 1),
                    Lesson(id: "ai_2", courseId: 2, title: "Transformer Architecture", isCompleted: true, order: 2),
                    Lesson(id: "ai_3", courseId: 2, title: "Fine-Tuning Models", isCompleted: false, order: 3),
                    Lesson(id: "ai_4", courseId: 2, title: "RAG & Vector Databases", isCompleted: false, order: 4),
                    Lesson(id: "ai_5", courseId: 2, title: "AI Agent Orchestration", isCompleted: false, order: 5)
                ]
            ),
            Course(
                id: 3,
                title: "Full Stack Development",
                instructor: "David Brown",
                progress: 25,
                lessonsCount: 28,
                lessons: [
                    Lesson(id: "fs_1", courseId: 3, title: "HTML5 & CSS Grid Layouts", isCompleted: true, order: 1),
                    Lesson(id: "fs_2", courseId: 3, title: "TypeScript Core Concepts", isCompleted: false, order: 2),
                    Lesson(id: "fs_3", courseId: 3, title: "REST & GraphQL APIs", isCompleted: false, order: 3),
                    Lesson(id: "fs_4", courseId: 3, title: "PostgreSQL & Database Design", isCompleted: false, order: 4)
                ]
            )
        ]
    }
}

public final class MockCourseAPIService: CourseAPIServiceProtocol, @unchecked Sendable {
    public var result: Result<[Course], Error> = .success(CourseAPIService.sampleCourses)
    
    public init(result: Result<[Course], Error> = .success(CourseAPIService.sampleCourses)) {
        self.result = result
    }
    
    public func fetchCourses() async throws -> [Course] {
        switch result {
        case .success(let courses):
            return courses
        case .failure(let error):
            throw error
        }
    }
}
