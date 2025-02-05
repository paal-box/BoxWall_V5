import Foundation

enum ProjectType: String, CaseIterable {
    case newConstruction = "New Construction"
    case refit = "Refit / Renovation"
    case upgrade = "Whole Building Upgrade"
}

enum InstallationScope: String, CaseIterable {
    case entireFloor = "Entire Floor"
    case multipleFloors = "Multiple Floors"
    case selectedRooms = "Selected Rooms"
}

enum WallType: String, CaseIterable {
    case solid = "Solid"
    case glass = "Glass"
    case mixed = "Mixed"
}

enum NoiseRequirement: Int, CaseIterable {
    case standard = 38
    case enhanced = 44
    case premium = 50
    
    var description: String {
        "\(rawValue)dB"
    }
    
    var details: String {
        switch self {
        case .standard: return "Standard acoustic performance"
        case .enhanced: return "Enhanced noise reduction"
        case .premium: return "Premium sound isolation (double wall)"
        }
    }
}

struct AdditionalFeatures: OptionSet {
    let rawValue: Int
    
    static let powerAndData = AdditionalFeatures(rawValue: 1 << 0)
    static let smartSensors = AdditionalFeatures(rawValue: 1 << 1)
    
    var description: String {
        switch self {
        case .powerAndData: return "Integrated Power / Data Cabling"
        case .smartSensors: return "Smart Sensors (IoT)"
        default: return ""
        }
    }
    
    var tooltip: String {
        switch self {
        case .powerAndData:
            return "Ensure seamless connectivity by integrating power outlets and data cabling within your BoxWall installation. Ideal for modern office spaces, meeting rooms, and smart work environments requiring built-in infrastructure for power, Ethernet, or AV systems."
        case .smartSensors:
            return "Enhance your space with BoxWall's integrated IoT sensors. Monitor air quality, occupancy, temperature, while enabling automation and smart building insights. Perfect for optimizing workspaces and improving sustainability"
        default:
            return ""
        }
    }
    
    static let allCases: [AdditionalFeatures] = [
        .powerAndData,
        .smartSensors
    ]
} 