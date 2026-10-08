//
//  SwiftDataModels.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import Foundation
import SwiftData

@Model
public final class SDCourse {
    @Attribute(.unique) public var id: Int
    public var title: String
    public var instructor: String
    public var progress: Int
    public var lessonsCount: Int
    @Relationship(deleteRule: .cascade, inverse: \SDLesson.course)
    public var lessons: [SDLesson]
    
    public init(id: Int, title: String, instructor: String, progress: Int, lessonsCount: Int, lessons: [SDLesson] = []) {
        self.id = id
        self.title = title
        self.instructor = instructor
        self.progress = progress
        self.lessonsCount = lessonsCount
        self.lessons = lessons
    }
    
    public func toDomain() -> Course {
        let domainLessons = lessons.sorted(by: { $0.order < $1.order }).map { $0.toDomain() }
        let calculated = CourseProgressCalculator.calculateProgress(lessons: domainLessons, fallbackProgress: progress)
        return Course(
            id: id,
            title: title,
            instructor: instructor,
            progress: calculated,
            lessonsCount: lessonsCount,
            lessons: domainLessons
        )
    }
    
    public static func fromDomain(_ course: Course) -> SDCourse {
        let sdLessons = course.lessons.map { SDLesson.fromDomain($0) }
        return SDCourse(
            id: course.id,
            title: course.title,
            instructor: course.instructor,
            progress: course.progress,
            lessonsCount: course.lessonsCount,
            lessons: sdLessons
        )
    }
}

@Model
public final class SDLesson {
    @Attribute(.unique) public var id: String
    public var courseId: Int
    public var title: String
    public var isCompleted: Bool
    public var order: Int
    public var course: SDCourse?
    
    public init(id: String, courseId: Int, title: String, isCompleted: Bool, order: Int) {
        self.id = id
        self.courseId = courseId
        self.title = title
        self.isCompleted = isCompleted
        self.order = order
    }
    
    public func toDomain() -> Lesson {
        Lesson(id: id, courseId: courseId, title: title, isCompleted: isCompleted, order: order)
    }
    
    public static func fromDomain(_ lesson: Lesson) -> SDLesson {
        SDLesson(id: lesson.id, courseId: lesson.courseId, title: lesson.title, isCompleted: lesson.isCompleted, order: lesson.order)
    }
}
