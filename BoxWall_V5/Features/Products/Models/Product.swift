import SwiftUI

/// Represents a product in the BoxWall system
struct Product: Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    let imageURL: URL?                      //listed in Asset catalog
    let price: Decimal
    let category: Category
    let dimensions: Dimensions              //dimensions of the product    
    let status: Status
    let pricePerSquareMeter: Decimal?       // For wall systems
    let co2Savings: Int?                    // Environmental impact
    let isDoubleWall: Bool?                 // 50dB modules are double walls 2xmodules, all other modules are single wall modules
    let imageSystemName: String             // SF Symbol name for fallback
    let soundClassification: SoundClass?     // dB rating for wall modules
    let material: BoxWallMaterial?      // Material/finish option
    let moduleType: ModuleType?         // Specific module type if applicable
    let productImage: String?           // Custom product image name
    
    /// Product categories
    enum Category: String, CaseIterable {
        case walls = "Wall Systems"
        case modules = "Modules"
        case accessories = "Accessories"
        
        var icon: String {
            switch self {
            case .walls: return "square.grid.2x2.fill"
            case .modules: return "cube.box.fill"
            case .accessories: return "wrench.and.screwdriver.fill"
            }
        }
    }
    
    /// Product dimensions
    struct Dimensions: Hashable {
        let width: Double
        let height: Double
        let depth: Double
        
        var displayString: String {
            return "\(Int(width))×\(Int(height))×\(Int(depth)) cm"
        }
    }
    
    /// Product availability status
    enum Status: String {
        case available = "Available"
        case lowStock = "Low Stock"
        case outOfStock = "Out of Stock"
        case comingSoon = "Coming Soon"
        
        var color: Color {
            switch self {
            case .available: return BoxWallColors.success
            case .lowStock: return BoxWallColors.attention
            case .outOfStock: return BoxWallColors.error
            case .comingSoon: return BoxWallColors.info
            }
        }
    }
    
    /// Sound classification for wall modules
    enum SoundClass: Int, CaseIterable {
        case standard = 38    // Standard wall module
        case enhanced = 44    // Enhanced wall module
        case premium = 50     // Premium wall module (double wall)
        
        var description: String {
            return "\(rawValue)dB"
        }
        
        var isDoubleWall: Bool {
            self == .premium  // 50dB modules are always double walls
        }
    }
    
    /// Standard dimensions for wall modules
    static let standardWallWidth: Double = 60  // All wall modules are 60cm wide
    
    /// Available heights for wall modules (in cm)
    static let availableWallHeights: [Double] = [
        240,    // Standard office height
        270,    // High ceiling office
        340,    // Special installations
        400     // Custom order height (max 400cm)
    ]
    
    // Add hash function
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Add equality operator
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }
    
    // Helper for getting the display image
    var displayImage: String {
        if let productImage = productImage {
            return productImage
        }
        if let moduleType = moduleType {
            return moduleType.imageAsset
        }
        if let material = material {
            return material.imageAsset
        }
        return imageSystemName
    }
}

// MARK: - Sample Data
extension Product {
    // Wall Systems
    static let wallSystems: [Product] = [
        // 38dB Standard Wall System
        Product(
            id: "WALL-038",
            name: "BoxWall Standard",
            description: "Standard modular wall system with basic acoustic performance",
            imageURL: nil,
            price: 950,
            category: .walls,
            dimensions: Dimensions(width: standardWallWidth, height: 240, depth: 10),
            status: .available,
            pricePerSquareMeter: 950,
            co2Savings: 250,
            isDoubleWall: false,
            imageSystemName: "square.grid.2x2.fill",
            soundClassification: .standard,
            material: .oak,  // Default material
            moduleType: nil,
            productImage: nil
        ),
        // 44dB Enhanced Wall System
        Product(
            id: "WALL-044",
            name: "BoxWall Enhanced",
            description: "Enhanced wall system with improved acoustic performance",
            imageURL: nil,
            price: 1250,
            category: .walls,
            dimensions: Dimensions(width: standardWallWidth, height: 240, depth: 12),
            status: .available,
            pricePerSquareMeter: 1250,
            co2Savings: 300,
            isDoubleWall: false,
            imageSystemName: "square.grid.2x2.fill",
            soundClassification: .enhanced,
            material: .oak,  // Default material
            moduleType: nil,
            productImage: nil
        ),
        // 50dB Premium Wall System (Double Wall)
        Product(
            id: "WALL-050",
            name: "BoxWall Premium",
            description: "Premium double-wall system with maximum acoustic performance",
            imageURL: nil,
            price: 1450,
            category: .walls,
            dimensions: Dimensions(width: standardWallWidth, height: 240, depth: 15),
            status: .available,
            pricePerSquareMeter: 1450,
            co2Savings: 350,
            isDoubleWall: true,
            imageSystemName: "square.grid.3x3.fill",
            soundClassification: .premium,
            material: .oak,  // Default material
            moduleType: nil,
            productImage: nil
        )
    ]
    
