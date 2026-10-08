//
//  CourseProgressCalculatorTests.swift
//  MeetMindTests
//
//  Created by Sonam Omar on 06/08/26.
//

import XCTest
@testable import MeetMind

final class CourseProgressCalculatorTests: XCTestCase {
    
    func testCalculateProgress_WithEmptyLessons_ReturnsFallbackProgress() {
        let emptyLessons: [Lesson] = []
        let progress = CourseProgressCalculator.calculateProgress(lessons: emptyLessons, fallbackProgress: 65)
        XCTAssertEqual(progress, 65)
    }
    
    func testCalculateProgress_WithHalfCompletedLessons_Returns50Percent() {
        let lessons = [
            Lesson(id: "1", courseId: 1, title: "L1", isCompleted: true),
            Lesson(id: "2", courseId: 1, title: "L2", isCompleted: true),
            Lesson(id: "3", courseId: 1, title: "L3", isCompleted: false),
            Lesson(id: "4", courseId: 1, title: "L4", isCompleted: false)
        ]
        let progress = CourseProgressCalculator.calculateProgress(lessons: lessons)
        XCTAssertEqual(progress, 50)
    }
    
    func testCalculateProgress_WithAllCompletedLessons_Returns100Percent() {
        let lessons = [
            Lesson(id: "1", courseId: 1, title: "L1", isCompleted: true),
            Lesson(id: "2", courseId: 1, title: "L2", isCompleted: true)
        ]
        let progress = CourseProgressCalculator.calculateProgress(lessons: lessons)
        XCTAssertEqual(progress, 100)
    }
    
    func testCalculateProgress_WithNoCompletedLessons_Returns0Percent() {
        let lessons = [
            Lesson(id: "1", courseId: 1, title: "L1", isCompleted: false),
            Lesson(id: "2", courseId: 1, title: "L2", isCompleted: false)
        ]
        let progress = CourseProgressCalculator.calculateProgress(lessons: lessons)
        XCTAssertEqual(progress, 0)
    }
}
