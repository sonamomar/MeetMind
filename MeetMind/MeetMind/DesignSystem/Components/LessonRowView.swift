//
//  LessonRowView.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import SwiftUI

public struct LessonRowView: View {
    public let lesson: Lesson
    public let onToggle: () -> Void
    
    public init(lesson: Lesson, onToggle: @escaping () -> Void) {
        self.lesson = lesson
        self.onToggle = onToggle
    }
    
    public var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 14) {
                // Status Icon
                Image(systemName: lesson.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(lesson.isCompleted ? Color.green : AppColors.textSecondary.opacity(0.6))
                    .scaleEffect(lesson.isCompleted ? 1.05 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: lesson.isCompleted)
                
                Text(lesson.title)
                    .font(AppTypography.body)
                    .foregroundColor(lesson.isCompleted ? AppColors.textPrimary : AppColors.textPrimary)
                    .strikethrough(lesson.isCompleted, color: AppColors.textSecondary.opacity(0.5))
                
                Spacer()
                
                Text(lesson.isCompleted ? "Completed" : "Pending")
                    .font(AppTypography.captionBold)
                    .foregroundColor(lesson.isCompleted ? Color.green : Color.orange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(lesson.isCompleted ? Color.green.opacity(0.12) : Color.orange.opacity(0.12))
                    .clipShape(Capsule())
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color(.tertiarySystemGroupedBackground))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 12) {
        LessonRowView(lesson: Lesson(courseId: 1, title: "Introduction", isCompleted: true, order: 1), onToggle: {})
        LessonRowView(lesson: Lesson(courseId: 1, title: "Functions & Closures", isCompleted: false, order: 2), onToggle: {})
    }
    .padding()
}
