//
//  DataService.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import Foundation

public final class DataService: DataServiceProtocol, @unchecked Sendable {
    private let apiClient: APIClientProtocol
    
    public init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    public func fetchItems() async throws -> [User] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return [
            User(id: "1", name: "Alex Morgan", email: "alex@example.com"),
            User(id: "2", name: "Taylor Swift", email: "taylor@example.com"),
            User(id: "3", name: "Jordan Lee", email: "jordan@example.com")
        ]
    }
}

public final class MockDataService: DataServiceProtocol, @unchecked Sendable {
    public init() {}
    
    public func fetchItems() async throws -> [User] {
        return [User.sample]
    }
}