    // Helper to create wall systems with different heights
    static func wallSystem(type: SoundClass, height: Double) -> Product {
        let baseProduct = wallSystems.first { $0.soundClassification == type }!
        return Product(
            id: "\(baseProduct.id)-H\(Int(height))",
            name: baseProduct.name,
            description: baseProduct.description,
            imageURL: baseProduct.imageURL,
            price: baseProduct.price,
            category: .walls,
            dimensions: Dimensions(
                width: standardWallWidth,
                height: height,
                depth: baseProduct.dimensions.depth
            ),
            status: baseProduct.status,
            pricePerSquareMeter: baseProduct.pricePerSquareMeter,
            co2Savings: baseProduct.co2Savings,
            isDoubleWall: baseProduct.isDoubleWall,
            imageSystemName: baseProduct.imageSystemName,
            soundClassification: baseProduct.soundClassification,
            material: baseProduct.material,
            moduleType: baseProduct.moduleType,
            productImage: baseProduct.productImage
        )
    }
    
    // Generate all wall system variations
    static var allWallSystems: [Product] {
        SoundClass.allCases.flatMap { soundClass in
            availableWallHeights.map { height in
                wallSystem(type: soundClass, height: height)
            }
        }
    }
    
    // Modules
    static let modules: [Product] = [
        Product(
            id: "MOD-001",
            name: "Monitor Module 60",
            description: "60cm wide monitor integration module",
            imageURL: nil,
            price: 499,
            category: .modules,
            dimensions: Dimensions(width: 60, height: 60, depth: 15),
            status: .available,
            pricePerSquareMeter: nil,
            co2Savings: 50,
            isDoubleWall: nil,
            imageSystemName: "tv.fill",
            soundClassification: nil,
            material: nil,
            moduleType: .monitor60,
            productImage: nil
        ),
        Product(
            id: "MOD-002",
            name: "LED Strip Module",
            description: "Integrated LED lighting module",
            imageURL: nil,
            price: 199,
            category: .modules,
            dimensions: Dimensions(width: 60, height: 10, depth: 5),
            status: .available,
            pricePerSquareMeter: nil,
            co2Savings: 25,
            isDoubleWall: nil,
            imageSystemName: "lightbulb.fill",
            soundClassification: nil,
            material: nil,
            moduleType: .ledStrip,
            productImage: nil
        )
    ]
    
    // Accessories
    static let accessories: [Product] = [
        Product(
            id: "ACC-001",
            name: "Mounting Kit",
            description: "Standard mounting kit for BoxWall modules",
            imageURL: nil,
            price: 49.99,
            category: .accessories,
            dimensions: Dimensions(width: 10, height: 10, depth: 5),
            status: .available,
            pricePerSquareMeter: nil,
            co2Savings: 10,
            isDoubleWall: nil,
            imageSystemName: "screwdriver.fill",
            soundClassification: nil,
            material: nil,
            moduleType: nil,
            productImage: nil
        )
    ]
    
    static let samples: [Product] = wallSystems + modules + accessories
}

// Add this enum for materials/finishes
enum BoxWallMaterial: String, CaseIterable {
    case oak = "Oak"
    case darkOak = "Dark_Oak"
    case greyOak = "Grey_Oak"
    case pine = "Pine"
    case walnut = "walnut"
    
    var imageAsset: String {
        rawValue
    }
}

// Add this enum for module types
enum ModuleType: String {
    case flex44 = "Flex-44"
    case flex50 = "Flex-50"
    case flexToPaint = "Flex-ToPaint"
    case monitor60 = "Monitor-60"
    case monitor80 = "Monitor-80"
    case ledStrip = "LED-Strip"
    
    var imageAsset: String {
        rawValue
    }
} 