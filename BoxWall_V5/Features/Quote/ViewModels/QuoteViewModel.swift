import SwiftUI

@MainActor
class QuoteViewModel: ObservableObject {
    @Published var projectName = ""
    @Published var buildingType = QuoteRequest.BuildingType.office
    @Published var description = ""
    
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var postalCode = ""
    @Published var floorNumber = 1
    
    @Published var totalWallArea = 0.0
    @Published var soundproofingRequired = false
    @Published var customFinishRequired = false
    
    @Published var contactName = ""
    @Published var email = ""
    @Published var phone = ""
    
    @Published var isSubmitting = false
    @Published var showError = false
    @Published var errorMessage: String?
    
    var isValid: Bool {
        !projectName.isEmpty &&
        !description.isEmpty &&
        !streetAddress.isEmpty &&
        !city.isEmpty &&
        !postalCode.isEmpty &&
        totalWallArea > 0 &&
        !contactName.isEmpty &&
        !email.isEmpty &&
        !phone.isEmpty
    }
    
    func submit() async {
        guard isValid else {
            showError = true
            errorMessage = "Please fill in all required fields"
            return
        }
        
        isSubmitting = true
        defer { isSubmitting = false }
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        let quoteRequest = QuoteRequest(
            projectName: projectName,
            buildingType: buildingType,
            description: description,
            location: .init(
                streetAddress: streetAddress,
                city: city,
                postalCode: postalCode,
                floorNumber: floorNumber
            ),
            requirements: .init(
                totalWallArea: totalWallArea,
                soundproofingRequired: soundproofingRequired,
                customFinishRequired: customFinishRequired
            ),
            contact: .init(
                name: contactName,
                email: email,
                phone: phone
            )
        )
        
        // Here you would typically send the quote request to your backend
        print("Submitting quote request:", quoteRequest)
    }
} 