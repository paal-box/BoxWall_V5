//
//  ContentView.swift
//  BoxWall_V5
//
//  Created by Paal Selnaes on 1/21/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    static var switchToTab: ((Int) -> Void)?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                DashboardView(switchToShop: { selectedTab = 1 }, switchToCO2: { selectedTab = 3 })
                    .tag(0)
                
                Text("Shop")  // Placeholder for now
                    .tag(1)
                
                ProjectsView()
                    .tag(2)
                    
                CO2ImpactView()
                    .tag(3)
            }
            .ignoresSafeArea(edges: .bottom)
            
            TabBar(selectedTab: $selectedTab)
        }
        .onAppear {
            // Store the tab switching function
            Self.switchToTab = { tab in
                selectedTab = tab
            }
        }
    }
}

#Preview {
    ContentView()
} 