//
//  AuthServiceProtocol.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import Foundation

public protocol AuthServiceProtocol: Sendable {
    func login(email: String, password: String) async throws -> User
    func logout() async throws
    func getCurrentUser() async -> User?
}
