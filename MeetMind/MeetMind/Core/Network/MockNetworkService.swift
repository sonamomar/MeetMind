//
//  MockNetworkService.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import Foundation

public final class MockNetworkService: APIClientProtocol, @unchecked Sendable {
    public var result: Result<Any, Error>?
    public var delaySeconds: UInt64 = 0

    public init(result: Result<Any, Error>? = nil) {
        self.result = result
    }

    public func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        if delaySeconds > 0 {
            try await Task.sleep(nanoseconds: delaySeconds * 1_000_000_000)
        }

        guard let result = result else {
            throw NetworkError.unknown(reason: "Mock result not set")
        }

        switch result {
        case .success(let data):
            if let typed = data as? T {
                return typed
            } else {
                throw NetworkError.decodingFailed(reason: "Mock data mismatch")
            }
        case .failure(let error):
            throw error
        }
    }
}
