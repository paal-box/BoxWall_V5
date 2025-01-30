import SwiftUI

@MainActor
final class UserSettingsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var notificationsEnabled: Bool {
        didSet {
            updateNotificationSettings()
        }
    }
    
    @Published var emailNotifications: Bool {
        didSet {
            updateEmailSettings()
        }
    }
    
    @AppStorage("isDarkMode") var darkModeEnabled: Bool = false
    @Published var isProcessing = false
    
    // User Info
    @Published var userName: String
    @Published var userEmail: String
    @Published var profileImage: UIImage?
    @Published var isLoggedIn: Bool = true // For demo purposes
    
    // MARK: - Initialization
    init() {
        // Load saved settings
        self.notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        self.emailNotifications = UserDefaults.standard.bool(forKey: "emailNotifications")
        
        // Load user info (dummy data for now)
        self.userName = "Paal Selnaes"
        self.userEmail = "paal@boxwall.no"
    }
    
    // MARK: - Settings Methods
    private func updateNotificationSettings() {
        UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled")
        // TODO: Update notification settings on server
    }
    
    private func updateEmailSettings() {
        UserDefaults.standard.set(emailNotifications, forKey: "emailNotifications")
        // TODO: Update email preferences on server
    }
    
    // MARK: - Account Management
    func updateProfilePicture() {
        // TODO: Implement profile picture update
    }
    
    func logout() async {
        isProcessing = true
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        // TODO: Implement actual logout
        isProcessing = false
        isLoggedIn = false
    }
    
    // MARK: - Data Management
    func requestData() async {
        isProcessing = true
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        // TODO: Implement actual data request
        isProcessing = false
    }
    
    func deleteData() async {
        isProcessing = true
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        // TODO: Implement actual data deletion
        isProcessing = false
        isLoggedIn = false
    }
} 