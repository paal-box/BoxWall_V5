import SwiftUI

struct QuoteFormView: View {
    @StateObject private var viewModel = QuoteViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                projectSection
                locationSection
                requirementsSection
                contactSection
            }
            .navigationTitle("Request Quote")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Submit") {
                        Task {
                            await viewModel.submit()
                            dismiss()
                        }
                    }
                    .disabled(!viewModel.isValid || viewModel.isSubmitting)
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "An error occurred")
            }
            .disabled(viewModel.isSubmitting)
            .overlay {
                if viewModel.isSubmitting {
                    ProgressView()
                }
            }
        }
    }
    
    private var projectSection: some View {
        Section("Project Details") {
            TextField("Project Name", text: $viewModel.projectName)
            Picker("Building Type", selection: $viewModel.buildingType) {
                ForEach(QuoteRequest.BuildingType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            TextField("Project Description", text: $viewModel.description, axis: .vertical)
                .lineLimit(3...6)
        }
    }
    
    private var locationSection: some View {
        Section("Installation Location") {
            TextField("Street Address", text: $viewModel.streetAddress)
            TextField("City", text: $viewModel.city)
            TextField("Postal Code", text: $viewModel.postalCode)
            Stepper("Floor Number: \(viewModel.floorNumber)", value: $viewModel.floorNumber, in: 1...100)
        }
    }
    
    private var requirementsSection: some View {
        Section("Wall Requirements") {
            TextField("Total Wall Area (m²)", value: $viewModel.totalWallArea, format: .number)
                .keyboardType(.decimalPad)
            Toggle("Sound Insulation Required", isOn: $viewModel.soundproofingRequired)
            Toggle("Custom Finish Required", isOn: $viewModel.customFinishRequired)
        }
    }
    
    private var contactSection: some View {
        Section("Contact Information") {
            TextField("Your Name", text: $viewModel.contactName)
            TextField("Email", text: $viewModel.email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            TextField("Phone", text: $viewModel.phone)
                .textContentType(.telephoneNumber)
                .keyboardType(.phonePad)
        }
    }
}

#Preview {
    QuoteFormView()
} 