import SwiftUI

enum BoxWallTypography {
    // Icon helper
    static func icon(size: CGFloat) -> Font {
        .system(size: size)
    }
    
    // Text styles
    static let title1 = Font.largeTitle
    static let title2 = Font.title2
    static let headline = Font.headline
    static let body = Font.body
    static let subheadline = Font.subheadline
    static let caption = Font.caption
}

// MARK: - Font Extension
extension Font {
    static let boxWall = BoxWallTypography.self
}

// MARK: - View Extension
extension View {
    /// Applies standard text style with optional color
    func textStyle(_ style: Font, color: Color = BoxWallColors.textPrimary) -> some View {
        self
            .font(style)
            .foregroundColor(color)
    }
} 