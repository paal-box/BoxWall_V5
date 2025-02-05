import SwiftUI

struct ContactSupportView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: DashboardViewModel
    let activity: Activity
    @State private var message = ""
    @State private var selectedCategory = SupportCategory.general
    
    enum SupportCategory: String, CaseIterable {
        case general = "General Inquiry"
        case technical = "Technical Support"
        case scheduling = "Scheduling"
        case installation = "Installation"
    }
    
    init(activity: Activity, viewModel: DashboardViewModel) {
        self.activity = activity
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DesignSystem.Layout.spacing) {
                    // Activity Reference Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Reference: \(activity.id)")
                            .font(BoxWallTypography.caption)
                            .foregroundColor(BoxWallColors.textSecondary)
                        
                        Text(activity.title)
                            .font(BoxWallTypography.headline)
                            .foregroundColor(BoxWallColors.textPrimary)
                        
                        Text(activity.description)
                            .font(BoxWallTypography.subheadline)
                            .foregroundColor(BoxWallColors.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        if let projectNumber = activity.projectNumber {
                            Text("Project #\(projectNumber)")
                                .font(BoxWallTypography.caption)
                                .foregroundColor(BoxWallColors.textSecondary)
                        }
                    }
                    .padding()
                    .background(BoxWallColors.secondaryBackground)
                    .cornerRadius(DesignSystem.Layout.cornerRadius)
                    
                    // Support Category Selection
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category")
                            .font(BoxWallTypography.subheadline)
                            .foregroundColor(BoxWallColors.textSecondary)
                        
                        HStack(spacing: 8) {
                            ForEach(SupportCategory.allCases, id: \.self) { category in
                                Button {
                                    selectedCategory = category
                                } label: {
                                    Text(category.rawValue)
                                        .font(BoxWallTypography.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(
                                            selectedCategory == category ?
                                            BoxWallColors.primary :
                                            BoxWallColors.secondaryBackground
                                        )
                                        .foregroundColor(
                                            selectedCategory == category ?
                                            .white :
                                            BoxWallColors.textPrimary
                                        )
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.bottom, 8)
                    }
                    
                    // Message Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Message")
                            .font(BoxWallTypography.subheadline)
                            .foregroundColor(BoxWallColors.textSecondary)
                        
                        TextEditor(text: $message)
                            .frame(minHeight: 120)
                            .padding(8)
                            .background(BoxWallColors.secondaryBackground)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(BoxWallColors.textSecondary.opacity(0.2), lineWidth: 1)
                            )
                    }
                    
                    // Submit Button
                    Button {
                        viewModel.contactSupport(for: activity, message: message)
                        dismiss()
                    } label: {
                        Text("Submit Request")
                            .font(BoxWallTypography.body.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                message.isEmpty ?
                                BoxWallColors.textSecondary :
                                BoxWallColors.success
                            )
                            .cornerRadius(12)
                    }
                    .disabled(message.isEmpty)
                }
                .padding()
            }
            .navigationTitle("Contact Support")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(BoxWallColors.textSecondary)
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