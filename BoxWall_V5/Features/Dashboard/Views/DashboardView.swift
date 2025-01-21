import SwiftUI

struct DashboardView: View {
    // MARK: - Properties
    @StateObject private var viewModel = DashboardViewModel()
    @Environment(\.colorScheme) private var colorScheme
    @State private var scrollOffset: CGFloat = 0
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            GeometryReader { proxy in
                Color.clear.preference(
                    key: ScrollOffsetPreferenceKey.self,
                    value: proxy.frame(in: .named("scroll")).minY
                )
            }
            .frame(height: 0)
            
            VStack(spacing: DesignSystem.Layout.spacing * 2) {
                // Top Bar with blur effect
                topBar
                    .padding(.top, DesignSystem.Layout.paddingLarge)
                    .background(
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .opacity(scrollOffset < 0 ? 1 : 0)
                            .animation(.easeOut(duration: 0.2), value: scrollOffset)
                    )
                
                // Welcome Section with parallax
                welcomeSection
                    .padding(.top, DesignSystem.Layout.paddingMedium)
                    .scaleEffect(scrollOffset > 0 ? 1 + scrollOffset/1000 : 1)
                    .opacity(scrollOffset < -200 ? 0 : 1)
                
                // Carousel
                carouselSection
                
                // Recent Activity
                activitySection
                    .padding(.top, DesignSystem.Layout.paddingLarge)
            }
            .padding(.horizontal)
        }
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            scrollOffset = value
        }
        .sheet(isPresented: $viewModel.showingUserSettings) {
            Text("User Settings") // Placeholder for now
        }
        .sheet(isPresented: $viewModel.showingAllActivities) {
            ActivityListView()
        }
    }
    
    // MARK: - View Components
    private var topBar: some View {
        HStack {
            // User Profile Button
            Button(action: { viewModel.showUserSettings() }) {
                Image(systemName: "person.circle.fill")
                    .font(BoxWallTypography.icon(size: 24))
                    .foregroundColor(BoxWallColors.textPrimary)
                    .symbolRenderingMode(.hierarchical)
            }
            
            Spacer()
            
            // BOXWALL Logo
            Text("BOXWALL")
                .font(BoxWallTypography.headline)
                .foregroundColor(BoxWallColors.textPrimary)
            
            Spacer()
            
            // Using the standalone NotificationButton component
            NotificationButton(count: viewModel.unreadNotifications)
        }
    }
    
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Welcome Back!")
                .font(BoxWallTypography.title1)
                .foregroundColor(BoxWallColors.textPrimary)
            
            Text("Here's your BoxWall overview")
                .font(BoxWallTypography.body)
                .foregroundColor(BoxWallColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var carouselSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Layout.spacing) {
            CarouselView(
                items: viewModel.menuItems,
                itemHeight: DesignSystem.Layout.BoxHeight.small.value
            ) { item in
                DashboardCard(
                    menuItem: item,
                    action: { viewModel.handleMenuAction(for: item) }
                )
            }
        }
    }
    
    private var activitySection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Layout.spacing) {
            HStack {
                Text("Recent Activity")
                    .font(BoxWallTypography.title2)
                    .foregroundColor(BoxWallColors.textPrimary)
                
                Button(action: { viewModel.showAllActivities() }) {
                    Text("See All")
                        .font(BoxWallTypography.subheadline)
                        .foregroundColor(BoxWallColors.primary)
                }
            }
            
            ActivityList(
                activities: Array(viewModel.recentActivities.prefix(3)),
                viewModel: viewModel
            )
        }
    }
}

// MARK: - Preview
#Preview {
    DashboardView()
}

// Preference Key for scroll tracking
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
} 
