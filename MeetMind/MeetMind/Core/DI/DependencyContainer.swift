//
//  DependencyContainer.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import Foundation
import SwiftUI

public final class DependencyContainer: @unchecked Sendable {
    public static let shared = DependencyContainer()
    
    public var apiClient: APIClientProtocol
    public var storage: KeyValueStorageProtocol
    public var authService: AuthServiceProtocol
    public var dataService: DataServiceProtocol
    public var courseAPIService: CourseAPIServiceProtocol
    public var courseRepository: CourseRepositoryProtocol
    
    public init(
        apiClient: APIClientProtocol = URLSessionAPIClient(),
        storage: KeyValueStorageProtocol = UserDefaultsManager.shared,
        authService: AuthServiceProtocol? = nil,
        dataService: DataServiceProtocol? = nil,
        courseAPIService: CourseAPIServiceProtocol? = nil,
        courseRepository: CourseRepositoryProtocol? = nil
    ) {
        self.apiClient = apiClient
        self.storage = storage
        
        let activeAuth = authService ?? AuthService(apiClient: apiClient, storage: storage)
        self.authService = activeAuth
        self.dataService = dataService ?? DataService(apiClient: apiClient)
        
        let api = courseAPIService ?? CourseAPIService()
        self.courseAPIService = api
        self.courseRepository = courseRepository ?? CourseRepository(apiService: api)
    }
    
    public static var mock: DependencyContainer {
        let mockNetwork = MockNetworkService()
        let mockStorage = UserDefaultsManager(userDefaults: UserDefaults(suiteName: "mock_suite")!)
        let mockCourseAPI = MockCourseAPIService()
        let mockRepo = MockCourseRepository()
        
        return DependencyContainer(
            apiClient: mockNetwork,
            storage: mockStorage,
            authService: MockAuthService(),
            dataService: MockDataService(),
            courseAPIService: mockCourseAPI,
            courseRepository: mockRepo
        )
    }
}

// Environment key injection
private struct DependencyContainerKey: EnvironmentKey {
    static let defaultValue: DependencyContainer = .shared
}

extension EnvironmentValues {
    public var dependencies: DependencyContainer {
        get { self[DependencyContainerKey.self] }
        set { self[DependencyContainerKey.self] = newValue }
    }
}
