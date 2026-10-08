//
//  DataServiceProtocol.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import Foundation

public protocol DataServiceProtocol: Sendable {
    func fetchItems() async throws -> [User]
}
