import Foundation
import SwiftUI

@MainActor
class CO2ViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var impactEntries: [CO2ImpactEntry] = []
    @Published private(set) var currentLocation: CO2Data.LocationData
    @Published private(set) var environmentalImpact: EnvironmentalImpact
    @Published var selectedTimeframe: TimeFrame = .month
    
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
    
    // MARK: - Time Frame Enum
    enum TimeFrame: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
        case all = "All Time"
        
        var dateRange: (start: Date, end: Date) {
            let end = Date()
            let start: Date
            
            switch self {
            case .week:
                start = Calendar.current.date(byAdding: .day, value: -7, to: end)!
            case .month:
                start = Calendar.current.date(byAdding: .month, value: -1, to: end)!
            case .year:
                start = Calendar.current.date(byAdding: .year, value: -1, to: end)!
            case .all:
                start = Date.distantPast
            }
            
            return (start, end)
        }
    }
    
    // MARK: - Initialization
    init(location: CO2Data.LocationData = CO2Data.sample.location) {
        self.currentLocation = location
        self.environmentalImpact = EnvironmentalImpact(co2InKg: 0)
        loadImpactData()
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
    
    // MARK: - Private Methods
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