import SwiftUI
import UniformTypeIdentifiers

struct QuoteRequestForm: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ProjectViewModel()
    
    // Project Details
    @State private var projectName = ""
    @State private var buildingType = "Office"
    @State private var projectDescription = ""
    
    // Location
    @State private var streetAddress = ""
    @State private var city = ""
    @State private var postalCode = ""
    
    // Wall Requirements
    @State private var projectType = ProjectType.newConstruction
    @State private var installationScope = InstallationScope.entireFloor
    @State private var totalWallArea = ""
    @State private var ceilingHeight: Double = 230 // Starting at 230cm
    @State private var wallType = WallType.solid
    @State private var noiseRequirement = NoiseRequirement.standard
    @State private var additionalFeatures = AdditionalFeatures()
    @State private var expectedInstallationDate = Date()
    
    // Contact
    @State private var contactName = ""
    @State private var email = ""
    @State private var phone = ""
    
    // Documents
    @State private var documents: [SupportingDocument] = []
    @State private var showingDocumentPicker = false
    
    private let buildingTypes = ["Office", "Hospitality", "Medical", "Retail", "Other"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("Request a quote for your BoxWall project. We'll review your requirements and get back to you with a detailed quote.")
                        .foregroundColor(BoxWallColors.textSecondary)
                }
                
                Section("PROJECT DETAILS") {
                    TextField("Project Name", text: $projectName)
                    Picker("Building Type", selection: $buildingType) {
                        ForEach(buildingTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    TextField("Project Description", text: $projectDescription, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("INSTALLATION LOCATION") {
                    TextField("Street Address", text: $streetAddress)
                    TextField("City", text: $city)
                    TextField("Postal Code", text: $postalCode)
                }
                
                Section("WALL REQUIREMENTS") {
                    Picker("Project Type", selection: $projectType) {
                        ForEach(ProjectType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    
                    Picker("Installation Scope", selection: $installationScope) {
                        ForEach(InstallationScope.allCases, id: \.self) { scope in
                            Text(scope.rawValue).tag(scope)
                        }
                    }
                    
                    TextField("Total Wall Area (m²)", text: $totalWallArea)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Ceiling Height")
                            Spacer()
                            Text("\(Int(ceilingHeight))cm")
                                .foregroundColor(BoxWallColors.textSecondary)
                        }
                        
                        Slider(value: $ceilingHeight, in: 230...400, step: 10)
                            .tint(BoxWallColors.primary)
                    }
                    
                    Picker("Preferred Wall Type", selection: $wallType) {
                        ForEach(WallType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Picker("Noise Requirement", selection: $noiseRequirement) {
                            ForEach(NoiseRequirement.allCases, id: \.self) { requirement in
                                VStack(alignment: .leading) {
                                    Text(requirement.description)
                                    Text(requirement.details)
                                        .font(BoxWallTypography.caption)
                                        .foregroundColor(BoxWallColors.textSecondary)
                                }
                                .tag(requirement)
                            }
                        }
                        .pickerStyle(.navigationLink)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Additional Features Required")
                            .font(BoxWallTypography.subheadline)
                            .foregroundColor(BoxWallColors.textSecondary)
                        
                        ForEach(AdditionalFeatures.allCases, id: \.rawValue) { feature in
                            VStack(alignment: .leading, spacing: 4) {
                                Toggle(feature.description, isOn: Binding(
                                    get: { additionalFeatures.contains(feature) },
                                    set: { isEnabled in
                                        if isEnabled {
                                            additionalFeatures.insert(feature)
                                        } else {
                                            additionalFeatures.remove(feature)
                                        }
                                    }
                                ))
                                
                                if additionalFeatures.contains(feature) {
                                    Text(feature.tooltip)
                                        .font(BoxWallTypography.caption)
                                        .foregroundColor(BoxWallColors.textSecondary)
                                        .padding(.leading, 4)
                                        .transition(.opacity)
                                }
                            }
                        }
                    }
                    
                    DatePicker(
                        "Expected Installation Date",
                        selection: $expectedInstallationDate,
                        displayedComponents: .date
                    )
                }
                
                Section("SUPPORTING DOCUMENTS") {
                    VStack(alignment: .leading, spacing: 8) {
                        Button(action: { showingDocumentPicker = true }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Files")
                            }
                            .foregroundColor(BoxWallColors.success)
                        }
                        
                        Text("Upload floor plans, building layouts, or any relevant project documents to ensure the most accurate quote.")
                            .font(BoxWallTypography.caption)
                            .foregroundColor(BoxWallColors.textSecondary)
                    }
                    
                    ForEach(documents) { document in
                        HStack {
                            Image(systemName: document.type.icon)
                            Text(document.name)
                            Spacer()
                            Text("\(document.size / 1024) KB")
                                .foregroundColor(BoxWallColors.textSecondary)
                        }
                    }
                }
                
                Section("CONTACT INFORMATION") {
                    TextField("Your Name", text: $contactName)
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    TextField("Phone", text: $phone)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                }
                
                Button(action: submitRequest) {
                    Text("Submit Request")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                }
                .listRowBackground(BoxWallColors.primary)
            }
            .navigationTitle("Request Quote")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) { dismiss() }
                        .foregroundColor(BoxWallColors.success)
                }
            }
        }
        .fileImporter(
            isPresented: $showingDocumentPicker,
            allowedContentTypes: [.pdf, .image, .data],
            allowsMultipleSelection: true
        ) { result in
            switch result {
            case .success(let urls):
                for url in urls {
                    guard url.startAccessingSecurityScopedResource() else { continue }
                    defer { url.stopAccessingSecurityScopedResource() }
                    
                    let attributes = try? FileManager.default.attributesOfItem(atPath: url.path)
                    let fileSize = attributes?[.size] as? Int64 ?? 0
                    
                    let document = SupportingDocument(
                        name: url.lastPathComponent,
                        url: url,
                        size: fileSize,
                        type: .other  // You might want to determine the type based on the file extension
                    )
                    documents.append(document)
                }
            case .failure(let error):
                print("Error selecting files:", error)
            }
        }
    }
    
    private func submitRequest() {
        // Create a new project with "Under Review" status
        let project = Project(
            name: projectName,
            description: projectDescription,
            status: .underReview,
            customer: contactName,
            location: "\(city), \(streetAddress)"
        )
        
        // Add the project to the view model
        viewModel.projects.append(project)
        
        // Dismiss the form
        dismiss()
    }
}

#Preview {
    QuoteRequestForm()
} 