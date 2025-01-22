import SwiftUI

struct DashboardView: View {
    // MARK: - Properties
    @StateObject private var viewModel = DashboardViewModel()
    @Environment(\.colorScheme) private var colorScheme
    @State private var scrollOffset: CGFloat = 0
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: 0) {
                    // Top Bar
                    topBar
                        .padding(.horizontal)
                        .background(
                            BoxWallColors.background
                                .ignoresSafeArea()
                        )
                    
                    // Welcome Section
                    welcomeSection
                        .padding(.horizontal)
                        .padding(.top, DesignSystem.Layout.paddingSmall)
                    
                    // Menu Cards
                    menuSection
                        .padding(.top, DesignSystem.Layout.paddingMedium)
                    
                    // Recent Activity
                    activitySection
                        .padding(.top, DesignSystem.Layout.paddingMedium)
                }
                .background(GeometryReader { proxy in
                    Color.clear.preference(
                        key: ScrollOffsetPreferenceKey.self,
                        value: proxy.frame(in: .named("scroll")).minY
                    )
                })
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                scrollOffset = value
            }
            .background(BoxWallColors.groupedBackground.ignoresSafeArea())
            
            // Black status bar overlay
            Color.black
                .frame(height: 47) // Status bar height
                .ignoresSafeArea()
        }
        .sheet(isPresented: $viewModel.showingUserSettings) {
            UserSettingsView()
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
            Image(colorScheme == .dark ? "boxwall-logo-white" : "boxwall-logo-black")
                .resizable()
                .scaledToFit()
                .frame(height: 20)
            
            Spacer()
            
            // Using the standalone NotificationButton component
            NotificationButton(count: viewModel.unreadNotifications)
        }
        .padding(.horizontal)
        .frame(height: 44)
        .padding(.top, 47) // Account for status bar height
    }
    
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Welcome Back!")
                .font(BoxWallTypography.title1)
                .foregroundColor(BoxWallColors.textPrimary)
            
            Text("Here's your BoxWall overview")
                .font(BoxWallTypography.body)
                .foregroundColor(BoxWallColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8) // Add some space after top bar
    }
    
    private var menuSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Layout.spacing) {
            CarouselView(
                items: viewModel.menuItems,
                itemWidth: 0.85,
                itemHeight: 220
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
                    .padding(.horizontal)
                
                Spacer()
                
                Button(action: { viewModel.showAllActivities() }) {
                    Text("See All")
                        .font(BoxWallTypography.subheadline)
                        .foregroundColor(BoxWallColors.primary)
                }
                .padding(.horizontal)
            }
            
            ActivityList(
                activities: Array(viewModel.recentActivities.prefix(3)),
                viewModel: viewModel
            )
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear
                .frame(height: DesignSystem.Layout.tabBarHeight)
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
