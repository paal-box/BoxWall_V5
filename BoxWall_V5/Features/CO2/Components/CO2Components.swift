import SwiftUI
import Charts

struct CO2Components {
    // MARK: - Impact Summary Card
    struct ImpactSummaryCard: View {
        let co2Saved: Double
        let costSavings: Double
        let modulesMoved: Int
        
        var body: some View {
            VStack(spacing: 16) {
                HStack(spacing: 24) {
                    VStack(alignment: .leading) {
                        Label("\(Int(co2Saved)) kg", systemImage: "leaf.fill")
                            .foregroundColor(.green)
                        Text("CO₂ Saved")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading) {
                        Label("\(Int(costSavings)) NOK", systemImage: "creditcard.fill")
                            .foregroundColor(.blue)
                        Text("Cost Savings")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Divider()
                
                HStack {
                    Label("\(modulesMoved) modules", systemImage: "square.grid.2x2.fill")
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
        }
    }
    
    // MARK: - Environmental Impact Card
    struct EnvironmentalImpactCard: View {
        let impact: EnvironmentalImpact
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("Environmental Impact")
                    .font(.headline)
                
                HStack(spacing: 24) {
                    VStack(alignment: .leading) {
                        Label("\(impact.treesEquivalent)", systemImage: "tree.fill")
                            .foregroundColor(.green)
                        Text("Trees Planted")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading) {
                        Label(String(format: "%.1f", impact.carsPerDay), systemImage: "car.fill")
                            .foregroundColor(.blue)
                        Text("Cars Off Road/Day")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                VStack(alignment: .leading) {
                    Label(String(format: "%.1f kWh", impact.kwhSaved), systemImage: "bolt.fill")
                        .foregroundColor(.orange)
                    Text("Energy Saved")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
        }
    }
    
    // MARK: - Time Frame Selector
    struct TimeFrameSelector: View {
        @Binding var selectedTimeframe: CO2ViewModel.TimeFrame
        
        var body: some View {
            Picker("Time Frame", selection: $selectedTimeframe) {
                ForEach(CO2ViewModel.TimeFrame.allCases, id: \.self) { timeframe in
                    Text(timeframe.rawValue)
                        .tag(timeframe)
                }
            }
            .pickerStyle(.segmented)
        }
    }
    
    // MARK: - Impact History List
    struct ImpactHistoryList: View {
        let entries: [CO2ImpactEntry]
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text("Impact History")
                    .font(.headline)
                    .padding(.bottom, 4)
                
                ForEach(entries) { entry in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(entry.location.buildingName)
                                .font(.subheadline)
                            Text("\(entry.modulesMoved) modules moved")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("\(Int(entry.co2Saved)) kg CO₂")
                                .foregroundColor(.green)
                            Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                    
                    if entry.id != entries.last?.id {
                        Divider()
                    }
                }
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
        }
    }
} 