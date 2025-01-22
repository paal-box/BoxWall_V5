import SwiftUI

struct NotificationsView: View {
    @StateObject private var viewModel: DashboardViewModel
    
    init(viewModel: DashboardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            List {
                ForEach(Activity.samples.filter { $0.actionRequired }, id: \.id) { activity in
                    ActivityRow(
                        activity: activity,
                        viewModel: viewModel,
                        scrollProxy: proxy
                    )
                    .id("activity-\(activity.id)")
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }
                
                // Add bottom spacing to account for tab bar
                Color.clear
                    .frame(height: DesignSystem.Layout.tabBarHeight)
                    .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    NotificationsView(viewModel: DashboardViewModel())
} 