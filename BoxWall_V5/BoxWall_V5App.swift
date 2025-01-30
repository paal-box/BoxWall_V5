//
//  BoxWall_V5App.swift
//  BoxWall_V5
//
//  Created by Paal Selnaes on 1/21/25.
//

import SwiftUI

@main
struct BoxWall_V5App: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .animation(.easeInOut(duration: 0.3), value: isDarkMode)
        }
    }
}
