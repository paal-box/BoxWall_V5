import SwiftUI
import UniformTypeIdentifiers

struct TalkToBoxWallView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep = 1
    @State private var selectedExpert: ExpertType?
    @State private var selectedScheduleType: ScheduleType?
    @State private var selectedDate = Date()
    @State private var message = ""
    @State private var showingDatePicker = false
    @State private var showingFilePicker = false
    @State private var showingCamera = false
    @State private var attachedFiles: [AttachedFile] = []
    @State private var contactInfo = ContactInfo()
    @State private var validationErrors: Set<ValidationError> = []
    @State private var showingConfirmation = false
    
    struct ContactInfo {
        var name = ""
        var email = ""
        var phone = ""
        var company = ""
        var projectNumber = ""
    }
    
    enum ExpertType: String, CaseIterable {
        case technical = "Technical Expert"
        case architect = "Architect"
        case sales = "Sales Representative"
        
        var icon: String {
            switch self {
            case .technical: return "wrench.and.screwdriver.fill"
            case .architect: return "building.2.fill"
            case .sales: return "chart.line.uptrend.xyaxis"
            }
        }
        
        var description: String {
            switch self {
            case .technical: return "Get technical guidance on installation and specifications"
            case .architect: return "Design consultation and space optimization"
            case .sales: return "Pricing, quotes, and product information"
            }
        }
    }
    
    enum ScheduleType: String, CaseIterable {
        case asap = "ASAP"
        case later = "Schedule Later"
        case email = "Email Follow-Up"
        
        var icon: String {
            switch self {
            case .asap: return "bolt.fill"
            case .later: return "calendar"
            case .email: return "envelope.fill"
            }
        }
        
        var description: String {
            switch self {
            case .asap: return "Connect with next available expert"
            case .later: return "Pick a specific date and time"
            case .email: return "Get information via email"
            }
        }
        
        var color: Color {
            switch self {
            case .asap: return .blue
            case .later: return .orange
            case .email: return .purple
            }
        }
    }
    
    enum ValidationError: String {
        case invalidEmail = "Please enter a valid email address"
        case invalidPhone = "Please enter a valid phone number"
        case invalidName = "Name must be at least 2 characters"
        case messageTooLong = "Message cannot exceed 500 characters"
        case messageTooShort = "Message must be at least 10 characters"
        case noScheduleDate = "Please select a date and time"
    }
    
    struct AttachedFile: Identifiable {
        let id = UUID()
        let name: String
        let type: FileType
        let size: Int64
        let url: URL?
        
        enum FileType: String {
            case pdf = "PDF"
            case image = "Image"
            case document = "Document"
            case dwg = "DWG"
            
            var icon: String {
                switch self {
                case .pdf: return "doc.fill"
                case .image: return "photo.fill"
                case .document: return "doc.text.fill"
                case .dwg: return "ruler.fill"
                }
            }
            
            var color: Color {
                switch self {
                case .pdf: return .red
                case .image: return .blue
                case .document: return .green
                case .dwg: return .orange
                }
            }
            
            static func from(uttype: UTType) -> FileType {
                switch uttype {
                case .pdf:
                    return .pdf
                case .image, .jpeg, .png:
                    return .image
                case .plainText, .rtf:
                    return .document
                default:
                    // Check file extension for document types
                    if uttype.identifier.contains("word") || 
                       uttype.identifier.contains("doc") {
                        return .document
                    }
                    return .document
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Progress Steps
                StepIndicator(currentStep: currentStep, totalSteps: 5)
                    .padding(.top, 8)
                
                ScrollView {
                    VStack(spacing: 24) {
                        if showingConfirmation {
                            confirmationView
                        } else {
                            switch currentStep {
                            case 1:
                                expertSelectionView
                            case 2:
                                scheduleSelectionView
                            case 3:
                                messageView
                            case 4:
                                fileUploadView
                            case 5:
                                contactInfoView
                            default:
                                EmptyView()
                            }
                        }
                    }
                    .padding()
                }
                
                // Bottom buttons
                if !showingConfirmation {
                    if currentStep == 5 {
                        HStack(spacing: 16) {
                            Button(action: { dismiss() }) {
                                Text("Cancel")
                                    .font(.body.weight(.medium))
                                    .foregroundColor(BoxWallColors.textSecondary)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(BoxWallColors.secondaryBackground)
                                    .cornerRadius(12)
                            }
                            
                            Button(action: { submitRequest() }) {
                                Text("Submit")
                                    .font(.body.weight(.medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(BoxWallColors.Brand.green)
                                    .cornerRadius(12)
                            }
                            .disabled(!canProceed)
                            .opacity(canProceed ? 1 : 0.5)
                        }
                        .padding()
                    }
                }
            }
            .background(BoxWallColors.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !showingConfirmation {
                        if currentStep > 1 {
                            Button("Back") {
                                withAnimation {
                                    currentStep -= 1
                                }
                            }
                        } else {
                            Button("Cancel") {
                                dismiss()
                            }
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !showingConfirmation && currentStep < 5 {
                        Button("Next") {
                            withAnimation {
                                currentStep += 1
                            }
                        }
                        .font(.body.weight(.medium))
                        .foregroundColor(BoxWallColors.Brand.green)
                        .opacity(canProceed ? 1 : 0.5)
                        .disabled(!canProceed)
                    }
                }
            }
            .sheet(isPresented: $showingDatePicker) {
                NavigationStack {
                    DatePickerView(selectedDate: $selectedDate)
                }
                .presentationDetents([.medium])
            }
            .sheet(isPresented: $showingFilePicker) {
                DocumentPicker(attachedFiles: $attachedFiles)
            }
            .sheet(isPresented: $showingCamera) {
                ImagePicker(attachedFiles: $attachedFiles)
            }
        }
    }
    
    private var canProceed: Bool {
        switch currentStep {
        case 1: 
            return selectedExpert != nil
        case 2: 
            if selectedScheduleType == .later {
                return selectedDate > Date()
            }
            return selectedScheduleType != nil
        case 3: 
            let trimmedMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmedMessage.count >= 10 && trimmedMessage.count <= 500
        case 4: 
            return true // Files are optional
        case 5: 
            // For the final step, check all previous steps and contact info
            guard
                selectedExpert != nil,
                selectedScheduleType != nil,
                message.trimmingCharacters(in: .whitespacesAndNewlines).count >= 10,
                isValidName,
                isValidEmail,
                isValidPhone
            else {
                return false
            }
            
            // Additional check for scheduled date if "Schedule Later" was selected
            if selectedScheduleType == .later && selectedDate <= Date() {
                return false
            }
            
            return true
        default: 
            return false
        }
    }
    
    private var isValidEmail: Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: contactInfo.email)
    }
    
    private var isValidPhone: Bool {
        let phoneRegex = #"^\+?[0-9]{8,}$"#
        let cleanPhone = contactInfo.phone.replacingOccurrences(of: "[^0-9+]", with: "", options: .regularExpression)
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: cleanPhone)
    }
    
    private var isValidName: Bool {
        let trimmedName = contactInfo.name.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedName.count >= 2 && trimmedName.count <= 50
    }
    
    private var isValidMessage: Bool {
        let trimmedMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedMessage.count >= 10 && trimmedMessage.count <= 500
    }
    
    private var expertSelectionView: some View {
        VStack(spacing: 24) {
            // Step Title
            Text("Choose Your Expert")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .padding(.top, 32)
            
            Text("Select the type of expert you'd like to speak with")
                .font(.system(size: 17, design: .rounded))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Expert Selection Cards
            VStack(spacing: 16) {
                ForEach(ExpertType.allCases, id: \.self) { expert in
                    ExpertCard(
                        expert: expert,
                        isSelected: selectedExpert == expert,
                        action: { selectedExpert = expert }
                    )
                }
            }
            .padding(.top, 16)
        }
    }
    
    private var scheduleSelectionView: some View {
        VStack(spacing: 24) {
            // Step Title
            Text("Schedule Your Call")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .padding(.top, 32)
            
            Text("Choose how you'd like to connect with our expert")
                .font(.system(size: 17, design: .rounded))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Schedule Type Selection
            VStack(spacing: 16) {
                ForEach(ScheduleType.allCases, id: \.self) { type in
                    ScheduleOptionCard(
                        type: type,
                        isSelected: selectedScheduleType == type,
                        selectedDate: selectedDate,
                        action: {
                            selectedScheduleType = type
                            if type == .later {
                                showingDatePicker = true
                            }
                        }
                    )
                }
            }
            .padding(.top, 16)
        }
    }
    
    private var messageView: some View {
        VStack(spacing: 24) {
            // Step Title
            Text("Your Request")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .padding(.top, 32)
            
            Text("Please describe what you need assistance with")
                .font(.system(size: 17, design: .rounded))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                TextEditor(text: $message)
                    .frame(minHeight: 120)
                    .padding(12)
                    .background(BoxWallColors.secondaryBackground)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                !isValidMessage && !message.isEmpty ? Color.red.opacity(0.5) : BoxWallColors.textSecondary.opacity(0.2),
                                lineWidth: 1
                            )
                    )
                
                HStack {
                    Text("\(message.count)/500 characters (minimum 10)")
                        .font(.caption)
                        .foregroundColor(
                            message.count < 10 ? .orange :
                            message.count > 500 ? .red : .secondary
                        )
                    
                    if message.count > 500 {
                        Text("Message is too long")
                            .font(.caption)
                            .foregroundColor(.red)
                    } else if !message.isEmpty && message.count < 10 {
                        Text("Message is too short")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
            }
            .padding(.top, 16)
        }
    }
    
    private var fileUploadView: some View {
        VStack(spacing: 24) {
            // Step Title
            Text("Supporting Files")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .padding(.top, 32)
            
            Text("Add any relevant files to help our expert prepare")
                .font(.system(size: 17, design: .rounded))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Upload Options
            VStack(spacing: 16) {
                // Document Upload Button
                Button {
                    showingFilePicker = true
                } label: {
                    UploadOptionCard(
                        icon: "doc.fill",
                        title: "Upload Files",
                        description: "PDF, DWG, Documents",
                        color: .blue
                    )
                }
                
                // Camera Button
                Button {
                    showingCamera = true
                } label: {
                    UploadOptionCard(
                        icon: "camera.fill",
                        title: "Take Photo",
                        description: "Scan documents or take photos",
                        color: .purple
                    )
                }
            }
            .padding(.top, 16)
            
            // Attached Files List
            if !attachedFiles.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Attached Files")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    ForEach(attachedFiles) { file in
                        AttachedFileRow(file: file) {
                            if let index = attachedFiles.firstIndex(where: { $0.id == file.id }) {
                                withAnimation {
                                    attachedFiles.remove(at: index)
                                }
                            }
                        }
                    }
                }
                .padding(.top, 8)
            }
            
            // Drag & Drop Zone (iPad only)
            if UIDevice.current.userInterfaceIdiom == .pad {
                DragAndDropZone(attachedFiles: $attachedFiles)
                    .padding(.top, 16)
            }
        }
    }
    
    private var contactInfoView: some View {
        VStack(spacing: 24) {
            // Step Title
            Text("Contact Information")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .padding(.top, 32)
            
            Text("How can we reach you?")
                .font(.system(size: 17, design: .rounded))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(spacing: 16) {
                contactField(
                    icon: "person.fill",
                    title: "Name",
                    text: $contactInfo.name,
                    placeholder: "Your full name",
                    isValid: isValidName || contactInfo.name.isEmpty,
                    errorMessage: validationErrors.contains(.invalidName) ? ValidationError.invalidName.rawValue : nil
                )
                
                contactField(
                    icon: "envelope.fill",
                    title: "Email",
                    text: $contactInfo.email,
                    placeholder: "your@email.com",
                    keyboardType: .emailAddress,
                    isValid: isValidEmail || contactInfo.email.isEmpty,
                    errorMessage: validationErrors.contains(.invalidEmail) ? ValidationError.invalidEmail.rawValue : nil
                )
                
                contactField(
                    icon: "phone.fill",
                    title: "Phone",
                    text: $contactInfo.phone,
                    placeholder: "Your phone number",
                    keyboardType: .phonePad,
                    isValid: isValidPhone || contactInfo.phone.isEmpty,
                    errorMessage: validationErrors.contains(.invalidPhone) ? ValidationError.invalidPhone.rawValue : nil
                )
                
                contactField(
                    icon: "building.2.fill",
                    title: "Company",
                    text: $contactInfo.company,
                    placeholder: "Your company name (optional)"
                )
                
                contactField(
                    icon: "number.square.fill",
                    title: "Project Number",
                    text: $contactInfo.projectNumber,
                    placeholder: "Project number (if applicable)"
                )
            }
            .padding(.top, 16)
        }
    }
    
    private func contactField(
        icon: String,
        title: String,
        text: Binding<String>,
        placeholder: String,
        keyboardType: UIKeyboardType = .default,
        isValid: Bool = true,
        errorMessage: String? = nil
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(BoxWallColors.textSecondary)
            
            TextField(placeholder, text: text)
                .textContentType(.none)
                .keyboardType(keyboardType)
                .padding(12)
                .background(BoxWallColors.secondaryBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            isValid ? BoxWallColors.textSecondary.opacity(0.2) : Color.red.opacity(0.5),
                            lineWidth: 1
                        )
                )
            
            if let error = errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
    
    private func submitRequest() {
        // Here you would typically send the request to your backend
        // For now, we'll just show the confirmation
        withAnimation {
            showingConfirmation = true
        }
    }
    
    private var confirmationView: some View {
        VStack(spacing: 32) {
            // Success Icon
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(BoxWallColors.Brand.green)
                .padding(.top, 40)
            
            VStack(spacing: 16) {
                Text("Thank You!")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                
                Text("Your request has been submitted")
                    .font(.system(size: 17, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            // Request Summary
            VStack(spacing: 16) {
                summaryRow(icon: "person.fill", title: "Expert", detail: selectedExpert?.rawValue ?? "")
                
                if let scheduleType = selectedScheduleType {
                    summaryRow(
                        icon: scheduleType.icon,
                        title: "Schedule",
                        detail: scheduleType == .later ? selectedDate.formatted(date: .abbreviated, time: .shortened) : scheduleType.rawValue
                    )
                }
                
                if !attachedFiles.isEmpty {
                    summaryRow(
                        icon: "paperclip",
                        title: "Files",
                        detail: "\(attachedFiles.count) attached"
                    )
                }
            }
            .padding()
            .background(BoxWallColors.secondaryBackground)
            .cornerRadius(16)
            .padding(.horizontal)
            
            Spacer()
            
            // Close Button
            Button(action: { dismiss() }) {
                Text("Close")
                    .font(.body.weight(.medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(BoxWallColors.Brand.green)
                    .cornerRadius(12)
            }
            .padding()
        }
    }
    
    private func summaryRow(icon: String, title: String, detail: String) -> some View {
        HStack {
            Label(title, systemImage: icon)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(BoxWallColors.textSecondary)
            
            Spacer()
            
            Text(detail)
                .font(.system(size: 15))
                .foregroundColor(BoxWallColors.textPrimary)
        }
    }
}

// MARK: - Supporting Views
struct StepIndicator: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...totalSteps, id: \.self) { step in
                Capsule()
                    .fill(step <= currentStep ? BoxWallColors.Brand.green : BoxWallColors.Brand.green.opacity(0.2))
                    .frame(height: 4)
            }
        }
        .padding(.horizontal)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentStep)
    }
}

