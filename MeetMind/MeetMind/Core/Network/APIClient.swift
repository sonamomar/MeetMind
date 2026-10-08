//
//  APIClient.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import Foundation

public protocol APIClientProtocol: Sendable {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

public final class URLSessionAPIClient: APIClientProtocol, @unchecked Sendable {
    private let session: URLSession
    private let decoder: JSONDecoder

    public init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder.dateDecodingStrategy = .iso8601
    }

    public func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let urlRequest = try endpoint.urlRequest()
        
        AppLogger.debug("Network Request: \(urlRequest.httpMethod ?? "") \(urlRequest.url?.absoluteString ?? "")", category: AppLogger.network)
        
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            AppLogger.error("Network Fetch Failed", error: error, category: AppLogger.network)
            throw NetworkError.unknown(reason: error.localizedDescription)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse(statusCode: -1)
        }

        AppLogger.debug("Network Response Status: \(httpResponse.statusCode)", category: AppLogger.network)

        switch httpResponse.statusCode {
        case 200...299:
            do {
                return try decoder.decode(T.self, from: data)
            } catch let decodingError {
                AppLogger.error("Decoding Failed", error: decodingError, category: AppLogger.network)
                throw NetworkError.decodingFailed(reason: decodingError.localizedDescription)
            }
        case 401:
            throw NetworkError.unauthorized
        default:
            throw NetworkError.invalidResponse(statusCode: httpResponse.statusCode)
        }
    }
}
