//
//  AppTypography.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import SwiftUI

/// Standard typography tokens for consistent typography throughout the app.
public struct AppTypography {
    public static let titleLarge = Font.system(size: 34, weight: .bold, design: .rounded)
    public static let title = Font.system(size: 24, weight: .semibold, design: .rounded)
    public static let headline = Font.system(size: 18, weight: .semibold, design: .default)
    public static let body = Font.system(size: 16, weight: .regular, design: .default)
    public static let bodyBold = Font.system(size: 16, weight: .semibold, design: .default)
    public static let subheadline = Font.system(size: 14, weight: .regular, design: .default)
    public static let subheadlineBold = Font.system(size: 14, weight: .semibold, design: .default)
    public static let caption = Font.system(size: 12, weight: .medium, design: .default)
    public static let captionBold = Font.system(size: 12, weight: .bold, design: .default)
}
