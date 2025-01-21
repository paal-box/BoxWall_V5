import SwiftUI

struct ContactSupportView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: DashboardViewModel
    let activity: Activity
    @State private var message = ""
    
    init(activity: Activity, viewModel: DashboardViewModel) {
        self.activity = activity
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Message") {
                    TextEditor(text: $message)
                        .frame(height: 100)
                }
                
                Section {
                    Button("Send") {
                        viewModel.contactSupport(for: activity, message: message)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Contact Support")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    ContactSupportView(
        activity: Activity.samples[0],
        viewModel: DashboardViewModel()
    )
} 