struct ExpertCard: View {
    let expert: TalkToBoxWallView.ExpertType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                action()
            }
        }) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: expert.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : BoxWallColors.Brand.green)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(expert.rawValue)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(isSelected ? .white : BoxWallColors.textPrimary)
                    
                    Text(expert.description)
                        .font(.system(size: 15))
                        .foregroundColor(isSelected ? .white.opacity(0.9) : BoxWallColors.textSecondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                // Selection indicator
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.white)
                    .opacity(isSelected ? 1 : 0)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? BoxWallColors.Brand.green : BoxWallColors.secondaryBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ? BoxWallColors.Brand.green : BoxWallColors.textSecondary.opacity(0.1),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: isSelected ? BoxWallColors.Brand.green.opacity(0.3) : Color(.sRGBLinear, white: 0, opacity: 0.1),
                radius: isSelected ? 8 : 4,
                y: isSelected ? 4 : 2
            )
        }
        .buttonStyle(PressableButtonStyle())
    }
}

struct ScheduleOptionCard: View {
    let type: TalkToBoxWallView.ScheduleType
    let isSelected: Bool
    let selectedDate: Date
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                action()
            }
        }) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: type.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : type.color)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(type.rawValue)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(isSelected ? .white : BoxWallColors.textPrimary)
                    
                    if type == .later && isSelected {
                        Text(selectedDate.formatted(date: .abbreviated, time: .shortened))
                            .font(.system(size: 15))
                            .foregroundColor(isSelected ? .white.opacity(0.9) : BoxWallColors.textSecondary)
                    } else {
                        Text(type.description)
                            .font(.system(size: 15))
                            .foregroundColor(isSelected ? .white.opacity(0.9) : BoxWallColors.textSecondary)
                    }
                }
                
                Spacer()
                
                // Selection indicator
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.white)
                    .opacity(isSelected ? 1 : 0)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? type.color : BoxWallColors.secondaryBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ? type.color : BoxWallColors.textSecondary.opacity(0.1),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: isSelected ? type.color.opacity(0.3) : Color(.sRGBLinear, white: 0, opacity: 0.1),
                radius: isSelected ? 8 : 4,
                y: isSelected ? 4 : 2
            )
        }
        .buttonStyle(PressableButtonStyle())
    }
}

