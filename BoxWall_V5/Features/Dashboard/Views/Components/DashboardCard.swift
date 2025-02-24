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
                if menuItem.type == .sustainability {
                    // Special layout for sustainability card
                    VStack(alignment: .leading, spacing: 0) {
                        // Top section with icon and indicators
                        HStack(alignment: .top) {
                            // Leaf icon
                            Image(systemName: menuItem.icon)
                                .font(.system(size: iconConfig.size, weight: iconConfig.weight))
                                .foregroundColor(.white)
                                .symbolRenderingMode(.hierarchical)
                                .scaleEffect(isHovered ? 1.1 : 1.0)
                            
                            Spacer()
                            
                            // Stacked indicators
                            if let additionalInfo = menuItem.additionalInfo {
                                VStack(alignment: .trailing, spacing: 4) {
                                    ForEach(additionalInfo, id: \.self) { info in
                                        let components = info.split(separator: " ", maxSplits: 1)
                                        if components.count == 2 {
                                            HStack(spacing: 4) {
                                                Image(String(components[0]))
                                                    .resizable()
                                                    .renderingMode(.template)
                                                    .foregroundColor(.white)
                                                    .frame(width: 16, height: 16)
                                                Text(String(components[1]))
                                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                                    .foregroundColor(.white)
                                            }
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 8)
                                            .background(.white.opacity(0.2))
                                            .cornerRadius(20)
                                        }
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        
                        // Title and description at bottom
                        VStack(alignment: .leading, spacing: 4) {
                            Text(menuItem.title)
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text(menuItem.description)
                                .font(.system(size: 15, weight: .regular, design: .rounded))
                                .foregroundColor(.white.opacity(0.9))
                                .lineLimit(1)
                        }
                    }
                } else {
                    // Original layout for other cards
                    Image(systemName: menuItem.icon)
                        .font(.system(size: iconConfig.size, weight: iconConfig.weight))
                        .foregroundColor(.white)
                        .symbolRenderingMode(.hierarchical)
                        .scaleEffect(isHovered ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
                        .padding(.bottom, 8)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(menuItem.title)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                            .lineLimit(1)
                        
                        Text(menuItem.description)
                            .font(.system(size: 15, weight: .regular, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                            .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                        
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
            }
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(
                ZStack {
                    getGradient(for: menuItem.type)
                        .opacity(0.95)
                    
                    Color.white.opacity(0.05)
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
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