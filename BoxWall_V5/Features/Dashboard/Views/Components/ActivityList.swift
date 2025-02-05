import SwiftUI

/// A list component that displays recent activities in a consistent format
struct ActivityList: View {
    /// Array of activities to display
    let activities: [Activity]
    @StateObject private var viewModel: DashboardViewModel
    
    init(activities: [Activity], viewModel: DashboardViewModel) {
        self.activities = activities
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: DesignSystem.Layout.spacing) {
                    ForEach(activities) { activity in
                        ActivityRow(
                            activity: activity,
                            viewModel: viewModel,
                            scrollProxy: proxy
                        )
                        .id("activity-\(activity.id)")
                        .transition(AnyTransition.opacity.combined(with: .move(edge: .leading)))
                    }
                    
                    // Add bottom spacing to account for tab bar
                    Color.clear
                        .frame(height: DesignSystem.Layout.tabBarHeight)
                }
                .animation(.easeInOut(duration: 0.3), value: activities.map { $0.id })
                .padding(.vertical, DesignSystem.Layout.paddingMedium)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ActivityList(
        activities: Activity.samples,
        viewModel: DashboardViewModel()
    )
} 