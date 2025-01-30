import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var showMainContent = false
    @State private var showRings = false
    @State private var logoOpacity: Double = 0
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    // Animation timing constants
    private let quickAnimation = 0.2
    private let standardAnimation = 0.3
    private let slowAnimation = 0.5
    
    private var isIPad: Bool {
        horizontalSizeClass == .regular
    }
    
    private var logoWidth: CGFloat {
        isIPad ? 400 : 200 // Increased iPad logo size
    }
    
    private var ringSpacing: CGFloat {
        isIPad ? 120 : 100 // Increased space between rings
    }
    
    var body: some View {
        ZStack {
            // Main Content
            if showMainContent {
                ContentView()
                    .transition(
                        .asymmetric(
                            insertion: .opacity.combined(with: .scale(scale: 1.1)),
                            removal: .opacity
                        )
                    )
            }
            
            // Splash Screen
            if !showMainContent {
                ZStack {
                    // Background Image
                    Image("launch-background")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                    
                    if isIPad {
                        // iPad-specific animated rings
                        ForEach(0..<3) { index in
                            Circle()
                                .stroke(Color.white.opacity(0.2), lineWidth: isIPad ? 3 : 2)
                                .frame(width: CGFloat(400 + index * Int(ringSpacing)))
                                .scaleEffect(showRings ? 1.2 : 0.8)
                                .opacity(showRings ? 0.3 : 0)
                                .animation(
                                    .spring(
                                        response: 0.4,
                                        dampingFraction: 0.8,
                                        blendDuration: 0.5
                                    )
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.3),
                                    value: showRings
                                )
                        }
                    }
                    
                    // Logo Container
                    VStack(spacing: isIPad ? 40 : 20) {
                        // BoxWall Logo
                        Image("boxwall-logo-white")
                            .resizable()
                            .scaledToFit()
                            .frame(width: logoWidth)
                            .scaleEffect(isAnimating ? 1 : 0.7)
                            .opacity(logoOpacity)
                            .animation(
                                .spring(response: 0.3, dampingFraction: 0.7),
                                value: logoOpacity
                            )
                        
                        // Loading Indicator
                        HStack(spacing: isIPad ? 16 : 6) {
                            ForEach(0..<3) { index in
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: isIPad ? 14 : 6, height: isIPad ? 14 : 6)
                                    .scaleEffect(isAnimating ? 1 : 0.5)
                                    .opacity(isAnimating ? 1 : 0)
                                    .animation(
                                        .spring(response: 0.2, dampingFraction: 0.7)
                                        .repeatForever()
                                        .delay(Double(index) * 0.2),
                                        value: isAnimating
                                    )
                            }
                        }
                        
                        if isIPad {
                            // iPad-specific tagline
                            Text("Building Better Spaces")
                                .font(.system(size: 24, weight: .medium, design: .rounded))
                                .foregroundColor(.white)
                                .opacity(isAnimating ? 1 : 0)
                                .offset(y: isAnimating ? 0 : 20)
                        }
                    }
                    .offset(y: isIPad ? -100 : -30) // Move content up more on iPad
                }
            }
        }
        .onAppear {
            // Initial fade in
            withAnimation(
                .spring(response: 0.3, dampingFraction: 0.7)
            ) {
                isAnimating = true
                logoOpacity = 1
            }
            
            if isIPad {
                withAnimation(.easeInOut(duration: 1.5)) {
                    showRings = true
                }
            }
            
            // Final fade out sequence
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(
                    .spring(response: 0.3, dampingFraction: 0.7)
                ) {
                    logoOpacity = 0
                }
                
                // Transition to main content after fade out
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(
                        .spring(response: 0.4, dampingFraction: 0.8)
                    ) {
                        showMainContent = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
} 