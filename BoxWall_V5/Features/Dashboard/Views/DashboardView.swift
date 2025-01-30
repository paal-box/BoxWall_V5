import SwiftUI

struct DashboardView: View {
    // MARK: - Properties
    @StateObject private var viewModel = DashboardViewModel()
    @StateObject private var newsViewModel = NewsViewModel()
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var scrollOffset: CGFloat = 0
    
    // MARK: - Computed Properties
    private var isIPad: Bool {
        horizontalSizeClass == .regular
    }
    
    private var contentMaxWidth: CGFloat {
        isIPad ? 1200 : .infinity
    }
    
    private var horizontalPadding: CGFloat {
        isIPad ? DesignSystem.Layout.paddingLarge : DesignSystem.Layout.paddingMedium
    }
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: 0) {
                    // Top Bar
                    topBar
                        .padding(.horizontal, horizontalPadding)
                        .background(
                            BoxWallColors.background
                                .ignoresSafeArea()
                        )
                    
                    if isIPad {
                        // iPad Layout
                        VStack(spacing: DesignSystem.Layout.paddingLarge) {
                            // Welcome Section
                            welcomeSection
                                .padding(.top, DesignSystem.Layout.paddingMedium)
                            
                            // Quick Actions Carousel - Full Width
                            VStack(alignment: .leading, spacing: DesignSystem.Layout.paddingMedium) {
                                Text("Quick Actions")
                                    .font(BoxWallTypography.title2)
                                    .foregroundColor(BoxWallColors.textPrimary)
                                
                                menuSection
                            }
                            
                            // Two Column Layout
                            HStack(alignment: .top, spacing: DesignSystem.Layout.paddingLarge) {
                                // Recent Activity - Left Column
                                VStack {
                                    activitySection
                                }
                                .frame(maxWidth: .infinity)
                                .background(BoxWallColors.background)
                                .cornerRadius(DesignSystem.Layout.cornerRadius)
                                
                                // News Feed - Right Column
                                VStack(alignment: .leading, spacing: DesignSystem.Layout.spacing) {
                                    HStack {
                                        Text("Latest News")
                                            .font(BoxWallTypography.title2)
                                            .foregroundColor(BoxWallColors.textPrimary)
                                        
                                        Spacer()
                                        
                                        Button(action: { viewModel.showingNews = true }) {
                                            Text("See All")
                                                .font(BoxWallTypography.subheadline)
                                                .foregroundColor(BoxWallColors.primary)
                                        }
                                    }
                                    .padding(.horizontal)
                                    
                                    if newsViewModel.isLoading {
                                        ProgressView()
                                            .frame(maxWidth: .infinity, minHeight: 200)
                                    } else {
                                        ScrollView {
                                            LazyVStack(spacing: DesignSystem.Layout.spacing) {
                                                ForEach(newsViewModel.articles.prefix(5)) { article in
                                                    NewsArticleCard(article: article)
                                                        .onTapGesture {
                                                            newsViewModel.openArticle(article)
                                                        }
                                                }
                                            }
                                            .padding(.horizontal)
                                        }
                                        .frame(maxHeight: 600) // Limit height for iPad
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .background(BoxWallColors.background)
                                .cornerRadius(DesignSystem.Layout.cornerRadius)
                            }
                        }
                        .padding(.horizontal, horizontalPadding)
                    } else {
                        // iPhone Layout
                        welcomeSection
                            .padding(.horizontal)
                            .padding(.top, DesignSystem.Layout.paddingSmall)
                        
                        menuSection
                            .padding(.top, DesignSystem.Layout.paddingMedium)
                        
                        activitySection
                            .padding(.top, DesignSystem.Layout.paddingMedium)
                            .safeAreaInset(edge: .bottom) {
                                Color.clear
                                    .frame(height: DesignSystem.Layout.tabBarHeight)
                            }
                    }
                }
                .frame(maxWidth: contentMaxWidth)
                .frame(maxWidth: .infinity)
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
        .sheet(isPresented: $viewModel.showingNews) {
            NewsView()
        }
    }
    
    // MARK: - View Components
    private var topBar: some View {
        HStack {
            // User Profile Button
            Button(action: { viewModel.showUserSettings() }) {
                Image(systemName: "person.circle.fill")
                    .font(BoxWallTypography.icon(size: isIPad ? 28 : 24))
                    .foregroundColor(BoxWallColors.textPrimary)
                    .symbolRenderingMode(.hierarchical)
            }
            
            Spacer()
            
            // BOXWALL Logo
            Image(colorScheme == .dark ? "boxwall-logo-white" : "boxwall-logo-black")
                .resizable()
                .scaledToFit()
                .frame(height: isIPad ? 38 : 24)
                .padding(.vertical, isIPad ? 8 : 4)
            
            Spacer()
            
            // Using the standalone NotificationButton component
            NotificationButton(count: viewModel.unreadNotifications)
        }
        .padding(.horizontal)
        .frame(height: isIPad ? 70 : 44)
        .padding(.top, 47) // Account for status bar height
    }
    
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: isIPad ? 4 : 2) {
            Text("Welcome Back!")
                .font(isIPad ? BoxWallTypography.title1 : BoxWallTypography.headline)
                .foregroundColor(BoxWallColors.textPrimary)
            
            Text("Here's your BoxWall overview")
                .font(isIPad ? BoxWallTypography.subheadline : BoxWallTypography.caption)
                .foregroundColor(BoxWallColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, isIPad ? 8 : 4)
    }
    
    private var menuSection: some View {
        CarouselView(
            items: viewModel.menuItems,
            itemWidth: isIPad ? 0.3 : 0.85,
            itemHeight: isIPad ? 280 : 220
        ) { item in
            DashboardCard(
                menuItem: item,
                action: { viewModel.handleMenuAction(for: item) }
            )
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
                activities: Array(viewModel.recentActivities.prefix(isIPad ? 8 : 3)),
                viewModel: viewModel
            )
        }
        .padding(.vertical, isIPad ? DesignSystem.Layout.paddingMedium : 0)
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
