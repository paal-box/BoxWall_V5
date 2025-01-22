import SwiftUI

struct ActivityListView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = DashboardViewModel()
    @State private var selectedTab: ActivityTab = .notifications
    @Namespace private var animation
    
    enum ActivityTab {
        case notifications, activity
        
        var title: String {
            switch self {
            case .notifications: return "Notifications"
            case .activity: return "Activity Log"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom segmented control with glass effect
                HStack(spacing: 0) {
                    ForEach([ActivityTab.notifications, .activity], id: \.self) { tab in
                        Button(action: { withAnimation(.spring()) { selectedTab = tab } }) {
                            Text(tab.title)
                                .font(BoxWallTypography.subheadline)
                                .foregroundColor(selectedTab == tab ? BoxWallColors.textPrimary : BoxWallColors.textSecondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                        }
                        .background(
                            ZStack {
                                if selectedTab == tab {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.ultraThinMaterial)
                                        .matchedGeometryEffect(id: "TAB", in: animation)
                                }
                            }
                        )
                    }
                }
                .padding(8)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding()
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                // Content with smooth transitions
                TabView(selection: $selectedTab) {
                    NotificationsView(viewModel: viewModel)
                        .tag(ActivityTab.notifications)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ))
                    
                    ScrollViewReader { proxy in
                        ActivityList(
                            activities: viewModel.allActivities,
                            viewModel: viewModel
                        )
                        .tag(ActivityTab.activity)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ))
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .navigationTitle("Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { 
                        withAnimation(.easeInOut) {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
} 