//
//  CourseRepositoryProtocol.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import Foundation

public protocol CourseRepositoryProtocol: Sendable {
    func fetchCourses(forceRefresh: Bool) async throws -> [Course]
    func toggleLessonCompletion(courseId: Int, lessonId: String) async throws -> Course
    func getLocalCachedCourses() async -> [Course]
}
