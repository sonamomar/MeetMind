//
//  ContentView.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var router = AppRouter()
    @State private var appState = AppState()
    
    var body: some View {
        MainTabView(router: router, appState: appState)
    }
}

#Preview {
    ContentView()
        .environment(\.dependencies, .mock)
        .modelContainer(for: Item.self, inMemory: true)
}
