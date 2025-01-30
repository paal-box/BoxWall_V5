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
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 8) {
                    // Title
                    Text(menuItem.title)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                    
                    // Description
                    Text(menuItem.description)
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                        .lineLimit(2)
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(
                ZStack {
                    // Base gradient
                    getGradient(for: menuItem.type)
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
            .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation {
                isHovered = hovering
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.5).repeatForever(autoreverses: true)) {
                iconScale = 1.05
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
                startPoint: .leading,
                endPoint: .trailing
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