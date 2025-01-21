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
            VStack(alignment: .leading, spacing: 12) {
                // Icon
                Image(systemName: menuItem.icon)
                    .font(BoxWallTypography.icon(size: 24))
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 4) {
                    // Title
                    Text(menuItem.title)
                        .font(BoxWallTypography.headline)
                        .foregroundColor(.white)
                    
                    // Description
                    Text(menuItem.description)
                        .font(BoxWallTypography.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(2)
                }
            }
            .padding(16)
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
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
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