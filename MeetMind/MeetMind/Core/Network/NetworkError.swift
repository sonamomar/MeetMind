//
//  NetworkError.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import Foundation

public enum NetworkError: LocalizedError, Equatable {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case decodingFailed(reason: String)
    case encodingFailed
    case unauthorized
    case serverError(message: String)
    case noInternetConnection
    case unknown(reason: String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL was invalid."
        case .invalidResponse(let statusCode):
            return "Server responded with error code \(statusCode)."
        case .decodingFailed(let reason):
            return "Failed to parse data: \(reason)"
        case .encodingFailed:
            return "Failed to encode request parameters."
        case .unauthorized:
            return "Unauthorized access. Please log in again."
        case .serverError(let message):
            return message
        case .noInternetConnection:
            return "No internet connection available."
        case .unknown(let reason):
            return reason
        }
    }
}
