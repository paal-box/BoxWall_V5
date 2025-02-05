import SwiftUI

struct LightBeamView: View {
    @State private var rotation: Double = 0
    
    // Configuration properties
    let gradientScale: CGFloat
    let blurRadius: CGFloat
    let rotationDuration: Double
    let glowOpacity: Double
    
    init(
        gradientScale: CGFloat = 1.2,
        blurRadius: CGFloat = 30,
        rotationDuration: Double = 8,
        glowOpacity: Double = 0.4
    ) {
        self.gradientScale = gradientScale
        self.blurRadius = blurRadius
        self.rotationDuration = rotationDuration
        self.glowOpacity = glowOpacity
    }

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            
            AngularGradient(
                gradient: Gradient(stops: [
                    .init(color: Color.white.opacity(0.0), location: 0.0),
                    .init(color: Color.white.opacity(glowOpacity), location: 0.4),
                    .init(color: Color.white.opacity(glowOpacity), location: 0.6),
                    .init(color: Color.white.opacity(0.0), location: 1.0)
                ]),
                center: .center,
                angle: .degrees(0)
            )
            // Scale up the gradient for a more expansive glow
            .frame(
                width: size * gradientScale,
                height: size * gradientScale
            )
            .position(
                x: geometry.size.width / 2,
                y: geometry.size.height / 2
            )
            // Rotate the gradient
            .rotationEffect(.degrees(rotation))
            // Use overlay blend mode for a more natural glow
            .blendMode(.overlay)
            // Softer blur for a more ethereal effect
            .blur(radius: blurRadius)
            .onAppear {
                withAnimation(
                    Animation
                        .linear(duration: rotationDuration)
                        .repeatForever(autoreverses: false)
                ) {
                    rotation = 360
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        LightBeamView(
            gradientScale: 1.5,
            blurRadius: 35,
            rotationDuration: 8,
            glowOpacity: 0.5
        )
        .frame(width: 300, height: 300)
    }
} 