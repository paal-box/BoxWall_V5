import SwiftUI

struct NotificationsView: View {
    @StateObject private var viewModel: DashboardViewModel
    
    init(viewModel: DashboardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List {
            ForEach(Activity.samples.filter { $0.actionRequired }, id: \.id) { activity in
                ActivityRow(
                    activity: activity,
                    viewModel: viewModel
                )
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    NotificationsView(viewModel: DashboardViewModel())
} 