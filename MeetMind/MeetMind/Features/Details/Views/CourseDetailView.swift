//
//  CourseDetailView.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import SwiftUI

public struct CourseDetailView: View {
    @State private var viewModel: CourseDetailViewModel
    
    public init(course: Course, repository: CourseRepositoryProtocol, router: AppRouter) {
        _viewModel = State(initialValue: CourseDetailViewModel(course: course, repository: repository, router: router))
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Card
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.course.title)
                                .font(AppTypography.title)
                                .foregroundColor(AppColors.textPrimary)
                            
                            HStack(spacing: 6) {
                                Image(systemName: "person.fill")
                                    .font(.caption)
                                    .foregroundColor(AppColors.textSecondary)
                                Text("Instructor: \(viewModel.course.instructor)")
                                    .font(AppTypography.subheadline)
                                    .foregroundColor(AppColors.textSecondary)
                            }
                        }
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    // Dynamic Progress Section
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Current Progress")
                                .font(AppTypography.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Spacer()
                            
                            Text("\(viewModel.completedLessonsCount) of \(viewModel.totalLessonsCount) completed")
                                .font(AppTypography.captionBold)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        
                        ProgressBarView(progress: viewModel.course.calculatedProgress, height: 12, showLabel: true)
                    }
                }
                .padding(20)
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
                
                // Lessons Section Header
                HStack {
                    Text("Course Lessons")
                        .font(AppTypography.titleLarge)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Text("Tap to toggle completion")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
                .padding(.horizontal, 4)
                
                // Lesson List
                VStack(spacing: 10) {
                    if viewModel.course.lessons.isEmpty {
                        Text("No detailed lessons listed for this course.")
                            .font(AppTypography.subheadline)
                            .foregroundColor(AppColors.textSecondary)
                            .padding(.vertical, 20)
                    } else {
                        ForEach(viewModel.course.lessons.sorted(by: { $0.order < $1.order })) { lesson in
                            LessonRowView(
                                lesson: lesson,
                                onToggle: {
                                    Task {
                                        await viewModel.toggleLesson(lesson)
                                    }
                                }
                            )
                        }
                    }
                }
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Course Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CourseDetailView(
            course: CourseAPIService.sampleCourses.first!,
            repository: MockCourseRepository(),
            router: AppRouter()
        )
    }
}
