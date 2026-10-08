//
//  EmptyStateView.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import SwiftUI

public struct EmptyStateView: View {
    let iconName: String
    let title: String
    let description: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    public init(
        iconName: String = "tray",
        title: String = "No Items Yet",
        description: String = "Items will appear here once you add them.",
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.iconName = iconName
        self.title = title
        self.description = description
        self.actionTitle = actionTitle
        self.action = action
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            Image(systemName: iconName)
                .font(.system(size: 56, weight: .light))
                .foregroundColor(AppColors.primary.opacity(0.6))
                .padding(.bottom, 8)
            
            Text(title)
                .font(AppTypography.title)
                .foregroundColor(AppColors.textPrimary)
            
            Text(description)
                .font(AppTypography.body)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(AppTypography.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(AppColors.primary)
                        .cornerRadius(12)
                }
                .padding(.top, 8)
            }
        }
        .padding(32)
    }
}

#Preview {
    EmptyStateView(actionTitle: "Add Item") {}
}
