import SwiftUI

struct ContactSupportView: View {
    @StateObject private var viewModel: SupportViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(activity: Activity? = nil) {
        _viewModel = StateObject(wrappedValue: SupportViewModel(activity: activity))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if let activity = viewModel.activity {
                        activityReferenceSection(activity)
                    } else {
                        referenceSection
                    }
                    
                    // Category Selection
                    categorySection
                    
                    // Message Input
                    messageSection
                }
                .padding(.horizontal)
            }
            .background(BoxWallColors.background)
            .navigationTitle("Contact Support")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(BoxWallColors.boxwallGreen)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: submitRequest) {
                        if viewModel.isSubmitting {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Submit")
                                .fontWeight(.semibold)
                        }
                    }
                    .disabled(!viewModel.isValidMessage || viewModel.isSubmitting)
                }
            }
        }
    }
    
    private func activityReferenceSection(_ activity: Activity) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Reference: \(activity.id)")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(activity.title)
                .font(.headline)
            
            Text(activity.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            
            if let projectNumber = activity.projectNumber {
                Text("Project #\(projectNumber)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(activity.priority.color)
                Text(String(describing: activity.priority).capitalized)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(BoxWallColors.secondaryBackground.opacity(0.5))
        .cornerRadius(12)
    }
    
    private var referenceSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Reference")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("REF-001")
                .font(.system(.body, design: .monospaced))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(BoxWallColors.secondaryBackground.opacity(0.5))
        .cornerRadius(12)
    }
    
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Category")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                // Visual indicator for scrolling
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                    Text("Scroll")
                    Image(systemName: "chevron.right")
                }
                .font(.caption)
                .foregroundColor(BoxWallColors.textSecondary.opacity(0.6))
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(SupportCategory.allCases, id: \.self) { category in
                        CategoryButton(
                            category: category,
                            isSelected: viewModel.selectedCategory == category,
                            action: { viewModel.selectedCategory = category }
                        )
                    }
                }
                .padding(.horizontal, 4)
                // Add horizontal padding to show part of the next item
                .padding(.trailing, 40)
            }
            // Add gradient masks to indicate more content
            .mask(
                HStack(spacing: 0) {
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black, .black]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: 20)
                    
                    Rectangle()
                    
                    LinearGradient(
                        gradient: Gradient(colors: [.black, .black, .clear]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: 20)
                }
            )
        }
    }
    
    private var messageSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Message")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(viewModel.messageCharacterCount)/\(SupportRequest.maximumMessageLength)")
                    .font(.caption)
                    .foregroundColor(
                        viewModel.isValidMessage ? .secondary :
                            viewModel.messageCharacterCount > SupportRequest.maximumMessageLength ? .red : .orange
                    )
            }
            
            TextEditor(text: Binding(
                get: { viewModel.message },
                set: { newValue in
                    // Enforce character limit
                    if newValue.count <= SupportRequest.maximumMessageLength {
                        viewModel.message = newValue
                    } else {
                        viewModel.message = String(newValue.prefix(SupportRequest.maximumMessageLength))
                    }
                }
            ))
            .frame(minHeight: 120)
            .padding(12)
            .background(BoxWallColors.secondaryBackground.opacity(0.5))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        viewModel.error == .invalidMessage ?
                            Color.red.opacity(0.5) :
                            BoxWallColors.Brand.green.opacity(0.2),
                        lineWidth: 1
                    )
            )
            
            if viewModel.messageCharacterCount < SupportRequest.minimumMessageLength {
                Text("Please enter at least \(SupportRequest.minimumMessageLength) characters")
                    .font(.caption)
                    .foregroundColor(.orange)
            }
            
            if let error = viewModel.error {
                Text(error.localizedDescription)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
    
    private func submitRequest() {
        Task {
            if await viewModel.submitRequest() {
                dismiss()
            }
        }
    }
}

struct CategoryButton: View {
    let category: SupportCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.system(size: 14))
                Text(category.rawValue)
                    .lineLimit(1)
            }
            .font(.subheadline)
            .foregroundColor(isSelected ? .white : BoxWallColors.textPrimary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? BoxWallColors.Brand.green : BoxWallColors.secondaryBackground.opacity(0.5))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(
                        isSelected ? Color.clear : BoxWallColors.textSecondary.opacity(0.2),
                        lineWidth: 1
                    )
            )
            // Add shadow to selected item
            .shadow(
                color: isSelected ? BoxWallColors.Brand.green.opacity(0.3) : .clear,
                radius: 4,
                y: 2
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview("General Support") {
    ContactSupportView()
}

#Preview("Activity Support") {
    ContactSupportView(activity: Activity.samples.first!)
} 