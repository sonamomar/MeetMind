//
//  User.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import Foundation

public struct User: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let email: String
    public let avatarURL: String?
    
    public init(id: String, name: String, email: String, avatarURL: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.avatarURL = avatarURL
    }
    
    public static var sample: User {
        User(id: "usr_1001", name: "Sonam Omar", email: "sonam@example.com")
    }
}
