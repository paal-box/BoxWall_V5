// MARK: - Menu Card Item Model  

import SwiftUI

/// Model representing a menu item in the dashboard carousel
struct MenuCardItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let type: ItemType
    
    enum ItemType {
        case shop, expert, sustainability, inventory, news
    }
}

// MARK: - Sample Data
extension MenuCardItem {
    static let samples: [MenuCardItem] = [
        MenuCardItem(
            title: "Shop Now",
            description: "Special offer: 10% off this week",
            icon: "cart.fill",
            type: .shop
        ),
        MenuCardItem(
            title: "Ask The Expert",
            description: "Book a consultation",
            icon: "person.fill",
            type: .expert
        ),
        MenuCardItem(
            title: "Sustainability",
            description: "15% reduction in CO2",
            icon: "leaf.fill",
            type: .sustainability
        ),
        MenuCardItem(
            title: "Inventory",
            description: "Check stock levels",
            icon: "cube.fill",
            type: .inventory
        ),
        MenuCardItem(
            title: "News",
            description: "Latest updates and announcements",
            icon: "newspaper.fill",
            type: .news
        )
    ]
}