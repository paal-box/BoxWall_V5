import SwiftUI

struct StatusBadge: View {
    let status: ProjectStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.system(size: 13, weight: .semibold, design: .default))  // SF Pro Text
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .clipShape(Capsule())
    }
    
    private var color: Color {
        switch status {
        case .draft: return .gray
        case .submitted: return BoxWallColors.shopNow
        case .inProgress: return BoxWallColors.sustainability
        case .completed: return BoxWallColors.inventory
        }
    }
} 