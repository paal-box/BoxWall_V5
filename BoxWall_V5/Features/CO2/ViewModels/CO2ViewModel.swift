import Foundation
import SwiftUI

@MainActor
class CO2ViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var impactEntries: [CO2ImpactEntry] = []
    @Published private(set) var currentLocation: CO2Data.LocationData
    @Published private(set) var environmentalImpact: EnvironmentalImpact
    @Published var selectedTimeframe: TimeFrame = .annual
    
    // Calculator Properties
    @Published var annualAreaMoved: Double = 100  // Default annual area moved in m²
    @Published var totalWallArea: Double = 500  // Default wall area in m²
    @Published var moduleHeight: Double = 2.4  // Default height in meters
    @Published var isCustomHeight = false
    @Published var customHeight: String = ""  // For custom height input
    @Published private(set) var isValidCustomHeight = true  // Track custom height validity
    
    // Predefined ceiling heights in cm
    let predefinedHeights = [240, 270, 320]
    
    // Module dimensions
    private let moduleWidth: Double = 0.6  // Standard module width in meters
    
    // Inventory data (to be replaced with actual inventory later)
    private let inventoryModules = 145  // Dummy data
    private let inventoryReuses = 2     // Dummy data
    
    // Calculate effective movements based on area
    private var effectiveAnnualMovements: Double {
        // If moving more area than total area, cap at total area
        min(annualAreaMoved, totalWallArea) / totalWallArea
    }
    
    // Percentage of total area moved annually
    var annualAreaMovedPercentage: Double {
        (annualAreaMoved / totalWallArea) * 100
    }
    
    // Total area moved over building lifetime
    private var totalLifetimeAreaMoved: Double {
        // Annual area moved × building lifetime (60 years)
        annualAreaMoved * 60
    }
    
    // Area calculations
    var moduleArea: Double {
        moduleHeight * moduleWidth
    }
    
    var numberOfModules: Double {
        // Calculate number of modules needed to cover the total wall area
        ceil(totalWallArea / moduleArea)
    }
    
    var actualTotalArea: Double {
        // Actual area covered by the calculated number of modules
        moduleArea * numberOfModules
    }
    
    // Inventory impact calculations
    var inventoryCO2Savings: Double {
        let heightFactor = moduleHeight / baseHeight
        let adjustedSavingsPerM2 = baseCO2SavingsPerM2 * heightFactor
        let areaPerModule = moduleHeight * moduleWidth
        return adjustedSavingsPerM2 * areaPerModule * Double(inventoryModules) * Double(inventoryReuses + 1)
    }
    
    // Base CO2 savings constants
    private let baseCO2SavingsPerM2: Double = 30.0  // kg of CO2 saved per m² at 2.4m height
    private let baseHeight: Double = 2.4  // Base module height in meters
    
    // CO2 impact calculations based on height
    func getCO2PerUnit(forHeight height: Double) -> Double {
        // Calculate proportional increase based on height
        let heightFactor = height / baseHeight
        let co2SavingsPerM2 = baseCO2SavingsPerM2 * heightFactor
        return co2SavingsPerM2 * moduleArea
    }
    
    private func getBasePrice(forHeight height: Double) -> Double {
        // Base price for 2.4m height is 3500 NOK
        // Calculate proportional increase based on height
        let baseHeight = 2.4
        let basePrice = 3500.0
        return basePrice * (height / baseHeight)
    }
    
    // Constants for calculations
    private let reusabilityFactor: Double = 0.85  // 85% efficiency in reuse
    private let transportEmissionFactor: Double = 0.2  // 20% additional from transport
    private let installationCostFactor: Double = 0.15  // 15% of base price for installation
    
    // MARK: - Computed Properties
    var totalCO2Saved: Double {
        impactEntries.totalCO2Saved
    }
    
    var totalCostSavings: Double {
        impactEntries.totalCostSavings
    }
    
    var averageModulesMoved: Double {
        impactEntries.averageModulesMoved
    }
    
    var co2Saved: String {
        let amount = Int(calculateCO2Savings())
        if amount >= 1_000_000 {
            return "\(formatNumber(amount / 1_000_000))M"
        } else if amount >= 1_000 {
            return "\(formatNumber(amount / 1_000))K"
        }
        return formatNumber(amount)
    }
    
    var co2SavedUnit: String {
        "kg CO₂"
    }
    
    var financialSavings: String {
        let amount = Int(calculateFinancialSavings())
        if amount >= 1_000_000 {
            return "\(formatNumber(amount / 1_000_000))M"
        } else if amount >= 1_000 {
            return "\(formatNumber(amount / 1_000))K"
        }
        return formatNumber(amount)
    }
    
    var financialSavingsUnit: String {
        "NOK"
    }
    
    var calculatorTooltip: String {
        """
        A BoxWall module saves 30kg of CO₂ per m² compared to traditional plaster walls. \
        The savings increase proportionally with wall height. Each time you reuse the modules, \
        you save the same amount again by avoiding building another traditional wall.
        """
    }
    
    // MARK: - Computed Properties for Inventory Display
    var inventoryStats: (modules: Int, reuses: Int, co2Saved: String) {
        let co2Amount = Int(inventoryCO2Savings)
        let formattedCO2 = if co2Amount >= 1_000_000 {
            "\(formatNumber(co2Amount / 1_000_000))M"
        } else if co2Amount >= 1_000 {
            "\(formatNumber(co2Amount / 1_000))K"
        } else {
            formatNumber(co2Amount)
        }
        
        return (inventoryModules, inventoryReuses, formattedCO2)
    }
    
    // MARK: - Initialization
    init(location: CO2Data.LocationData = CO2Data.sample.location) {
        self.currentLocation = location
        self.environmentalImpact = EnvironmentalImpact(co2InKg: 0)
        loadImpactData()
    }
    
    // MARK: - Private Methods
    private func calculateCO2Savings() -> Double {
        // 1. Calculate base savings per m² adjusted for height
        let heightFactor = moduleHeight / baseHeight
        let adjustedSavingsPerM2 = baseCO2SavingsPerM2 * heightFactor
        
        // 2. Calculate area per module
        let moduleArea = moduleHeight * moduleWidth
        
        // 3. Calculate savings based on moved area for the timeframe
        let areaMovedForTimeframe: Double
        switch selectedTimeframe {
        case .annual:
            areaMovedForTimeframe = annualAreaMoved
        case .tenYears:
            areaMovedForTimeframe = annualAreaMoved * 10
        case .buildingLifetime:
            areaMovedForTimeframe = totalLifetimeAreaMoved
        }
        
        // Cap the moved area at total wall area × timeframe length
        let maxAreaForTimeframe = totalWallArea * (selectedTimeframe == .annual ? 1 : selectedTimeframe == .tenYears ? 10 : 60)
        let effectiveAreaMoved = min(areaMovedForTimeframe, maxAreaForTimeframe)
        
        // Calculate movements ratio (how many times each m² is moved on average)
        let movementsRatio = effectiveAreaMoved / totalWallArea
        
        // 4. Calculate total savings including initial installation and movements
        let savingsPerModule = adjustedSavingsPerM2 * moduleArea * (movementsRatio + 1)
        let totalSavings = savingsPerModule * numberOfModules
        
        return totalSavings
    }
    
    private func calculateFinancialSavings() -> Double {
        // Base cost for initial installation
        let basePrice = getBasePrice(forHeight: moduleHeight) * numberOfModules
        let installationCost = basePrice * installationCostFactor
        let totalInitialCost = basePrice + installationCost
        
        // Cost for each reuse (only installation cost)
        let reuseInstallationCost = installationCost * effectiveAnnualMovements
        
        // Total lifetime savings compared to traditional walls
        let totalLifetimeSavings = totalInitialCost + reuseInstallationCost
        
        // Apply timeframe adjustment
        switch selectedTimeframe {
        case .annual:
            return totalLifetimeSavings / 60.0
        case .tenYears:
            return (totalLifetimeSavings / 60.0) * 10.0
        case .buildingLifetime:
            return totalLifetimeSavings
        }
    }
    
    private func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    // MARK: - Public Methods
    func addImpactEntry(modulesMoved: Int) {
        let entry = CO2ImpactEntry(
            modulesMoved: modulesMoved,
            location: currentLocation
        )
        impactEntries.append(entry)
        updateEnvironmentalImpact()
        saveImpactData()
    }
    
    func updateTimeframe(_ timeframe: TimeFrame) {
        selectedTimeframe = timeframe
        updateEnvironmentalImpact()
    }
    
    private func updateEnvironmentalImpact() {
        let dateRange = selectedTimeframe.dateRange
        let filteredEntries = impactEntries.entriesForPeriod(
            from: dateRange.start,
            to: dateRange.end
        )
        environmentalImpact = EnvironmentalImpact(co2InKg: filteredEntries.totalCO2Saved)
    }
    
    private func loadImpactData() {
        // TODO: Implement data persistence
        // For now, using sample data
        impactEntries = [
            CO2ImpactEntry(date: .now.addingTimeInterval(-86400 * 7), modulesMoved: 10, location: currentLocation),
            CO2ImpactEntry(date: .now.addingTimeInterval(-86400 * 14), modulesMoved: 15, location: currentLocation),
            CO2ImpactEntry(date: .now.addingTimeInterval(-86400 * 21), modulesMoved: 20, location: currentLocation)
        ]
        updateEnvironmentalImpact()
    }
    
    private func saveImpactData() {
        // TODO: Implement data persistence
    }
    
    func setHeight(_ heightInCm: Int) {
        isCustomHeight = false
        moduleHeight = Double(heightInCm) / 100.0
    }
    
    func setCustomHeight(_ heightString: String) {
        customHeight = heightString.replacingOccurrences(of: ",", with: ".")
        if let height = Double(customHeight), height >= 200, height <= 400 {
            moduleHeight = height / 100.0
            isValidCustomHeight = true
        } else {
            isValidCustomHeight = false
        }
    }
    
    // Add validation when custom height changes
    func validateCustomHeight() {
        if let height = Double(customHeight.replacingOccurrences(of: ",", with: ".")) {
            isValidCustomHeight = height >= 200 && height <= 400
        } else {
            isValidCustomHeight = false
        }
    }
}

// MARK: - Preview Helper
extension CO2ViewModel {
    static var preview: CO2ViewModel {
        let viewModel = CO2ViewModel()
        viewModel.totalWallArea = 500
        viewModel.moduleHeight = 2.4
        viewModel.annualAreaMoved = 100
        return viewModel
    }
} 