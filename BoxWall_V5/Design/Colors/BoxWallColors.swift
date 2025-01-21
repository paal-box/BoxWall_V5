import SwiftUI

enum BoxWallColors {
    // MARK: - System Colors
    /// Primary text color that automatically adapts to light/dark mode
    static let textPrimary = Color(.label)
    /// Secondary text color for supporting content
    static let textSecondary = Color(.secondaryLabel)
    
    // MARK: - Brand Colors
    /// Primary action color - Used for Shop Now CTAs
    static let primary = Color(.systemOrange)  // SF Orange
    /// Secondary action color - Used for Book Expert CTAs
    static let secondary = Color(.systemYellow) // SF Yellow
    
    // MARK: - Semantic Colors
    /// Success/Eco-friendly color for sustainability features
    static let success = Color(.systemGreen)
    /// Information color for inventory related items
    static let info = Color(.systemBlue)
    /// Warning color for low stock and alerts
    static let warning = Color(.systemOrange)
    /// Attention color for news and important updates
    static let attention = Color(.systemRed)
    /// Error color for critical issues
    static let error = Color(.systemRed)
    
    // MARK: - Semantic Aliases (for better context)
    static let shopNow = primary
    static let bookExpert = secondary
    static let sustainability = success
    static let inventory = info
    static let news = attention
    
    // MARK: - Gradients
    static let gradients = GradientColors()
    
    struct GradientColors {
        // Shop gradient
        let shop = LinearGradient(
            colors: [Color(.systemOrange), Color(.systemOrange).opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // Expert gradient
        let expert = LinearGradient(
            colors: [Color(.systemYellow), Color(.systemYellow).opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // Sustainability gradient
        let sustainability = LinearGradient(
            colors: [Color(.systemGreen), Color(.systemGreen).opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // Inventory gradient
        let inventory = LinearGradient(
            colors: [Color(.systemBlue), Color(.systemBlue).opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // News gradient
        let news = LinearGradient(
            colors: [Color(.systemRed), Color(.systemRed).opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Color Extension
extension Color {
    static let boxWall = BoxWallColors.self
} 