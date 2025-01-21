//
//  ContentView.swift
//  BoxWall_V5
//
//  Created by Paal Selnaes on 1/21/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                DashboardView()
                    .tag(0)
                
                Text("Shop")  // Placeholder for now
                    .tag(1)
                
                ProjectsView()
                    .tag(2)
            }
            .ignoresSafeArea(edges: .bottom)
            
            TabBar(selectedTab: $selectedTab)
        }
    }
}

#Preview {
    ContentView()
} 