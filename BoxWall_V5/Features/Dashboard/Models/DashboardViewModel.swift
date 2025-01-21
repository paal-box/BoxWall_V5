import SwiftUI

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var recentActivities: [Activity] = Activity.samples
    @Published var menuItems: [MenuCardItem] = MenuCardItem.samples
    @Published var showingUserSettings = false
    @Published var showingAllActivities = false
    @Published var unreadNotifications = 2
    
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
            // Handle shop action
            break
        case .expert:
            // Handle expert action
            break
        case .sustainability:
            // Handle sustainability action
            break
        case .inventory:
            // Handle inventory action
            break
        case .news:
            // Handle news action
            break
        }
    }
}

// MARK: - Navigation
extension DashboardViewModel {
    enum NavigationRoute {
        case shop
        case expert
        case sustainability
        case inventory
        case news
        
        init?(from type: MenuCardItem.ItemType) {
            switch type {
            case .shop: self = .shop
            case .expert: self = .expert
            case .sustainability: self = .sustainability
            case .inventory: self = .inventory
            case .news: self = .news
            }
        }
    }
} 