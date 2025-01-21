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
        VStack(spacing: DesignSystem.Layout.spacing) {
            ForEach(activities) { activity in
                ActivityRow(
                    activity: activity,
                    viewModel: viewModel
                )
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
    .padding()
} 