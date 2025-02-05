import SwiftUI

struct ProjectMenuItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let type: ItemType
    
    enum ItemType {
        case quote, technical, finance, coCreator
        
        var gradient: LinearGradient {
            switch self {
            case .quote:
                return BoxWallColors.gradients.shop
            case .technical:
                return BoxWallColors.gradients.expert
            case .finance:
                return BoxWallColors.gradients.inventory
            case .coCreator:
                return BoxWallColors.gradients.sustainability
            }
        }
    }
}

// MARK: - Sample Data
extension ProjectMenuItem {
    static let items: [ProjectMenuItem] = [
        ProjectMenuItem(
            title: "Request a Quote",
            description: "Get a tailored solution that fits your space and budget",
            icon: "doc.text.fill",
            type: .quote
        ),
        ProjectMenuItem(
            title: "Technical Solutions",
            description: "Save time and optimize your refit project with expert insights",
            icon: "gear.circle.fill",
            type: .technical
        ),
        ProjectMenuItem(
            title: "Finance Options",
            description: "Flexible Financing for Your New BoxWall Space",
            icon: "creditcard.fill",
            type: .finance
        ),
        ProjectMenuItem(
            title: "Co-Creator",
            description: "Innovate with BoxWall, Join us in shaping the future of sustainable spaces",
            icon: "person.2.fill",
            type: .coCreator
        )
    ]
} 