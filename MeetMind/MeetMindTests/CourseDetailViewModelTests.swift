//
//  CourseDetailViewModelTests.swift
//  MeetMindTests
//
//  Created by Sonam Omar on 06/08/26.
//

import XCTest
@testable import MeetMind

final class CourseDetailViewModelTests: XCTestCase {
    
    var mockRepository: MockCourseRepository!
    var router: AppRouter!
    var viewModel: CourseDetailViewModel!
    
    @MainActor
    override func setUp() {
        super.setUp()
        let sampleCourse = CourseAPIService.sampleCourses.first!
        mockRepository = MockCourseRepository(courses: [sampleCourse])
        router = AppRouter()
        viewModel = CourseDetailViewModel(course: sampleCourse, repository: mockRepository, router: router)
    }
    
    @MainActor
    func testToggleLesson_UpdatesCompletionAndRecalculatesProgress() async {
        let initialProgress = viewModel.course.calculatedProgress
        let pendingLesson = viewModel.course.lessons.first(where: { !$0.isCompleted })!
        
        await viewModel.toggleLesson(pendingLesson)
        
        XCTAssertGreaterThan(viewModel.course.calculatedProgress, initialProgress)
        let updatedLesson = viewModel.course.lessons.first(where: { $0.id == pendingLesson.id })
        XCTAssertTrue(updatedLesson?.isCompleted == true)
    }
}
