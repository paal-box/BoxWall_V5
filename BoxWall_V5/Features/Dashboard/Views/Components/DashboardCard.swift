import SwiftUI

/// A card component used in the dashboard to display menu items
/// with consistent styling and interaction feedback.
struct DashboardCard: View {
    /// The menu item data to display in the card
    let menuItem: MenuCardItem
    
    /// Action to perform when the card is tapped
    let action: () -> Void
    
    @State private var isHovered = false
    @State private var isPressed = false
    @State private var iconScale: CGFloat = 1
    
    private var iconConfig: (size: CGFloat, weight: Font.Weight) {
        switch menuItem.type {
        case .shop:
            return (36, .medium)
        case .expert:
            return (34, .regular)
        case .sustainability:
            return (38, .light)
        case .inventory:
            return (34, .medium)
        case .reflex:
            return (36, .light)
        case .news:
            return (34, .regular)
        }
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                action()
                isPressed = false
            }
        }) {
            VStack(alignment: .leading, spacing: 16) {
                // Icon with animation
                Image(systemName: menuItem.icon)
                    .font(.system(size: iconConfig.size, weight: iconConfig.weight))
                    .foregroundColor(.white)
                    .symbolRenderingMode(.hierarchical)
                    .symbolEffect(.bounce, options: .repeating, value: isHovered)
                    .scaleEffect(iconScale)
                    .onAppear {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.5).repeatForever(autoreverses: true)) {
                            iconScale = 1.05
                        }
                    }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 8) {
                    // Title with shine effect
                    Text(menuItem.title)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .overlay {
                            if isHovered {
                                LinearGradient(
                                    colors: [.white.opacity(0), .white, .white.opacity(0)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .frame(width: 40)
                                .blur(radius: 5)
                                .offset(x: isHovered ? 200 : -200)
                                .animation(.linear(duration: 1.5).repeatForever(autoreverses: false), value: isHovered)
                            }
                        }
                        .clipped()
                    
                    // Description
                    Text(menuItem.description)
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(2)
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                ZStack {
                    // Gradient background
                    getGradient(for: menuItem.type)
                    
                    // Animated particles
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(.white.opacity(0.1))
                            .frame(width: 100, height: 100)
                            .blur(radius: 20)
                            .offset(x: isHovered ? [-50, 50, 0][index] : 0,
                                    y: isHovered ? [-30, 30, 40][index] : 0)
                            .animation(.easeInOut(duration: [2, 2.5, 3][index]).repeatForever(autoreverses: true), 
                                     value: isHovered)
                    }
                    
                    // Glass effect
                    Rectangle()
                        .fill(.white.opacity(0.1))
                        .blur(radius: 3)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: isHovered ? 0.15 : 0.1),
                    radius: isHovered ? 15 : 10,
                    x: 0,
                    y: isHovered ? 8 : 5)
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation {
                isHovered = hovering
            }
        }
    }
    
    private func getGradient(for type: MenuCardItem.ItemType) -> LinearGradient {
        switch type {
        case .shop:
            return BoxWallColors.gradients.shop
        case .expert:
            return BoxWallColors.gradients.expert
        case .sustainability:
            return BoxWallColors.gradients.sustainability
        case .inventory:
            return BoxWallColors.gradients.inventory
        case .news:
            return BoxWallColors.gradients.news
        case .reflex:
            return LinearGradient(
                colors: [Color(hex: "#4158D0"), Color(hex: "#C850C0")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

#Preview {
    DashboardCard(
        menuItem: MenuCardItem.samples[0],
        action: {}
    )
    .frame(height: 160)
    .padding()
} 