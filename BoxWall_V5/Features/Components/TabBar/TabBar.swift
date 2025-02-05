import SwiftUI

/// A custom tab bar component that can be used across different views
struct TabBar: View {
    /// The currently selected tab index
    @Binding var selectedTab: Int
    
    /// Tab configuration
    struct TabBarItem {
        let icon: String
        let title: String
        
        static let home = TabBarItem(icon: "house.fill", title: "Home")
        static let shop = TabBarItem(icon: "cart.fill", title: "Shop")
        static let projects = TabBarItem(icon: "folder.fill", title: "Projects")
        static let co2 = TabBarItem(icon: "leaf.fill", title: "CO₂")
        // Add more standard tabs as needed
    }
    
    /// The tabs to display
    let tabs: [TabBarItem]
    
    /// Creates a new tab bar with the specified tabs
    /// - Parameters:
    ///   - selectedTab: Binding to the selected tab index
    ///   - tabs: Array of tab items to display
    init(selectedTab: Binding<Int>, tabs: [TabBarItem] = [.home, .shop, .projects, .co2]) {
        self._selectedTab = selectedTab
        self.tabs = tabs
    }
    
    var body: some View {
        HStack(spacing: DesignSystem.Layout.spacing * 3) {
            ForEach(tabs.indices, id: \.self) { index in
                TabBarButton(
                    icon: tabs[index].icon,
                    title: tabs[index].title,
                    isSelected: selectedTab == index
                ) {
                    withAnimation(DesignSystem.Animation.quick) {
                        selectedTab = index
                    }
                }
            }
        }
        .padding(.horizontal, DesignSystem.Layout.paddingMedium)
        .padding(.vertical, DesignSystem.Layout.paddingSmall)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .overlay(
            Divider()
                .frame(maxWidth: .infinity, maxHeight: 0.5)
                .opacity(0.3),
            alignment: .top
        )
    }
}

// MARK: - Preview
#Preview {
    VStack {
        Spacer()
        TabBar(selectedTab: .constant(0))
    }
} 