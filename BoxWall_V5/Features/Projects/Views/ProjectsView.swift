import SwiftUI

// MARK: - Models
struct Project: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let status: ProjectStatus
    let customer: String?
    let location: String?
}

enum ProjectStatus: String {
    case draft = "Draft"
    case inProgress = "In Progress"
    case completed = "Completed"
    case underReview = "Under Review"
}

// MARK: - ViewModel
class ProjectViewModel: ObservableObject {
    @Published var projects: [Project] = []
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?
    
    @MainActor
    func loadProjects() async {
        isLoading = true
        defer { isLoading = false }
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Load sample data
        projects = [
            Project(
                name: "Cissi Klein School",
                description: "School renovation project",
                status: .inProgress,
                customer: "Trøndelag Fylkeskommune",
                location: "Trondheim, Norway"
            ),
            Project(
                name: "Medical Center",
                description: "Soundproof walls for examination rooms",
                status: .draft,
                customer: "Oslo Hospital",
                location: "Oslo"
            )
        ]
    }
}

// MARK: - Views
struct ProjectsView: View {
    @StateObject private var viewModel = ProjectViewModel()
    @State private var currentMenuIndex = 0
    @State private var showingQuoteForm = false
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    private var isIPad: Bool {
        horizontalSizeClass == .regular
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
    
    private var horizontalPadding: CGFloat {
        isIPad ? DesignSystem.Layout.paddingLarge : DesignSystem.Layout.paddingMedium
    }
    
    private var menuItemWidth: CGFloat {
        isIPad ? 0.45 : 0.80  // 45% of screen width on iPad, 80% on iPhone
    }
    
    private var menuItemHeight: CGFloat {
        isIPad ? 220 : 180
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                // Main background
                BoxWallColors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: DesignSystem.Layout.spacing) {
                        // Welcome Section
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Projects and Quotes")
                                .font(isIPad ? .title : BoxWallTypography.title2)
                                .foregroundColor(BoxWallColors.textPrimary)
                            
                            Text("Manage your BoxWall Projects")
                                .font(BoxWallTypography.subheadline)
                                .foregroundColor(BoxWallColors.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, horizontalPadding)
                        .padding(.top, 8)
                        
                        // Project Menu Carousel
                        if isIPad {
                            // Grid layout for iPad
                            LazyVGrid(columns: gridColumns, spacing: 24) {
                                ForEach(ProjectMenuItem.items) { item in
                                    Button {
                                        if item.type == .quote {
                                            showingQuoteForm = true
                                        }
                                    } label: {
                                        ProjectMenuCard(menuItem: item)
                                            .frame(height: menuItemHeight)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, horizontalPadding)
                        } else {
                            // Carousel for iPhone
                            CarouselView(
                                items: ProjectMenuItem.items,
                                itemWidth: menuItemWidth,
                                itemHeight: menuItemHeight,
                                spacing: 16
                            ) { item in
                                Button {
                                    if item.type == .quote {
                                        showingQuoteForm = true
                                    }
                                } label: {
                                    ProjectMenuCard(menuItem: item)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        
                        // Projects List
                        VStack(alignment: .leading, spacing: DesignSystem.Layout.spacing) {
                            HStack {
                                Text("Your Projects")
                                    .font(isIPad ? .title2 : BoxWallTypography.title2)
                                    .foregroundColor(BoxWallColors.textPrimary)
                                
                                Spacer()
                            }
                            
                            if viewModel.isLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            } else {
                                LazyVGrid(
                                    columns: isIPad ? gridColumns : [GridItem(.flexible())],
                                    spacing: DesignSystem.Layout.paddingSmall
                                ) {
                                    ForEach(viewModel.projects) { project in
                                        ProjectRowView(project: project, isIPad: isIPad)
                                    }
                                }
                            }
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
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.loadProjects()
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error")
            }
            .sheet(isPresented: $showingQuoteForm) {
                QuoteRequestForm()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ProjectRowView: View {
    let project: Project
    let isIPad: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(project.name)
                    .font(isIPad ? .headline : BoxWallTypography.headline)
                    .foregroundColor(BoxWallColors.textPrimary)
                Spacer()
                Text(project.status.rawValue)
                    .font(BoxWallTypography.subheadline)
                    .foregroundColor(BoxWallColors.textSecondary)
            }
            
            Text(project.description)
                .font(BoxWallTypography.subheadline)
                .foregroundColor(BoxWallColors.textSecondary)
            
            if let customer = project.customer {
                Text("Customer: \(customer)")
                    .font(BoxWallTypography.caption)
                    .foregroundColor(BoxWallColors.textSecondary)
            }
            
            if let location = project.location {
                Text("Location: \(location)")
                    .font(BoxWallTypography.caption)
                    .foregroundColor(BoxWallColors.textSecondary)
            }
        }
        .padding(DesignSystem.Layout.paddingMedium)
        .background(BoxWallColors.secondaryBackground)
        .cornerRadius(DesignSystem.Layout.cornerRadius)
    }
}

#Preview {
    ProjectsView()
} 