import SwiftUI

struct ProjectMenuCard: View {
    let menuItem: ProjectMenuItem
    @State private var isHovered = false
    @State private var isPressed = false
    @State private var iconScale: CGFloat = 1
    
    private var iconConfig: (size: CGFloat, weight: Font.Weight) {
        switch menuItem.type {
        case .quote:
            return (36, .medium)
        case .technical:
            return (34, .regular)
        case .finance:
            return (34, .medium)
        case .coCreator:
            return (36, .light)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Icon with animation
            Image(systemName: menuItem.icon)
                .font(.system(size: iconConfig.size, weight: iconConfig.weight))
                .foregroundColor(.white)
                .symbolRenderingMode(.hierarchical)
                .symbolEffect(.bounce, options: .repeating, value: isHovered)
                .scaleEffect(iconScale)
                .padding(.bottom, 8)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 8) {
                // Title
                Text(menuItem.title)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                    .lineLimit(1)
                
                // Description
                Text(menuItem.description)
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                    .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(
            ZStack {
                // Base gradient
                menuItem.type.gradient
                    .opacity(0.95)
                
                // Glass effect overlay
                Color.white.opacity(0.05)
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        // Enhanced shadow system
        .shadow(
            color: Color(.sRGBLinear, white: 0, opacity: 0.15),
            radius: isHovered ? 20 : 10,
            x: 0,
            y: isHovered ? 10 : 5
        )
        .shadow(
            color: Color(.sRGBLinear, white: 0, opacity: 0.1),
            radius: isHovered ? 5 : 2,
            x: 0,
            y: isHovered ? 2 : 1
        )
        // Transform effect
        .scaleEffect(isPressed ? 0.98 : (isHovered ? 1.02 : 1.0))
        .offset(y: isHovered ? -2 : 0)
        .onHover { hovering in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isHovered = hovering
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.5).repeatForever(autoreverses: true)) {
                iconScale = 1.05
            }
        }
    }
}

#Preview {
    ProjectMenuCard(menuItem: ProjectMenuItem.items[0])
        .frame(height: 180)
        .padding()
} 