import Foundation
import SwiftUI

enum SupportError: LocalizedError, Equatable {
    case invalidMessage
    case emptyCategory
    case networkError(String)
    case submissionFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidMessage:
            return "Please enter a valid message"
        case .emptyCategory:
            return "Please select a support category"
        case .networkError(let message):
            return "Network error: \(message)"
        case .submissionFailed(let message):
            return "Submission failed: \(message)"
        }
    }
    
    static func == (lhs: SupportError, rhs: SupportError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidMessage, .invalidMessage):
            return true
        case (.emptyCategory, .emptyCategory):
            return true
        case (.networkError(let lhsMessage), .networkError(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.submissionFailed(let lhsMessage), .submissionFailed(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}

struct SupportRequest: Identifiable {
    let id = UUID()
    let reference: String
    let category: SupportCategory
    let message: String
    let timestamp: Date
    var status: RequestStatus = .pending
    
    // Activity-specific properties
    let activityId: String?
    let projectNumber: String?
    let priority: Activity.Priority?
    
    // Validation
    static let minimumMessageLength = 10
    static let maximumMessageLength = 1000
    
    func validate() throws {
        if message.trimmingCharacters(in: .whitespacesAndNewlines).count < Self.minimumMessageLength {
            throw SupportError.invalidMessage
        }
        if message.count > Self.maximumMessageLength {
            throw SupportError.invalidMessage
        }
    }
    
    enum RequestStatus: String {
        case pending = "Pending"
        case inProgress = "In Progress"
        case resolved = "Resolved"
    }
}

enum SupportCategory: String, CaseIterable {
    case generalInquiry = "General Inquiry"
    case technicalSupport = "Technical Support"
    case scheduling = "Scheduling"
    case installation = "Installation"
    
    var icon: String {
        switch self {
        case .generalInquiry: return "questionmark.circle"
        case .technicalSupport: return "wrench.and.screwdriver"
        case .scheduling: return "calendar"
        case .installation: return "building.2"
        }
    }
} 