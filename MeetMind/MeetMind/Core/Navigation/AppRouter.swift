//
//  AppRouter.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import SwiftUI

/// router to manage stacj navigation and alert messages.
@Observable
public final class AppRouter {
    public var path = NavigationPath()
    public var toastMessage: String?
    
    public init() {}
    
    public func navigate(to destination: AppDestination) {
        AppLogger.debug("Navigating to: \(destination)", category: AppLogger.navigation)
        path.append(destination)
    }
    
    public func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    public func popToRoot() {
        path = NavigationPath()
    }
    
    public func showToast(_ message: String) {
        toastMessage = message
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 2_500_000_000)
            if self.toastMessage == message {
                self.toastMessage = nil
            }
        }
    }
}
