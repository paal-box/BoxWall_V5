import Foundation

/// Manages the product catalog for the BoxWall system
@MainActor
final class ProductCatalog: ObservableObject {
    /// All available products
    @Published private(set) var products: [Product] = []
    
    /// Products filtered by category
    @Published private(set) var productsByCategory: [Product.Category: [Product]] = [:]
    
    /// Singleton instance
    static let shared = ProductCatalog()
    
    private init() {
        // Load initial sample data
        products = Product.samples
        updateProductsByCategory()
    }
    
    /// Updates the category-based product organization
    private func updateProductsByCategory() {
        productsByCategory = Dictionary(
            grouping: products,
            by: { $0.category }
        )
    }
    
    /// Fetches products by category
    /// - Parameter category: The category to filter by
    /// - Returns: Array of products in the specified category
    func products(in category: Product.Category) -> [Product] {
        productsByCategory[category] ?? []
    }
    
    /// Fetches a product by its ID
    /// - Parameter id: The product ID to look up
    /// - Returns: The product if found, nil otherwise
    func product(withID id: String) -> Product? {
        products.first { $0.id == id }
    }
    
    /// Checks if a product is available
    /// - Parameter id: The product ID to check
    /// - Returns: True if the product is available
    func isProductAvailable(_ id: String) -> Bool {
        guard let product = product(withID: id) else { return false }
        return product.status == .available
    }
    
    /// Fetches all wall systems
    var wallSystems: [Product] {
        products(in: .walls)
    }
    
    /// Fetches all modules
    var modules: [Product] {
        products(in: .modules)
    }
    
    /// Fetches all accessories
    var accessories: [Product] {
        products(in: .accessories)
    }
    
    /// Calculates total CO2 savings for a collection of products
    func calculateTotalCO2Savings(for products: [Product]) -> Int {
        products.compactMap { $0.co2Savings }.reduce(0, +)
    }
    
    /// Calculates price per square meter for wall systems
    func calculateWallSystemPrice(product: Product, area: Double) -> Decimal? {
        guard product.category == .walls,
              let pricePerSquareMeter = product.pricePerSquareMeter
        else { return nil }
        
        return pricePerSquareMeter * Decimal(area)
    }
    
    /// Fetches wall systems by sound classification
    func wallSystems(soundClass: Product.SoundClass) -> [Product] {
        wallSystems.filter { $0.soundClassification == soundClass }
    }
    
    /// Fetches wall systems by height
    func wallSystems(height: Double) -> [Product] {
        wallSystems.filter { $0.dimensions.height == height }
    }
    
    /// Fetches wall system by sound class and height
    func wallSystem(soundClass: Product.SoundClass, height: Double) -> Product? {
        wallSystems.first { 
            $0.soundClassification == soundClass && 
            $0.dimensions.height == height 
        }
    }
} 