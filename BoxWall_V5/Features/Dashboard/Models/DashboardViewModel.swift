import SwiftUI

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var recentActivities: [Activity] = Activity.samples
    @Published var menuItems: [MenuCardItem] = MenuCardItem.samples
    @Published var showingUserSettings = false
    @Published var showingAllActivities = false
    @Published var showingNews = false
    @Published var showingReFlex = false
    @Published var showingTalkToBoxWall = false
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
        // Implementation removed as we now use the unified ContactSupportView
        // This method is kept for backward compatibility but should be removed in future
        print("Warning: Using deprecated contactSupport method. Use ContactSupportView directly instead.")
    }
    
    func handleMenuAction(for item: MenuCardItem) {
        switch item.type {
        case .shop:
            // Shop is now handled by TabView
            break
        case .expert:
            showingTalkToBoxWall = true
        case .sustainability:
            // CO2 Impact is now handled by TabView
            break
        case .inventory:
            // Handle inventory action
            break
        case .news:
            showingNews = true
        case .reflex:
            showingReFlex = true
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