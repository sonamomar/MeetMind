//
//  LoginViewModelTests.swift
//  MeetMindTests
//
//  Created by Sonam Omar on 06/08/26.
//

import XCTest
@testable import MeetMind

final class LoginViewModelTests: XCTestCase {
    
    var mockAuthService: MockAuthService!
    var appState: AppState!
    var router: AppRouter!
    var viewModel: LoginViewModel!
    
    @MainActor
    override func setUp() {
        super.setUp()
        mockAuthService = MockAuthService()
        appState = AppState()
        router = AppRouter()
        viewModel = LoginViewModel(authService: mockAuthService, appState: appState, router: router)
    }
    
    @MainActor
    func testValidation_WithInvalidEmail_ShowsEmailError() {
        viewModel.email = "invalid-email"
        viewModel.password = "password123"
        
        XCTAssertNotNil(viewModel.emailError)
        XCTAssertFalse(viewModel.isValid)
    }
    
    @MainActor
    func testValidation_WithShortPassword_ShowsPasswordError() {
        viewModel.email = "test@example.com"
        viewModel.password = "123"
        
        XCTAssertNotNil(viewModel.passwordError)
        XCTAssertFalse(viewModel.isValid)
    }
    
    @MainActor
    func testValidation_WithValidInputs_SetIsValidTrue() {
        viewModel.email = "test@example.com"
        viewModel.password = "secret123"
        
        XCTAssertNil(viewModel.emailError)
        XCTAssertNil(viewModel.passwordError)
        XCTAssertTrue(viewModel.isValid)
    }
    
    @MainActor
    func testLogin_Success_UpdatesAppStateAndNavigates() async {
        viewModel.email = "test@example.com"
        viewModel.password = "secret123"
        mockAuthService.shouldSucceed = true
        
        await viewModel.login()
        
        XCTAssertTrue(appState.isAuthenticated)
        XCTAssertNotNil(appState.currentUser)
        XCTAssertNil(viewModel.generalError)
    }
    
    @MainActor
    func testLogin_Failure_SetsGeneralError() async {
        viewModel.email = "test@example.com"
        viewModel.password = "secret123"
        mockAuthService.shouldSucceed = false
        
        await viewModel.login()
        
        XCTAssertFalse(appState.isAuthenticated)
        XCTAssertNotNil(viewModel.generalError)
    }
}
