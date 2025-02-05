import SwiftUI

/// BoxWall Design System Colors
enum BoxWallColors {
    // MARK: - Brand Identity Colors
    struct Brand {
        /// BoxWall's primary green color
        static let green = Color(red: 0.631, green: 0.765, blue: 0.059)  // #A1C40F
        /// Subtle shade of brand green for backgrounds and non-interactive elements
        static let greenLight = green.opacity(0.12)
        /// Muted green for secondary actions
        static let greenMuted = green.opacity(0.65)
        /// Darker shade of brand green for text/icons on light backgrounds
        static let greenDark = Color(red: 0.47, green: 0.57, blue: 0.04)
    }
    
    // MARK: - System Colors
    /// Primary text color that automatically adapts to light/dark mode
    static let textPrimary = Color(.label)
    /// Secondary text color for supporting content
    static let textSecondary = Color(.secondaryLabel)
    /// Tertiary text color for subtle elements
    static let textTertiary = Color(.tertiaryLabel)
    
    // MARK: - UI Colors
    /// Primary action color - Used sparingly for main CTAs
    static let primary = Color(.systemBlue)  // More neutral primary
    /// Secondary action color - Used for secondary CTAs
    static let secondary = Brand.greenMuted  // Muted green for secondary actions
    
    // MARK: - Semantic Colors
    /// Success/Eco-friendly color for sustainability features
    static let success = Brand.green  // Keep green for sustainability context
    /// Information color for inventory related items
    static let info = Color(.systemBlue)
    /// Warning color for low stock and alerts
    static let warning = Color(.systemOrange)
    /// Attention color for news and important updates
    static let attention = Color(.systemRed)
    /// Error color for critical issues
    static let error = Color(.systemRed)
    
    // MARK: - Background Colors
    static let background = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let groupedBackground = Color(.systemGroupedBackground)
    /// Subtle green tint for branded sections
    static let brandedBackground = Brand.greenLight
    /// Card background color that adapts to color scheme
    static let cardBackground = Color(.tertiarySystemBackground)
    
    // MARK: - Semantic Aliases (for better context)
    static let shopNow = primary
    static let bookExpert = secondary
    static let sustainability = Brand.green  // Keep full green for sustainability
    static let inventory = info
    static let news = attention
    
    // MARK: - Gradients
    static let gradients = GradientColors()
    
    struct GradientColors {
        // Shop gradient - Blue (subtle left to right)
        let shop = LinearGradient(
            colors: [
                Color(.systemBlue),
                Color(.systemBlue).opacity(0.7)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        // Expert gradient - Orange (subtle left to right)
        let expert = LinearGradient(
            colors: [
                Color(.systemOrange),
                Color(.systemOrange).opacity(0.7)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        // Sustainability gradient - Green (subtle left to right)
        let sustainability = LinearGradient(
            colors: [
                Brand.green,
                Brand.green.opacity(0.7)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        // Inventory gradient - Blue to Indigo (subtle left to right)
        let inventory = LinearGradient(
            colors: [
                Color(.systemBlue),
                Color(.systemBlue).opacity(0.7)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        // News gradient - Red (subtle left to right)
        let news = LinearGradient(
            colors: [
                Color(.systemRed),
                Color(.systemRed).opacity(0.7)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

// MARK: - Convenience Extensions
extension BoxWallColors {
    /// Direct access to brand green for convenience
    static let boxwallGreen = Brand.green
}

// MARK: - Color Extension
extension Color {
    static let boxWall = BoxWallColors.self
} 