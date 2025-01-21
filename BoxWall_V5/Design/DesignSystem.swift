import SwiftUI

/// Central design system for BoxWall app
/// Provides consistent styling, layout, and animation constants throughout the app
enum DesignSystem {
    // MARK: - Layout Constants
    /// Layout-related constants and measurements
    enum Layout {
        /// Standard spacing units based on 8-point grid system
        static let spacing: CGFloat = 16
        /// Small padding - 8pt
        static let paddingSmall: CGFloat = 8
        /// Medium padding - 16pt
        static let paddingMedium: CGFloat = 16
        /// Large padding - 24pt
        static let paddingLarge: CGFloat = 24
        
        /// Standard corner radius for UI elements
        static let cornerRadius: CGFloat = 12
        
        /// Standard UI element heights following Apple HIG
        static let buttonHeight: CGFloat = 44  // Minimum tappable area
        static let navBarHeight: CGFloat = 44  // Standard navigation bar
        static let tabBarHeight: CGFloat = 49  // Standard tab bar
        
        /// Product card dimensions
        static let productCardWidth: CGFloat = 160
        /// Aspect ratio for product cards (width:height)
        static let productCardAspectRatio: CGFloat = 1.4
        
        /// Box wall height configurations
        enum BoxHeight {
            case small, medium, large
            
            /// Returns the actual height value in points
            var value: CGFloat {
                switch self {
                case .small: return 120
                case .medium: return 160
                case .large: return 200
                }
            }
        }
        
        /// Grid layout constants
        static let gridSpacing: CGFloat = 16    // Space between grid items
        static let columnSpacing: CGFloat = 16  // Horizontal grid spacing
        static let rowSpacing: CGFloat = 16     // Vertical grid spacing
    }
    
    // MARK: - Animation Constants
    /// Standard animation durations and curves
    enum Animation {
        /// Quick animations for subtle changes (150ms)
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.15)
        /// Standard animations for most transitions (300ms)
        static let standard = SwiftUI.Animation.easeInOut(duration: 0.3)
        /// Slow animations for elaborate transitions (500ms)
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.5)
    }
    
    // MARK: - Placeholder Implementation
    /// Placeholder assets for development and loading states
    enum Placeholder {
        /// Default placeholder image
        static let image = Image(systemName: "photo")
        /// Default placeholder text
        static let text = "Lorem ipsum"
    }
    
    // MARK: - Type Aliases
    /// Reference to BoxWallColors for color constants
    typealias Colors = BoxWallColors
    /// Reference to BoxWallTypography for typography constants
    typealias Typography = BoxWallTypography
}

/* Reference implementations preserved:

// MARK: - Original Layout Reference
enum LayoutReference {
    // Navigation
    static let defaultNavBarHeight: CGFloat = 44
    static let largeNavBarHeight: CGFloat = 96
    
    // Product card dimensions
    static let productCardWidth: CGFloat = 160
    static let productCardAspectRatio: CGFloat = 1.4
    
    // Cart item dimensions
    static let cartItemHeight: CGFloat = 120
    
    // Custom heights for box walls
    enum BoxHeight {
        case small = 160
        case medium = 240
        case large = 320
        
        var value: CGFloat {
            switch self {
            case .small: return 160
            case .medium: return 240
            case .large: return 320
            }
        }
    }
    
    // Grid layout
    static let gridSpacing: CGFloat = 16
    static let columnSpacing: CGFloat = 16
    static let rowSpacing: CGFloat = 16
}

// MARK: - Original Typography Reference
enum TypographyReference {
    static let title = Font.system(size: 34, weight: .bold)
    static let headline = Font.system(size: 22, weight: .bold)
    static let body = Font.system(size: 17)
    static let bodyBold = Font.system(size: 17, weight: .semibold)
    static let caption = Font.system(size: 13)
    
    static func icon(size: CGFloat = 24) -> Font {
        .system(size: size)
    }
}

// MARK: - Original Colors Reference
enum ColorsReference {
    static let shopNow = Color(hex: "FF9500")
    static let bookExpert = Color(hex: "FFD60A")
    static let sustainability = Color(hex: "30D158")
    static let inventory = Color(hex: "0A84FF")
    static let news = Color(hex: "FF375F")
    
    static let textPrimary = Color(.label)
    static let textSecondary = Color(.secondaryLabel)
}

// MARK: - Original Animation Reference
enum AnimationReference {
    static let quickAnimation: Double = 0.15
    static let standardAnimation: Double = 0.3
    static let slowAnimation: Double = 0.5
}
*/

// MARK: - View Modifiers
extension View {
    /// Applies the standard corner radius to a view
    /// - Returns: A view with the standard corner radius applied
    func standardCornerRadius() -> some View {
        self.cornerRadius(DesignSystem.Layout.cornerRadius)
    }
    
    /// Applies the standard medium padding to a view
    /// - Returns: A view with standard padding applied
    func standardPadding() -> some View {
        self.padding(DesignSystem.Layout.paddingMedium)
    }
} 