import SwiftUI

struct UserSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = UserSettingsViewModel()
    @State private var showingDeleteConfirmation = false
    @State private var showingDataRequestConfirmation = false
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            List {
                // Profile Section
                Section {
                    HStack(spacing: DesignSystem.Layout.spacing) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(BoxWallColors.primary)
                            .symbolRenderingMode(.hierarchical)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.userName)
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(BoxWallColors.textPrimary)
                            Text(viewModel.userEmail)
                                .font(.system(size: 15, weight: .regular, design: .rounded))
                                .foregroundColor(BoxWallColors.textSecondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Notifications Section
                Section {
                    Toggle("Enable Notifications", isOn: $viewModel.notificationsEnabled)
                        .tint(BoxWallColors.primary)
                        .toggleStyle(SwitchToggleStyle(tint: BoxWallColors.primary))
                        .font(.system(size: 17, weight: .regular, design: .default))
                    
                    Toggle("Email Notifications", isOn: $viewModel.emailNotifications)
                        .tint(BoxWallColors.primary)
                        .toggleStyle(SwitchToggleStyle(tint: BoxWallColors.primary))
                        .font(.system(size: 17, weight: .regular, design: .default))
                } header: {
                    Text("Notifications")
                        .font(.system(size: 13, weight: .semibold, design: .default))
                        .foregroundColor(BoxWallColors.textSecondary)
                        .textCase(.uppercase)
                }
                
                // Appearance Section
                Section {
                    Toggle("Dark Mode", isOn: $viewModel.darkModeEnabled.animation(.easeInOut(duration: 0.3)))
                        .tint(BoxWallColors.primary)
                        .toggleStyle(SwitchToggleStyle(tint: BoxWallColors.primary))
                        .font(.system(size: 17, weight: .regular, design: .default))
                } header: {
                    Text("Appearance")
                        .font(.system(size: 13, weight: .semibold, design: .default))
                        .foregroundColor(BoxWallColors.textSecondary)
                        .textCase(.uppercase)
                }
                
                // GDPR Section
                Section {
                    Button(action: { showingDataRequestConfirmation = true }) {
                        HStack {
                            Label {
                                Text("Request My Data")
                                    .font(.system(size: 17, weight: .regular, design: .default))
                            } icon: {
                                Image(systemName: "arrow.down.doc")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(BoxWallColors.primary)
                            }
                            if viewModel.isProcessing {
                                Spacer()
                                ProgressView()
                            }
                        }
                    }
                    .disabled(viewModel.isProcessing)
                    
                    Button(action: { showingDeleteConfirmation = true }) {
                        HStack {
                            Label {
                                Text("Delete My Data")
                                    .font(.system(size: 17, weight: .regular, design: .default))
                            } icon: {
                                Image(systemName: "trash")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(BoxWallColors.error)
                            }
                            if viewModel.isProcessing {
                                Spacer()
                                ProgressView()
                            }
                        }
                    }
                    .disabled(viewModel.isProcessing)
                } header: {
                    Text("Privacy & Data")
                        .font(.system(size: 13, weight: .semibold, design: .default))
                        .foregroundColor(BoxWallColors.textSecondary)
                        .textCase(.uppercase)
                }
                
                // App Info Section
                Section {
                    HStack {
                        Text("Version")
                            .font(.system(size: 17, weight: .regular, design: .default))
                        Spacer()
                        Text("1.0.0")
                            .font(.system(size: 17, weight: .regular, design: .default))
                            .foregroundColor(BoxWallColors.textSecondary)
                    }
                    
                    Link(destination: URL(string: "https://boxwall.no/privacy")!) {
                        Label {
                            Text("Privacy Policy")
                                .font(.system(size: 17, weight: .regular, design: .default))
                        } icon: {
                            Image(systemName: "doc.text")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(BoxWallColors.primary)
                        }
                    }
                    
                    Link(destination: URL(string: "https://boxwall.no/terms")!) {
                        Label {
                            Text("Terms of Service")
                                .font(.system(size: 17, weight: .regular, design: .default))
                        } icon: {
                            Image(systemName: "doc.text")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(BoxWallColors.primary)
                        }
                    }
                } header: {
                    Text("About")
                        .font(.system(size: 13, weight: .semibold, design: .default))
                        .foregroundColor(BoxWallColors.textSecondary)
                        .textCase(.uppercase)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                        .font(.system(size: 17, weight: .regular, design: .default))
                        .foregroundColor(BoxWallColors.primary)
                }
            }
        }
        .preferredColorScheme(viewModel.darkModeEnabled ? .dark : .light)
        .animation(.easeInOut(duration: 0.3), value: viewModel.darkModeEnabled)
        .alert("Request Your Data", isPresented: $showingDataRequestConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Request") {
                viewModel.isProcessing = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    viewModel.isProcessing = false
                }
            }
        } message: {
            Text("We will compile your data and send it to your registered email address within 30 days.")
                .font(.system(size: 15, weight: .regular, design: .default))
        }
        .alert("Delete Your Data", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.isProcessing = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    viewModel.isProcessing = false
                    dismiss()
                }
            }
        } message: {
            Text("This will permanently delete all your data. This action cannot be undone.")
                .font(.system(size: 15, weight: .regular, design: .default))
        }
    }
}

#Preview {
    UserSettingsView()
} 