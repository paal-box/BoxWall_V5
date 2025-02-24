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
    @Published var wallMovements: Double = 2
    @Published var modules: Double = 50
    @Published var moduleHeight: Double = 2.4  // Default height in meters
    
    // Module dimensions
    private let moduleWidth: Double = 0.6  // Standard module width in meters
    
    // Area calculations
    var moduleArea: Double {
        moduleHeight * moduleWidth
    }
    
    var totalArea: Double {
        moduleArea * modules
    }
    
    // CO2 impact calculations based on height
    func getCO2PerUnit(forHeight height: Double) -> Double {
        // Base CO2 for 2.4m height is 354.2 kg
        // Calculate proportional increase based on height
        let baseHeight = 2.4
        let baseCO2 = 354.2
        return baseCO2 * (height / baseHeight)
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
        return formatNumber(amount) + " kg"
    }
    
    var financialSavings: String {
        let amount = Int(calculateFinancialSavings())
        return formatNumber(amount) + " NOK"
    }
    
    // MARK: - Initialization
    init(location: CO2Data.LocationData = CO2Data.sample.location) {
        self.currentLocation = location
        self.environmentalImpact = EnvironmentalImpact(co2InKg: 0)
        loadImpactData()
    }
    
    // MARK: - Private Methods
    private func calculateCO2Savings() -> Double {
        let baseImpact = getCO2PerUnit(forHeight: moduleHeight) * modules
        let movementImpact = baseImpact * max(1, wallMovements) * reusabilityFactor
        let transportImpact = baseImpact * transportEmissionFactor
        let monthlyImpact = movementImpact + transportImpact
        return monthlyImpact * selectedTimeframe.multiplier
    }
    
    private func calculateFinancialSavings() -> Double {
        let basePrice = getBasePrice(forHeight: moduleHeight) * modules
        let installationCost = basePrice * installationCostFactor
        let totalCostPerMove = basePrice + installationCost
        let monthlySavings = totalCostPerMove * max(1, wallMovements)
        return monthlySavings * selectedTimeframe.multiplier
    }
    
    private func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
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
}

// MARK: - Preview Helper
extension CO2ViewModel {
    static var preview: CO2ViewModel {
        let viewModel = CO2ViewModel()
        viewModel.modules = 50
        viewModel.moduleHeight = 2.4
        viewModel.wallMovements = 2
        return viewModel
    }
} 