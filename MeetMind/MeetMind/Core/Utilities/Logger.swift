//
//  Logger.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import Foundation
import os

/// Centralized logging system built on OSLog for high performance and privacy-aware logging.
public enum AppLogger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.MeetMind"
    
    public static let general = Logger(subsystem: subsystem, category: "General")
    public static let network = Logger(subsystem: subsystem, category: "Network")
    public static let database = Logger(subsystem: subsystem, category: "Database")
    public static let navigation = Logger(subsystem: subsystem, category: "Navigation")
    public static let ui = Logger(subsystem: subsystem, category: "UI")
    public static let auth = Logger(subsystem: subsystem, category: "Auth")
    
    public static func debug(_ message: String, category: Logger = general) {
        #if DEBUG
        category.debug("\(message, privacy: .public)")
        #endif
    }
    
    public static func info(_ message: String, category: Logger = general) {
        category.info("\(message, privacy: .public)")
    }
    
    public static func warning(_ message: String, category: Logger = general) {
        category.warning("\(message, privacy: .public)")
    }
    
    public static func error(_ message: String, error: Error? = nil, category: Logger = general) {
        if let error = error {
            category.error("\(message, privacy: .public) - Error: \(error.localizedDescription, privacy: .public)")
        } else {
            category.error("\(message, privacy: .public)")
        }
    }
}
