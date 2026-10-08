//
//  NetworkTests.swift
//  MeetMindTests
//
//  Created by Sonam Omar on 06/08/26.
//

import Testing
import Foundation
@testable import MeetMind

@MainActor
struct NetworkTests {

    @Test func testMockNetworkServiceSuccess() async throws {
        let mockUser = User(id: "1", name: "Test User", email: "test@example.com")
        let mockService = MockNetworkService(result: .success(mockUser))
        
        struct TestEndpoint: Endpoint {
            var baseURL: String { "https://api.example.com" }
            var path: String { "/user" }
            var method: HTTPMethod { .get }
        }
        
        let result: User = try await mockService.request(TestEndpoint())
        #expect(result.id == "1")
        #expect(result.name == "Test User")
        #expect(result.email == "test@example.com")
    }

    @Test func testMockNetworkServiceFailure() async throws {
        let mockService = MockNetworkService(result: .failure(NetworkError.unauthorized))
        
        struct TestEndpoint: Endpoint {
            var baseURL: String { "https://api.example.com" }
            var path: String { "/user" }
            var method: HTTPMethod { .get }
        }
        
        await #expect(throws: NetworkError.unauthorized) {
            let _: User = try await mockService.request(TestEndpoint())
        }
    }
}

