//
//  CourseAPIServiceProtocol.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import Foundation

public protocol CourseAPIServiceProtocol: Sendable {
    func fetchCourses() async throws -> [Course]
}
