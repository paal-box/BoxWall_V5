import SwiftUI
import UniformTypeIdentifiers

struct NewProjectSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: ProjectViewModel
    
    @State private var name = ""
    @State private var description = ""
    @State private var showingFilePicker = false
    @State private var attachments: [ProjectAttachment] = []
    
    var body: some View {
        NavigationView {
            Form {
                Section("Project Details") {
                    TextField("Project Name", text: $name)
                        .font(.system(size: 17, design: .default))  // SF Pro Text
                    
                    TextField("Description", text: $description, axis: .vertical)
                        .font(.system(size: 17, design: .default))  // SF Pro Text
                        .lineLimit(3...6)
                }
                
                Section("Attachments") {
                    Button {
                        showingFilePicker = true
                    } label: {
                        Label("Add Files", systemImage: "plus.circle")
                            .font(.system(size: 17, weight: .semibold, design: .default))  // SF Pro Text
                    }
                    
                    if !attachments.isEmpty {
                        ForEach(attachments) { attachment in
                            HStack {
                                Image(systemName: attachment.type == .pdf ? "doc.fill" : "hammer.fill")
                                Text(attachment.name)
                                    .font(.system(size: 17, design: .default))  // SF Pro Text
                                Spacer()
                                Text(attachment.type.rawValue)
                                    .font(.system(size: 15, design: .default))  // SF Pro Text
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("New Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        let project = Project(
                            name: name,
                            description: description,
                            attachments: attachments
                        )
                        viewModel.addProject(project)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .fileImporter(
                isPresented: $showingFilePicker,
                allowedContentTypes: [.pdf, UTType(filenameExtension: "dwg")!],
                allowsMultipleSelection: true
            ) { result in
                switch result {
                case .success(let urls):
                    for url in urls {
                        let type: ProjectAttachment.AttachmentType = url.pathExtension.lowercased() == "pdf" ? .pdf : .dwg
                        let attachment = ProjectAttachment(name: url.lastPathComponent, type: type, url: url)
                        attachments.append(attachment)
                    }
                case .failure:
                    // Handle error
                    break
                }
            }
        }
    }
} 