struct DatePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedDate: Date
    
    var body: some View {
        VStack {
            DatePicker(
                "Select Date and Time",
                selection: $selectedDate,
                in: Date()...,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.graphical)
            .padding()
            
            Button("Confirm") {
                dismiss()
            }
            .font(.body.weight(.medium))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(BoxWallColors.Brand.green)
            .cornerRadius(12)
            .padding()
        }
        .navigationTitle("Select Date & Time")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}

// MARK: - Custom Button Style
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - File Upload Components
struct UploadOptionCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(BoxWallColors.textPrimary)
                
                Text(description)
                    .font(.system(size: 15))
                    .foregroundColor(BoxWallColors.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(BoxWallColors.textSecondary)
        }
        .padding()
        .background(BoxWallColors.secondaryBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(BoxWallColors.textSecondary.opacity(0.1), lineWidth: 1)
        )
    }
}

struct AttachedFileRow: View {
    let file: TalkToBoxWallView.AttachedFile
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: file.type.icon)
                .font(.system(size: 20))
                .foregroundColor(file.type.color)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(file.name)
                    .font(.system(size: 15))
                    .foregroundColor(BoxWallColors.textPrimary)
                    .lineLimit(1)
                
                Text(ByteCountFormatter.string(fromByteCount: file.size, countStyle: .file))
                    .font(.system(size: 13))
                    .foregroundColor(BoxWallColors.textSecondary)
            }
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(BoxWallColors.textSecondary)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(BoxWallColors.secondaryBackground.opacity(0.5))
        .cornerRadius(8)
    }
}

