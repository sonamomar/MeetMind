//
//  UserDefaultsManager.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import Foundation

public protocol KeyValueStorageProtocol: Sendable {
    func string(forKey key: String) -> String?
    func set(_ value: String?, forKey key: String)
    func bool(forKey key: String) -> Bool
    func set(_ value: Bool, forKey key: String)
    func remove(forKey key: String)
}

public final class UserDefaultsManager: KeyValueStorageProtocol, @unchecked Sendable {
    public static let shared = UserDefaultsManager()
    private let userDefaults: UserDefaults

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public func string(forKey key: String) -> String? {
        userDefaults.string(forKey: key)
    }

    public func set(_ value: String?, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }

    public func bool(forKey key: String) -> Bool {
        userDefaults.bool(forKey: key)
    }

    public func set(_ value: Bool, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }

    public func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
