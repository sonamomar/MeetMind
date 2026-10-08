//
//  View+Extensions.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import SwiftUI

extension View {
    /// Dismisses the keyboard when called.
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    /// Conditionally applies a transformation modifier to a view.
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    func cardStyle(backgroundColor: Color = Color(.secondarySystemGroupedBackground), cornerRadius: CGFloat = 16, shadowRadius: CGFloat = 4) -> some View {
        self
            .padding()
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(color: Color.black.opacity(0.06), radius: shadowRadius, x: 0, y: 2)
    }
}
