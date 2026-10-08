//
//  LoginViewModel.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import Foundation
import SwiftUI

@Observable
public final class LoginViewModel {
    public var email: String = "" {
        didSet { validateInputs() }
    }
    public var password: String = "" {
        didSet { validateInputs() }
    }
    
    public var emailError: String?
    public var passwordError: String?
    public var generalError: String?
    public var isLoading: Bool = false
    public var isValid: Bool = false
    
    private let authService: AuthServiceProtocol
    private let appState: AppState
    private let router: AppRouter
    
    public init(authService: AuthServiceProtocol, appState: AppState, router: AppRouter) {
        self.authService = authService
        self.appState = appState
        self.router = router
    }
    
    public func validateInputs() {
        // Validate Email
        if email.isEmpty {
            emailError = nil
        } else if !email.isValidEmail() {
            emailError = "Please enter a valid email address."
        } else {
            emailError = nil
        }
        
        // Validate Password
        if password.isEmpty {
            passwordError = nil
        } else if password.count < 6 {
            passwordError = "Password must be at least 6 characters."
        } else {
            passwordError = nil
        }
        
        isValid = email.isValidEmail() && password.count >= 6
    }
    
    @MainActor
    public func login() async {
        guard isValid else { return }
        
        isLoading = true
        generalError = nil
        
        do {
            let user = try await authService.login(email: email, password: password)
            isLoading = false
            appState.currentUser = user
            appState.isAuthenticated = true
            router.showToast("Welcome back, \(user.name)!")
        } catch {
            isLoading = false
            generalError = error.localizedDescription
            AppLogger.error("Login failed in LoginViewModel", error: error, category: AppLogger.auth)
        }
    }
}
