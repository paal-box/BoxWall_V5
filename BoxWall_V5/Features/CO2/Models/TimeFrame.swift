import Foundation

/// Represents a time period for CO2 impact calculations
enum TimeFrame: String, CaseIterable {
    case annual = "Annual"
    case tenYears = "10 Years"
    case buildingLifetime = "Building Lifetime"
    
    var multiplier: Double {
        switch self {
        case .annual: return 12 // 12 months
        case .tenYears: return 120 // 10 years * 12 months
        case .buildingLifetime: return 720 // 60 years * 12 months
        }
    }
    
    var dateRange: (start: Date, end: Date) {
        let end = Date()
        let start: Date
        
        switch self {
        case .annual:
            start = Calendar.current.date(byAdding: .year, value: -1, to: end)!
        case .tenYears:
            start = Calendar.current.date(byAdding: .year, value: -10, to: end)!
        case .buildingLifetime:
            start = Calendar.current.date(byAdding: .year, value: -60, to: end)!
        }
        
        return (start, end)
    }
    
    /// Returns a user-friendly description of the time period
    var description: String {
        switch self {
        case .annual:
            return "Annual impact"
        case .tenYears:
            return "10-year impact"
        case .buildingLifetime:
            return "Building lifetime impact (60 years)"
        }
    }
    
    /// Returns a shorter description for use in labels
    var shortDescription: String {
        switch self {
        case .annual:
            return "per year"
        case .tenYears:
            return "over 10 years"
        case .buildingLifetime:
            return "over building lifetime"
        }
    }
} 