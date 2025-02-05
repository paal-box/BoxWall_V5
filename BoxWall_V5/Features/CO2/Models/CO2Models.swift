import Foundation
import SwiftUI

// MARK: - Core Data Models
struct CO2Data: Identifiable, Codable {
    let id: UUID
    let location: LocationData
    let reuses: Int
    let modulesCount: Int
    let size: Double // in m²
    var co2Saved: Double
    var costSavings: Double
    let lastUpdated: Date
    
    init(
        id: UUID = UUID(),
        location: LocationData,
        reuses: Int,
        modulesCount: Int,
        size: Double,
        co2Saved: Double,
        costSavings: Double,
        lastUpdated: Date = Date()
    ) {
        self.id = id
        self.location = location
        self.reuses = reuses
        self.modulesCount = modulesCount
        self.size = size
        self.co2Saved = co2Saved
        self.costSavings = costSavings
        self.lastUpdated = lastUpdated
    }
}

// MARK: - Location Data
extension CO2Data {
    struct LocationData: Codable {
        let buildingName: String
        let floorNumber: Int
        let tenantName: String
    }
}

// MARK: - CO2 Impact Entry
struct CO2ImpactEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    let modulesMoved: Int
    let location: CO2Data.LocationData
    
    var co2Saved: Double {
        Double(modulesMoved) * Constants.CO2.savingsPerModule
    }
    
    var costSavings: Double {
        Double(modulesMoved) * Constants.Cost.savingsPerModule
    }
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        modulesMoved: Int,
        location: CO2Data.LocationData
    ) {
        self.id = id
        self.date = date
        self.modulesMoved = modulesMoved
        self.location = location
    }
}

// MARK: - Environmental Impact
struct EnvironmentalImpact {
    let co2InKg: Double
    
    var treesEquivalent: Int {
        Int(co2InKg / Constants.CO2.treesPerKg)
    }
    
    var carsPerDay: Double {
        co2InKg / Constants.CO2.carsPerKg
    }
    
    var kwhSaved: Double {
        co2InKg / Constants.CO2.kwhPerKg
    }
}

// MARK: - Constants
enum Constants {
    enum CO2 {
        static let savingsPerModule: Double = 30.0
        static let treesPerKg: Double = 21.0
        static let carsPerKg: Double = 411.0
        static let kwhPerKg: Double = 0.43
    }
    
    enum Cost {
        static let savingsPerModule: Double = 630.0
    }
}

// MARK: - Sample Data
extension CO2Data {
    static let sample = CO2Data(
        location: .init(
            buildingName: "Cissi Klein",
            floorNumber: 4,
            tenantName: "Tenant X"
        ),
        reuses: 2,
        modulesCount: 50,
        size: 2.5,
        co2Saved: 5475.0,
        costSavings: 78750.0
    )
}

// MARK: - Helper Extensions
extension Array where Element == CO2ImpactEntry {
    var totalCO2Saved: Double {
        reduce(0) { $0 + $1.co2Saved }
    }
    
    var totalCostSavings: Double {
        reduce(0) { $0 + $1.costSavings }
    }
    
    var averageModulesMoved: Double {
        guard !isEmpty else { return 0 }
        return Double(reduce(0) { $0 + $1.modulesMoved }) / Double(count)
    }
    
    func entriesForPeriod(from startDate: Date, to endDate: Date) -> [CO2ImpactEntry] {
        filter { entry in
            entry.date >= startDate && entry.date <= endDate
        }
    }
} 