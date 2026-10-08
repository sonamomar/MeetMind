//
//  ProgressBarView.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import SwiftUI

public struct ProgressBarView: View {
    public let progress: Int // 0 - 100
    public var height: CGFloat = 8
    public var showLabel: Bool = true
    
    public init(progress: Int, height: CGFloat = 8, showLabel: Bool = true) {
        self.progress = max(0, min(100, progress))
        self.height = height
        self.showLabel = showLabel
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if showLabel {
                HStack {
                    Text("Progress")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                    Spacer()
                    Text("\(progress)%")
                        .font(AppTypography.captionBold)
                        .foregroundColor(progressColor)
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(Color(.systemGray5))
                        .frame(height: height)
                    
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(progressGradient)
                        .frame(width: max(0, min(geometry.size.width, geometry.size.width * CGFloat(progress) / 100.0)), height: height)
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: progress)
                }
            }
            .frame(height: height)
        }
    }
    
    private var progressColor: Color {
        if progress >= 100 {
            return Color.green
        } else if progress >= 50 {
            return AppColors.primary
        } else {
            return Color.orange
        }
    }
    
    private var progressGradient: LinearGradient {
        if progress >= 100 {
            return LinearGradient(colors: [Color.green, Color.mint], startPoint: .leading, endPoint: .trailing)
        } else if progress >= 50 {
            return LinearGradient(colors: [AppColors.primary, Color.indigo], startPoint: .leading, endPoint: .trailing)
        } else {
            return LinearGradient(colors: [Color.orange, Color.amber], startPoint: .leading, endPoint: .trailing)
        }
    }
}

extension Color {
    static let amber = Color(red: 0.95, green: 0.65, blue: 0.15)
}

#Preview {
    VStack(spacing: 16) {
        ProgressBarView(progress: 25)
        ProgressBarView(progress: 65)
        ProgressBarView(progress: 100)
    }
    .padding()
}
