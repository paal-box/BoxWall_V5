import SwiftUI

/// A reusable tab bar button component
struct TabBarButton: View {
    /// The SF Symbol icon name
    let icon: String
    /// The button title
    let title: String
    /// Whether this tab is currently selected
    let isSelected: Bool
    /// Action to perform when tapped
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(BoxWallTypography.icon(size: 20))
                    .imageScale(.medium)
                    .symbolRenderingMode(.hierarchical)
                
                Text(title)
                    .font(BoxWallTypography.caption)
            }
            .foregroundColor(isSelected ? BoxWallColors.textPrimary : BoxWallColors.textSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? BoxWallColors.secondaryBackground : Color.clear)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
            )
        }
    }
}

// MARK: - Preview
#Preview {
    HStack {
        TabBarButton(
            icon: "house.fill",
            title: "Home",
            isSelected: true,
            action: {}
        )
        TabBarButton(
            icon: "cart.fill",
            title: "Shop",
            isSelected: false,
            action: {}
        )
    }
    .padding()
    .background(.ultraThinMaterial)
} 