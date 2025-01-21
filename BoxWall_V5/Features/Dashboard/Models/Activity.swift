// MARK: - Activity Model 
// 

import Foundation
import SwiftUI

/// Model representing a single activity item in the dashboard
struct Activity: Identifiable {
    let id: String
    let title: String
    let location: String
    let description: String
    let date: Date
    let type: ActivityType
    let priority: Priority
    let projectNumber: String?
    let actionRequired: Bool
    let deadline: Date?
    
    /// Types of activities that can be displayed
    enum ActivityType {
        case reflex
        case invoice
        case delivery
        case service
        case installation
        case changeRequest
        
        var icon: String {
            switch self {
            case .reflex: return "arrow.triangle.2.circlepath"
            case .invoice: return "dollarsign.circle"
            case .delivery: return "shippingbox"
            case .service: return "wrench.and.screwdriver"
            case .installation: return "building.2"
            case .changeRequest: return "calendar.badge.clock"
            }
        }
        
        var color: Color {
            switch self {
            case .reflex: return BoxWallColors.sustainability
            case .invoice: return BoxWallColors.attention
            case .delivery: return BoxWallColors.primary
            case .service: return BoxWallColors.info
            case .installation: return BoxWallColors.secondary
            case .changeRequest: return BoxWallColors.warning
            }
        }
    }
    
    enum Priority: Int {
        case low = 0
        case medium = 1
        case high = 2
        
        var color: Color {
            switch self {
            case .low: return BoxWallColors.success
            case .medium: return BoxWallColors.warning
            case .high: return BoxWallColors.attention
            }
        }
    }
}

// MARK: - Sample Data
extension Activity {
    static let samples: [Activity] = [
        Activity(
            id: "REF-001",
            title: "ReFlex - Unused modules",
            location: "Building A • Floor 3",
            description: "30 pcs scheduled for pickup February 5th. Ensure modules are packaged for shipping and placed on pallet.",
            date: Date().addingTimeInterval(-7200), // 2 hours ago
            type: .reflex,
            priority: .medium,
            projectNumber: nil,
            actionRequired: true,
            deadline: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 5))
        ),
        Activity(
            id: "INV-002",
            title: "Invoice Reminder",
            location: "Finance Department",
            description: "Your last invoice from BoxWall is due in 2 days. Please contact customer service for any questions.",
            date: Date().addingTimeInterval(-86400), // Yesterday
            type: .invoice,
            priority: .high,
            projectNumber: nil,
            actionRequired: true,
            deadline: Date().addingTimeInterval(172800) // 2 days from now
        ),
        Activity(
            id: "DEL-003",
            title: "Delivery Scheduled",
            location: "Project: Cissi Klein High School",
            description: "300 BoxWall-Flex 50, 15 BoxWall Flex-Glass 44. See order for height data.",
            date: Date().addingTimeInterval(-172800), // 2 days ago
            type: .delivery,
            priority: .medium,
            projectNumber: "552506",
            actionRequired: false,
            deadline: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 18))
        ),
        Activity(
            id: "INS-004",
            title: "Installation Schedule",
            location: "Cissi Klein High School • 4th Floor",
            description: "Space must be cleared prior to work starting. Customer responsible for facility access.",
            date: Date().addingTimeInterval(-3600), // 1 hour ago
            type: .installation,
            priority: .medium,
            projectNumber: "552506",
            actionRequired: true,
            deadline: Calendar.current.date(from: DateComponents(year: 2024, month: 4, day: 5))
        ),
        Activity(
            id: "CHG-005",
            title: "Change Request",
            location: "Fylkeshuset, Trondheim • 5th Floor",
            description: "68 modules scheduled for move. Contact: Torger Mjones",
            date: Date().addingTimeInterval(-43200), // 12 hours ago
            type: .changeRequest,
            priority: .low,
            projectNumber: "552507",
            actionRequired: true,
            deadline: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 12))
        )
    ]
} 