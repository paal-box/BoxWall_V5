import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var showMainContent = false
    @State private var logoOpacity: Double = 0
    @State private var beamScale: CGFloat = 0.8
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    private var isIPad: Bool {
        horizontalSizeClass == .regular
    }
    
    private var logoWidth: CGFloat {
        isIPad ? 400 : 200
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
                        // Add a slight overlay to ensure logo visibility
                        .overlay(Color.black.opacity(0.3))
                    
                    // Light Beam Effect behind the logo
                    LightBeamView(
                        gradientScale: 1.2,  // Reduced from 2.0 for more focused glow
                        blurRadius: isIPad ? 35 : 25,  // Reduced blur for sharper edges
                        rotationDuration: 8,
                        glowOpacity: 0.35  // Slightly reduced for subtlety
                    )
                    .frame(width: logoWidth * 1.5, height: logoWidth * 1.5)  // Reduced from 2x to 1.5x
                    .scaleEffect(beamScale)
                    .opacity(logoOpacity)
                    
                    // Logo Container
                    VStack(spacing: isIPad ? 40 : 20) {
                        // BoxWall Logo
                        Image("boxwall-logo-white")
                            .resizable()
                            .scaledToFit()
                            .frame(width: logoWidth)
                            .scaleEffect(isAnimating ? 1 : 0.7)
                            .opacity(logoOpacity)
                        
                        // Loading Indicator
                        HStack(spacing: isIPad ? 16 : 6) {
                            ForEach(0..<3) { index in
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: isIPad ? 14 : 6, height: isIPad ? 14 : 6)
                                    .scaleEffect(isAnimating ? 1 : 0.5)
                                    .opacity(isAnimating ? 1 : 0)
                                    .animation(
                                        Animation.spring(response: 0.2, dampingFraction: 0.7)
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
                    .offset(y: isIPad ? -100 : -30)
                }
            }
        }
        .onAppear {
            // Initial animations
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isAnimating = true
                logoOpacity = 1
            }
            
            // Animate beam scale with a gentler pulse
            withAnimation(
                .easeInOut(duration: 3.0)
                .repeatForever(autoreverses: true)
            ) {
                beamScale = 1.05  // Reduced scale animation range for subtler effect
            }
            
            // Final fade out sequence
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    logoOpacity = 0
                }
                
                // Transition to main content
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
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