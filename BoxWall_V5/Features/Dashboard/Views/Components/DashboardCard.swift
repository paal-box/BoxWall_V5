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
            VStack(alignment: .leading, spacing: 0) {
                // Icon with animation
                Image(systemName: menuItem.icon)
                    .font(.system(size: iconConfig.size, weight: iconConfig.weight))
                    .foregroundColor(.white)
                    .symbolRenderingMode(.hierarchical)
                    .scaleEffect(isHovered ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
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
                    
                    // Additional Info (if available)
                    if let additionalInfo = menuItem.additionalInfo {
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(additionalInfo, id: \.self) { info in
                                Text(info)
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.95))
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 8)
                                    .background(.white.opacity(0.2))
                                    .cornerRadius(4)
                            }
                        }
                        .padding(.top, 4)
                    }
                }
            }
            .padding(20)
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
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
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
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }
}

#Preview {
    DashboardCard(
        menuItem: MenuCardItem.samples[2],  // Using the sustainability card for preview
        action: {}
    )
    .frame(height: 220)
    .padding()
} 