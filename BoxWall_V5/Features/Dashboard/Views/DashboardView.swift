import SwiftUI

struct DashboardView: View {
    // MARK: - Properties
    @StateObject private var viewModel = DashboardViewModel()
    @StateObject private var newsViewModel = NewsViewModel()
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    let switchToShop: () -> Void
    let switchToCO2: () -> Void
    
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
    
    private var gridColumns: [GridItem] {
        if isIPad {
            [
                GridItem(.flexible(), spacing: 24),
                GridItem(.flexible(), spacing: 24)
            ]
        } else {
            [GridItem(.flexible())]
        }
    }
    
    private var menuItemHeight: CGFloat {
        isIPad ? 220 : 180
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Main background
                BoxWallColors.background
                    .ignoresSafeArea()
                
                // Content
                ScrollView {
                    VStack(spacing: DesignSystem.Layout.paddingSmall) {
                        // Top Bar
                        topBar
                        
                        // Main Content
                        VStack(spacing: DesignSystem.Layout.paddingSmall) {
                            welcomeSection
                                .padding(.top, 8)
                            
                            // Quick Actions Section
                            if isIPad {
                                // Grid layout for iPad
                                LazyVGrid(columns: gridColumns, spacing: 24) {
                                    ForEach(viewModel.menuItems) { item in
                                        DashboardCard(
                                            menuItem: item,
                                            action: { 
                                                switch item.type {
                                                case .shop:
                                                    switchToShop()
                                                case .sustainability:
                                                    switchToCO2()
                                                default:
                                                    viewModel.handleMenuAction(for: item)
                                                }
                                            }
                                        )
                                        .frame(height: menuItemHeight)
                                    }
                                }
                                .padding(.horizontal, horizontalPadding)
                            } else {
                                // Carousel for iPhone
                                CarouselView.dashboard(
                                    items: viewModel.menuItems,
                                    onItemSelected: { item in
                                        switch item.type {
                                        case .shop:
                                            switchToShop()
                                        case .sustainability:
                                            switchToCO2()
                                        default:
                                            viewModel.handleMenuAction(for: item)
                                        }
                                    }
                                )
                                .padding(.bottom, 4)
                            }
                            
                            // Recent Activity
                            VStack(alignment: .leading, spacing: DesignSystem.Layout.paddingSmall) {
                                HStack {
                                    Text("Recent Activity")
                                        .font(isIPad ? .title2 : .system(size: 24, weight: .bold))
                                        .foregroundColor(BoxWallColors.textPrimary)
                                    
                                    Spacer()
                                    
                                    Button(action: { viewModel.showAllActivities() }) {
                                        Text("See All")
                                            .font(.system(size: 17))
                                            .foregroundColor(BoxWallColors.Brand.green)
                                    }
                                }
                                .padding(.bottom, 4)
                                
                                if isIPad {
                                    // Grid layout for activities on iPad
                                    ScrollView {
                                        ScrollViewReader { proxy in
                                            LazyVGrid(columns: gridColumns, spacing: 16) {
                                                ForEach(Array(viewModel.recentActivities.prefix(4))) { activity in
                                                    ActivityRow(
                                                        activity: activity,
                                                        viewModel: viewModel,
                                                        scrollProxy: proxy
                                                    )
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    // Stack layout for iPhone
                                    ActivityList(
                                        activities: Array(viewModel.recentActivities.prefix(3)),
                                        viewModel: viewModel
                                    )
                                }
                            }
                            .padding(.top, 16)
                        }
                        .padding(.horizontal, horizontalPadding)
                    }
                }
                
                // Top safe area overlay with blur
                BoxWallColors.background
                    .frame(height: 47)
                    .background(.ultraThinMaterial)
                    .ignoresSafeArea()
            }
        }
        .sheet(isPresented: $viewModel.showingUserSettings) {
            NavigationStack {
                UserSettingsView()
            }
        }
        .sheet(isPresented: $viewModel.showingAllActivities) {
            NavigationStack {
                ActivityListView(viewModel: viewModel)
            }
        }
        .sheet(isPresented: $viewModel.showingNews) {
            NavigationStack {
                NewsView()
            }
        }
    }
    
    // MARK: - View Components
    private var topBar: some View {
        HStack {
            Button(action: { viewModel.showUserSettings() }) {
                Image(systemName: "person.circle.fill")
                    .font(BoxWallTypography.icon(size: 28))
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
        .padding(.horizontal, horizontalPadding)
        .frame(height: 44)
        .padding(.top, 24)
    }
    
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Welcome Back!")
                .font(isIPad ? .title : BoxWallTypography.title2)
                .foregroundColor(BoxWallColors.textPrimary)
            
            Text("Here's your BoxWall overview")
                .font(BoxWallTypography.subheadline)
                .foregroundColor(BoxWallColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
    DashboardView(switchToShop: {}, switchToCO2: {})
}

// Preference Key for scroll tracking
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
} 
