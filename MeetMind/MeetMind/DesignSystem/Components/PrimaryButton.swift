//
//  PrimaryButton.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import SwiftUI

public struct PrimaryButton: View {
    let title: String
    let iconName: String?
    let isLoading: Bool
    let action: () -> Void
    
    public init(
        title: String,
        iconName: String? = nil,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.iconName = iconName
        self.isLoading = isLoading
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    if let iconName = iconName {
                        Image(systemName: iconName)
                            .font(.system(size: 16, weight: .bold))
                    }
                    Text(title)
                        .font(AppTypography.headline)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(AppColors.primary)
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(color: AppColors.primary.opacity(0.3), radius: 6, x: 0, y: 3)
        }
        .disabled(isLoading)
    }
}

#Preview {
    PrimaryButton(title: "Continue", iconName: "arrow.right") {}
        .padding()
}
