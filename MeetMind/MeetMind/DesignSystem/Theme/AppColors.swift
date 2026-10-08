//
//  AppColors.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import SwiftUI

/// Semantic palette and theme colors for the application.
public struct AppColors {
    // Brand Palette
    public static let primary = Color(hex: "#4F46E5")     // Indigo
    public static let primaryDark = Color(hex: "#3730A3")
    public static let secondary = Color(hex: "#06B6D4")   // Cyan
    public static let accent = Color(hex: "#8B5CF6")      // Purple
    
    // Neutral & Backgrounds
    public static let background = Color(.systemGroupedBackground)
    public static let secondaryBackground = Color(.secondarySystemGroupedBackground)
    public static let surface = Color(.systemBackground)
    
    // Content / Text
    public static let textPrimary = Color(.label)
    public static let textSecondary = Color(.secondaryLabel)
    public static let textTertiary = Color(.tertiaryLabel)
    
    // Status & Feedback
    public static let success = Color(hex: "#10B981")     // Emerald Green
    public static let warning = Color(hex: "#F59E0B")     // Amber
    public static let error = Color(hex: "#EF4444")       // Rose Red
    public static let info = Color(hex: "#3B82F6")        // Blue
}
