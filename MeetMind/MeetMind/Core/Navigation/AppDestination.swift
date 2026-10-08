//
//  AppDestination.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import Foundation

/// Navigation routes across the application.
public enum AppDestination: Hashable, Identifiable {
    case courseDetail(course: Course)
    
    public var id: String {
        switch self {
        case .courseDetail(let course): return "courseDetail_\(course.id)"
        }
    }
}
