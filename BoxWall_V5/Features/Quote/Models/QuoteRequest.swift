import Foundation

struct QuoteRequest: Identifiable {
    let id = UUID()
    var projectName: String
    var buildingType: BuildingType
    var description: String
    var location: Location
    var requirements: Requirements
    var contact: ContactInfo
    var status: Status = .pending
    var submissionDate: Date = Date()
    
    enum BuildingType: String, CaseIterable {
        case office = "Office"
        case hospitality = "Hospitality"
        case medical = "Medical"
        case retail = "Retail"
        case other = "Other"
    }
    
    struct Location {
        var streetAddress: String
        var city: String
        var postalCode: String
        var floorNumber: Int
    }
    
    struct Requirements {
        var totalWallArea: Double
        var soundproofingRequired: Bool
        var customFinishRequired: Bool
    }
    
    struct ContactInfo {
        var name: String
        var email: String
        var phone: String
    }
    
    enum Status: String {
        case pending = "Pending"
        case submitted = "Submitted"
        case inReview = "In Review"
        case approved = "Approved"
        case completed = "Completed"
    }
}

// MARK: - Sample Data
extension QuoteRequest {
    static let sample = QuoteRequest(
        projectName: "Office Renovation",
        buildingType: .office,
        description: "Complete office renovation with modern wall solutions",
        location: Location(
            streetAddress: "Karl Johans Gate 1",
            city: "Oslo",
            postalCode: "0154",
            floorNumber: 3
        ),
        requirements: Requirements(
            totalWallArea: 150.0,
            soundproofingRequired: true,
            customFinishRequired: false
        ),
        contact: ContactInfo(
            name: "John Doe",
            email: "john@example.com",
            phone: "+47 123 45 678"
        )
    )
} 