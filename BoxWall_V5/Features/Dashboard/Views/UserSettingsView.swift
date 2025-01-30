import SwiftUI

struct UserSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = UserSettingsViewModel()
    @State private var showingDeleteConfirmation = false
    @State private var showingDataRequestConfirmation = false
    @State private var showingLogoutConfirmation = false
    
    var body: some View {
        NavigationView {
            List {
                // Account Section
                Section {
                    HStack(spacing: DesignSystem.Layout.spacing) {
                        // Profile Picture
                        Button(action: { /* Add profile picture action */ }) {
                            ZStack {
                                Circle()
                                    .fill(BoxWallColors.textSecondary.opacity(0.1))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "person.fill")
                                    .font(.system(size: 32, weight: .light))
                                    .foregroundColor(BoxWallColors.boxwallGreen)
                                    .symbolRenderingMode(.hierarchical)
                                
                                Circle()
                                    .strokeBorder(BoxWallColors.boxwallGreen.opacity(0.2), lineWidth: 2)
                                    .frame(width: 80, height: 80)
                            }
                            .overlay(alignment: .bottomTrailing) {
                                Image(systemName: "pencil.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundStyle(BoxWallColors.boxwallGreen)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .offset(x: 6, y: 6)
                            }
                        }
                        
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
                    
                    if viewModel.isLoggedIn {
                        Button(role: .destructive, action: { showingLogoutConfirmation = true }) {
                            HStack {
                                Text("Log Out")
                                Spacer()
                                Image(systemName: "arrow.right.square")
                            }
                        }
                    }
                } header: {
                    Text("Account")
                }
                
                // Notifications Section
                Section {
                    Toggle("Enable Notifications", isOn: $viewModel.notificationsEnabled)
                        .tint(BoxWallColors.boxwallGreen)
                    
                    Toggle("Email Notifications", isOn: $viewModel.emailNotifications)
                        .tint(BoxWallColors.boxwallGreen)
                } header: {
                    Text("Notifications")
                } footer: {
                    Text("Receive updates about your orders, deliveries, and important announcements.")
                }
                
                // Appearance Section
                Section {
                    Toggle("Dark Mode", isOn: $viewModel.darkModeEnabled.animation(.easeInOut(duration: 0.3)))
                        .tint(BoxWallColors.boxwallGreen)
                } header: {
                    Text("Appearance")
                }
                
                // Privacy & Data Section
                Section {
                    NavigationLink {
                        PrivacyPolicyView()
                    } label: {
                        Label("Privacy Policy", systemImage: "hand.raised.fill")
                            .foregroundColor(BoxWallColors.textPrimary)
                    }
                    
                    Button(action: { showingDataRequestConfirmation = true }) {
                        HStack {
                            Label("Request My Data", systemImage: "arrow.down.doc.fill")
                                .foregroundColor(BoxWallColors.textPrimary)
                            if viewModel.isProcessing {
                                Spacer()
                                ProgressView()
                                    .tint(BoxWallColors.boxwallGreen)
                            }
                        }
                    }
                    .disabled(viewModel.isProcessing)
                    
                    Button(role: .destructive, action: { showingDeleteConfirmation = true }) {
                        HStack {
                            Label("Delete My Data", systemImage: "trash.fill")
                            if viewModel.isProcessing {
                                Spacer()
                                ProgressView()
                                    .tint(BoxWallColors.boxwallGreen)
                            }
                        }
                    }
                    .disabled(viewModel.isProcessing)
                } header: {
                    Text("Privacy & Data")
                }
                
                // About Section
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(BoxWallColors.textSecondary)
                    }
                    
                    NavigationLink {
                        TermsOfServiceView()
                    } label: {
                        Label("Terms of Service", systemImage: "doc.text.fill")
                            .foregroundColor(BoxWallColors.textPrimary)
                    }
                    
                    NavigationLink {
                        SupportView()
                    } label: {
                        Label("Contact Support", systemImage: "questionmark.circle.fill")
                            .foregroundColor(BoxWallColors.textPrimary)
                    }
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                        .foregroundColor(BoxWallColors.boxwallGreen)
                }
            }
            .tint(BoxWallColors.boxwallGreen)
        }
        .alert("Request Your Data", isPresented: $showingDataRequestConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Request") {
                Task { await viewModel.requestData() }
            }
        } message: {
            Text("We will compile your data and send it to your registered email address within 30 days.")
        }
        .alert("Delete Your Data", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                Task { await viewModel.deleteData() }
            }
        } message: {
            Text("This will permanently delete all your data. This action cannot be undone.")
        }
        .alert("Log Out", isPresented: $showingLogoutConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Log Out", role: .destructive) {
                Task { await viewModel.logout() }
            }
        } message: {
            Text("Are you sure you want to log out?")
        }
    }
}

// Placeholder Views
struct PrivacyPolicyView: View {
    var body: some View {
        Text("Privacy Policy")
            .navigationTitle("Privacy Policy")
    }
}

struct TermsOfServiceView: View {
    var body: some View {
        Text("Terms of Service")
            .navigationTitle("Terms of Service")
    }
}

struct SupportView: View {
    var body: some View {
        Text("Support")
            .navigationTitle("Contact Support")
    }
}

#Preview {
    UserSettingsView()
} 