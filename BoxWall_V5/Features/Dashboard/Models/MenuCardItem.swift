// MARK: - Menu Card Item Model  

import SwiftUI

/// Model representing a menu item in the dashboard carousel
struct MenuCardItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let type: ItemType
    var additionalInfo: [String]?
    
    enum ItemType {
        case shop, expert, sustainability, inventory, news, reflex
    }
}

// MARK: - Sample Data
extension MenuCardItem {
    static let samples: [MenuCardItem] = [
        MenuCardItem(
            title: "Exclusive Offers",
            description: "Limited Time: Save 10% This Week!",
            icon: "cart.fill",
            type: .shop
        ),
        MenuCardItem(
            title: "Talk to BoxWall",
            description: "Schedule a meeting with our experts and get personalized guidance",
            icon: "person.fill",
            type: .expert
        ),
        MenuCardItem(
            title: "Track CO₂ Impact",
            description: "Track Your ESG Impact and CO₂ Savings",
            icon: "leaf.fill",
            type: .sustainability,
            additionalInfo: [
                "🌳 \(EnvironmentalImpact(co2InKg: 5475.0).treesEquivalent) Trees Planted",
                "🚗 \(String(format: "%.1f", EnvironmentalImpact(co2InKg: 5475.0).carsPerDay)) Cars Off Road/Day"
            ]
        ),
        MenuCardItem(
            title: "Your Wall Inventory",
            description: "Easily Manage Your Wall Modules",
            icon: "cube.fill",
            type: .inventory
        ),
        MenuCardItem(
            title: "ReFlex Marketplace",
            description: "Sell unused modules for cash back and track their CO₂ savings",
            icon: "arrow.triangle.2.circlepath",
            type: .reflex
        ),
        MenuCardItem(
            title: "Latest Updates",
            description: "Stay Informed with BoxWall News",
            icon: "newspaper.fill",
            type: .news
        )
    ]
}