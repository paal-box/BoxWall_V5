import Foundation
import SwiftUI

@MainActor
final class SupportViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var currentRequest: SupportRequest?
    @Published private(set) var error: SupportError?
    @Published var selectedCategory: SupportCategory = .generalInquiry
    @Published var message: String = ""
    @Published var isSubmitting = false
    
    // MARK: - Private Properties
    let activity: Activity?
    private var referenceNumber: String {
        "REF-" + String(format: "%03d", Int.random(in: 1...999))
    }
    
    var messageCharacterCount: Int {
        message.trimmingCharacters(in: .whitespacesAndNewlines).count
    }
    
    var isValidMessage: Bool {
        messageCharacterCount >= SupportRequest.minimumMessageLength &&
        messageCharacterCount <= SupportRequest.maximumMessageLength
    }
    
    // MARK: - Initialization
    init(activity: Activity? = nil) {
        self.activity = activity
        if let activity = activity {
            // Pre-fill message with activity details
            self.message = """
                Regarding Activity: \(activity.title)
                \(activity.description)
                
                
                """
            
            // Set appropriate category based on activity type
            self.selectedCategory = activity.supportCategory
        }
    }
    
    // MARK: - Public Methods
    func submitRequest() async -> Bool {
        isSubmitting = true
        error = nil
        
        do {
            // Create and validate request
            let request = SupportRequest(
                reference: referenceNumber,
                category: selectedCategory,
                message: message,
                timestamp: Date(),
                activityId: activity?.id,
                projectNumber: activity?.projectNumber,
                priority: activity?.priority
            )
            
            try request.validate()
            
            // Simulate network request
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
            
            // Simulate network error randomly (for testing)
            if Bool.random() && ProcessInfo.processInfo.environment["PREVIEW"] == nil {
                throw SupportError.networkError("Failed to connect to server")
            }
            
            currentRequest = request
            isSubmitting = false
            return true
            
        } catch let error as SupportError {
            self.error = error
            isSubmitting = false
            return false
        } catch {
            self.error = .networkError(error.localizedDescription)
            isSubmitting = false
            return false
        }
    }
    
    func resetForm() {
        selectedCategory = activity?.supportCategory ?? .generalInquiry
        message = ""
        currentRequest = nil
        error = nil
    }
    
    func clearError() {
        error = nil
    }
}

// MARK: - Activity Extensions
extension Activity {
    var supportCategory: SupportCategory {
        switch type {
        case .reflex, .delivery:
            return .scheduling
        case .service, .changeRequest:
            return .technicalSupport
        case .installation:
            return .installation
        case .invoice:
            return .generalInquiry
        }
    }
} 