//
//  CourseCard.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import SwiftUI

public struct CourseCard: View {
    public let course: Course
    public let onContinueTap: () -> Void
    
    public init(course: Course, onContinueTap: @escaping () -> Void) {
        self.course = course
        self.onContinueTap = onContinueTap
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(course.title)
                        .font(AppTypography.headline)
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(2)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "person.fill")
                            .font(.caption)
                            .foregroundColor(AppColors.textSecondary)
                        Text(course.instructor)
                            .font(AppTypography.subheadline)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                
                Spacer()
                
                // Lessons Badge
                HStack(spacing: 4) {
                    Image(systemName: "book.closed.fill")
                        .font(.caption2)
                    Text("\(course.lessonsCount) lessons")
                        .font(AppTypography.captionBold)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(AppColors.primary.opacity(0.1))
                .foregroundColor(AppColors.primary)
                .clipShape(Capsule())
            }
            
            // Visual Progress Bar
            ProgressBarView(progress: course.calculatedProgress, showLabel: true)
            
            Divider()
            
            // Continue Button
            Button(action: onContinueTap) {
                HStack {
                    Text("Continue Course")
                        .font(AppTypography.subheadlineBold)
                    Spacer()
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 18, weight: .semibold))
                }
                .foregroundColor(AppColors.primary)
                .padding(.vertical, 4)
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
    }
}

#Preview {
    CourseCard(
        course: Course(
            id: 1,
            title: "Python Programming",
            instructor: "John Smith",
            progress: 65,
            lessonsCount: 20
        ),
        onContinueTap: {}
    )
    .padding()
}
