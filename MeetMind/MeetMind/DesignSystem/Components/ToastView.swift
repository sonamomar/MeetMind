//
//  ToastView.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import SwiftUI

public struct ToastView: View {
    let message: String
    let iconName: String
    
    public init(message: String, iconName: String = "info.circle.fill") {
        self.message = message
        self.iconName = iconName
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .foregroundColor(AppColors.primary)
                .font(.system(size: 18))
            Text(message)
                .font(AppTypography.subheadline)
                .foregroundColor(AppColors.textPrimary)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(AppColors.surface)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 20)
    }
}

#Preview {
    ToastView(message: "Item saved successfully!")
}
