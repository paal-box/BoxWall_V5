import SwiftUI

struct LaunchScreenView: View {
    @State private var isAnimating = false
    @State private var opacity = 0.0
    
    var body: some View {
        ZStack {
            // Background
            Image("launch-background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            // Light rays
            Circle()
                .fill(Color.white.opacity(0.2))
                .scaleEffect(isAnimating ? 1.5 : 0.8)
                .opacity(isAnimating ? 0.2 : 0.5)
            
            // Logo
            Image("boxwall-logo-black")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .opacity(opacity)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
            
            withAnimation(.easeIn(duration: 1.0)) {
                opacity = 1.0
            }
        }
    }
} 