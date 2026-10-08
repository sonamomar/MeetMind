//
//  AppState.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import SwiftUI

/// Observable global application state managing authentication state and app lifecycle.
@Observable
public final class AppState {
    public var isAuthenticated: Bool = false
    public var currentUser: User?
    public var isLoading: Bool = false
    
    public init(isAuthenticated: Bool = false, currentUser: User? = nil) {
        self.isAuthenticated = isAuthenticated
        self.currentUser = currentUser
    }
}
