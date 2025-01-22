import SwiftUI

/// A card component used in the dashboard to display menu items
/// with consistent styling and interaction feedback.
struct DashboardCard: View {
    /// The menu item data to display in the card
    let menuItem: MenuCardItem
    
    /// Action to perform when the card is tapped
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 16) {
                // Icon
                Image(systemName: menuItem.icon)
                    .font(.system(size: 32, weight: .light))
                    .foregroundColor(.white)
                    .symbolRenderingMode(.hierarchical)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 8) {
                    // Title
                    Text(menuItem.title)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
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
                    
                    // Glass effect
                    Rectangle()
                        .fill(.white.opacity(0.1))
                        .blur(radius: 3)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.1), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(.scale)
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