struct DragAndDropZone: View {
    @Binding var attachedFiles: [TalkToBoxWallView.AttachedFile]
    @State private var isHighlighted = false
    
    var body: some View {
        VStack {
            Image(systemName: "square.and.arrow.down")
                .font(.system(size: 28))
                .foregroundColor(isHighlighted ? BoxWallColors.Brand.green : BoxWallColors.textSecondary)
            
            Text("Drag files here")
                .font(.system(size: 15))
                .foregroundColor(BoxWallColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    isHighlighted ? BoxWallColors.Brand.green : BoxWallColors.textSecondary.opacity(0.2),
                    style: StrokeStyle(lineWidth: 2, dash: [8])
                )
        )
        .onDrop(of: [.fileURL], isTargeted: $isHighlighted) { providers in
            // Handle dropped files
            return true
        }
    }
}

// MARK: - Document Picker
struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var attachedFiles: [TalkToBoxWallView.AttachedFile]
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let supportedTypes: [UTType] = [
            .pdf,
            .jpeg,
            .png,
            .image,
            .plainText,
            .rtf,
            .init(filenameExtension: "doc")!,
            .init(filenameExtension: "docx")!,
            .init(filenameExtension: "dwg")!
        ]
        
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
        picker.allowsMultipleSelection = true
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            for url in urls {
                let fileType = TalkToBoxWallView.AttachedFile.FileType.from(uttype: UTType(filenameExtension: url.pathExtension) ?? .pdf)
                let resources = try? url.resourceValues(forKeys: [.fileSizeKey])
                let file = TalkToBoxWallView.AttachedFile(
                    name: url.lastPathComponent,
                    type: fileType,
                    size: Int64(resources?.fileSize ?? 0),
                    url: url
                )
                parent.attachedFiles.append(file)
            }
        }
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var attachedFiles: [TalkToBoxWallView.AttachedFile]
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage,
               let data = image.jpegData(compressionQuality: 0.8) {
                let file = TalkToBoxWallView.AttachedFile(
                    name: "Photo \(Date().formatted(date: .numeric, time: .shortened)).jpg",
                    type: .image,
                    size: Int64(data.count),
                    url: nil
                )
                parent.attachedFiles.append(file)
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    TalkToBoxWallView()
} 