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
    
    @AppStorage("isDarkMode") var darkModeEnabled: Bool = false {
        didSet {
            updateAppearanceSettings()
        }
    }
    
    @Published var userName: String
    @Published var userEmail: String
    @Published var isProcessing = false
    
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
    }
    
    private func updateEmailSettings() {
        UserDefaults.standard.set(emailNotifications, forKey: "emailNotifications")
    }
    
    private func updateAppearanceSettings() {
        // Dark mode is now handled by @AppStorage
    }
} 