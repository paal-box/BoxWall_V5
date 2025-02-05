import SwiftUI

struct DashboardView: View {
    // MARK: - Properties
    @StateObject private var viewModel = DashboardViewModel()
    @StateObject private var newsViewModel = NewsViewModel()
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
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
        NavigationStack {
            ZStack(alignment: .top) {
                // Main background
                BoxWallColors.background
                    .ignoresSafeArea()
                
                // Content
                VStack(spacing: DesignSystem.Layout.paddingSmall) {
                    // Top Bar
                    topBar
                    
                    // Main Content
                    VStack(spacing: DesignSystem.Layout.paddingSmall) {
                        welcomeSection
                            .padding(.top, 8)
                        
                        // Quick Actions Carousel
                        menuSection
                        
                        // Recent Activity
                        VStack(alignment: .leading, spacing: DesignSystem.Layout.paddingSmall) {
                            HStack {
                                Text("Recent Activity")
                                    .font(BoxWallTypography.title2)
                                    .foregroundColor(BoxWallColors.textPrimary)
                                
                                Spacer()
                                
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
                    .padding(.horizontal, DesignSystem.Layout.paddingMedium)
                }
                
                // Top safe area overlay with blur
                BoxWallColors.background
                    .frame(height: 47)
                    .background(.ultraThinMaterial)
                    .ignoresSafeArea()
            }
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
            Button(action: { viewModel.showUserSettings() }) {
                Image(systemName: "person.circle.fill")
                    .font(BoxWallTypography.icon(size: 24))
                    .foregroundColor(BoxWallColors.textPrimary)
                    .symbolRenderingMode(.hierarchical)
            }
            
            Spacer()
            
            Image(colorScheme == .dark ? "boxwall-logo-white" : "boxwall-logo-black")
                .resizable()
                .scaledToFit()
                .frame(height: 24)
            
            Spacer()
            
            NotificationButton(count: viewModel.unreadNotifications)
        }
        .padding(.horizontal, DesignSystem.Layout.paddingMedium)
        .frame(height: 44)
        .padding(.top, 24)
    }
    
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Welcome Back!")
                .font(BoxWallTypography.title2)
                .foregroundColor(BoxWallColors.textPrimary)
            
            Text("Here's your BoxWall overview")
                .font(BoxWallTypography.subheadline)
                .foregroundColor(BoxWallColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var menuSection: some View {
        CarouselView.dashboard(
            items: viewModel.menuItems,
            onItemSelected: { item in
                viewModel.handleMenuAction(for: item)
            }
        )
        .padding(.bottom, 4)  // Add a little space before Recent Activity
    }
    
    private var newsSection: some View {
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
                }
                .frame(maxHeight: 600)
            }
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
