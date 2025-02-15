import SwiftUI

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var recentActivities: [Activity] = Activity.samples
    @Published var menuItems: [MenuCardItem] = MenuCardItem.samples
    @Published var showingUserSettings = false
    @Published var showingAllActivities = false
    @Published var showingNews = false
    @Published var showingReFlex = false
    @Published var unreadNotifications = 2
    
    // User Info
    @Published var userName: String
    
    init() {
        // Initialize with user info from UserSettings
        let userSettings = UserSettingsViewModel()
        self.userName = userSettings.userName
    }
    
    var allActivities: [Activity] {
        Activity.samples  // Later this will fetch from a data source
    }
    
    func showAllActivities() {
        showingAllActivities = true
    }
    
    func showUserSettings() {
        showingUserSettings = true
    }
    
    func markActivityAsDone(_ activity: Activity) {
        // Implementation here
    }
    
    func contactSupport(for activity: Activity, message: String) {
        // Implementation here
    }
    
    func handleMenuAction(for item: MenuCardItem) {
        switch item.type {
        case .shop:
            // Shop is now handled by TabView
            break
        case .expert:
            // Expert guidance removed
            break
        case .sustainability:
            // CO2 Impact is now handled by TabView
            break
        case .inventory:
            // Handle inventory action
            break
        case .news:
            showingNews = true
        case .reflex:
            // ReFlex feature not implemented yet
            break
        }
    }
}

// MARK: - Navigation
extension DashboardViewModel {
    enum NavigationRoute {
        case expert
        case inventory
        case news
        case reflex
        
        init?(from type: MenuCardItem.ItemType) {
            switch type {
            case .shop: return nil // Shop is now handled by TabView
            case .sustainability: return nil // CO2 is now handled by TabView
            case .expert: self = .expert
            case .inventory: self = .inventory
            case .news: self = .news
            case .reflex: self = .reflex
            }
        }
    }
} 