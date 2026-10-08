//
//  CourseDashboardViewModelTests.swift
//  MeetMindTests
//
//  Created by Sonam Omar on 06/08/26.
//

import XCTest
@testable import MeetMind

final class CourseDashboardViewModelTests: XCTestCase {
    
    var mockRepository: MockCourseRepository!
    var router: AppRouter!
    var viewModel: CourseDashboardViewModel!
    
    @MainActor
    override func setUp() {
        super.setUp()
        mockRepository = MockCourseRepository()
        router = AppRouter()
        viewModel = CourseDashboardViewModel(repository: mockRepository, router: router)
    }
    
    @MainActor
    func testLoadCourses_Success_SetsSuccessState() async {
        await viewModel.loadCourses()
        
        if case .success(let courses) = viewModel.state {
            XCTAssertEqual(courses.count, 3)
            XCTAssertEqual(courses.first?.title, "Python Programming")
        } else {
            XCTFail("Expected .success state, got \(viewModel.state)")
        }
    }
    
    @MainActor
    func testLoadCourses_Empty_SetsEmptyState() async {
        mockRepository.courses = []
        await viewModel.loadCourses()
        
        XCTAssertEqual(viewModel.state, .empty)
    }
    
    @MainActor
    func testLoadCourses_Failure_SetsErrorState() async {
        mockRepository.shouldFail = true
        await viewModel.loadCourses()
        
        if case .error(let message) = viewModel.state {
            XCTAssertFalse(message.isEmpty)
        } else {
            XCTFail("Expected .error state, got \(viewModel.state)")
        }
    }
    
    @MainActor
    func testFiltering_BySearchText_FiltersCoursesCorrectly() async {
        await viewModel.loadCourses()
        viewModel.searchText = "Python"
        
        XCTAssertEqual(viewModel.filteredCourses.count, 1)
        XCTAssertEqual(viewModel.filteredCourses.first?.title, "Python Programming")
    }
}
