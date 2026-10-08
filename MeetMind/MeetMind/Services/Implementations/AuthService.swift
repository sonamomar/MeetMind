//
//  AuthService.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import Foundation

public final class AuthService: AuthServiceProtocol, @unchecked Sendable {
    private let apiClient: APIClientProtocol
    private let storage: KeyValueStorageProtocol
    
    public init(apiClient: APIClientProtocol, storage: KeyValueStorageProtocol) {
        self.apiClient = apiClient
        self.storage = storage
    }
    
    public func login(email: String, password: String) async throws -> User {
        // Simulate network call
        try await Task.sleep(nanoseconds: 800_000_000)
        
        guard !email.isEmpty && password.count >= 6 else {
            throw NetworkError.serverError(message: "Invalid credentials. Password must be at least 6 characters.")
        }
        
        let user = User(id: UUID().uuidString, name: email.components(separatedBy: "@").first?.capitalized ?? "User", email: email)
        storage.set(user.id, forKey: "current_user_id")
        return user
    }
    
    public func logout() async throws {
        storage.remove(forKey: "current_user_id")
    }
    
    public func getCurrentUser() async -> User? {
        if storage.string(forKey: "current_user_id") != nil {
            return User.sample
        }
        return nil
    }
}

public final class MockAuthService: AuthServiceProtocol, @unchecked Sendable {
    public var shouldSucceed = true
    
    public init() {}
    
    public func login(email: String, password: String) async throws -> User {
        if shouldSucceed {
            return User.sample
        } else {
            throw NetworkError.serverError(message: "Mock authentication error")
        }
    }
    
    public func logout() async throws {}
    
    public func getCurrentUser() async -> User? {
        return User.sample
    }
}
