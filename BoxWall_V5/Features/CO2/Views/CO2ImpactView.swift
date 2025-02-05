import SwiftUI

struct CO2ImpactView: View {
    @StateObject private var viewModel = CO2ViewModel()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.dismiss) private var dismiss
    
    private var isIPad: Bool {
        horizontalSizeClass == .regular
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero Header Section
                VStack(spacing: isIPad ? 24 : 16) {
                    // Title and Description
                    VStack(spacing: 8) {
                        Text("Environmental Impact")
                            .font(isIPad ? .largeTitle.bold() : .title.bold())
                            .foregroundColor(.white)
                        
                        Text("Track your contribution to a sustainable future")
                            .font(isIPad ? .title3 : .subheadline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.top, isIPad ? 40 : 20)
                    
                    // Main Stats
                    HStack(spacing: isIPad ? 40 : 20) {
                        StatCard(
                            title: "CO₂ Saved",
                            value: "\(Int(viewModel.totalCO2Saved))",
                            unit: "kg",
                            icon: "leaf.fill",
                            color: .green
                        )
                        
                        StatCard(
                            title: "Cost Savings",
                            value: "\(Int(viewModel.totalCostSavings))",
                            unit: "NOK",
                            icon: "creditcard.fill",
                            color: .blue
                        )
                        
                        if isIPad {
                            StatCard(
                                title: "Modules Moved",
                                value: "\(Int(viewModel.averageModulesMoved))",
                                unit: "units",
                                icon: "cube.fill",
                                color: .orange
                            )
                        }
                    }
                    .padding(.bottom, isIPad ? 40 : 20)
                }
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        colors: [
                            BoxWallColors.Brand.green,
                            BoxWallColors.Brand.green.opacity(0.8)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                
                // Content Sections
                VStack(spacing: 24) {
                    // Time Frame Selector
                    CO2Components.TimeFrameSelector(selectedTimeframe: $viewModel.selectedTimeframe)
                        .padding(.horizontal)
                        .padding(.top, 24)
                    
                    if isIPad {
                        // iPad Layout
                        HStack(alignment: .top, spacing: 24) {
                            // Left Column
                            VStack(spacing: 24) {
                                // Environmental Impact Card
                                CO2Components.EnvironmentalImpactCard(impact: viewModel.environmentalImpact)
                                    .frame(maxWidth: .infinity)
                            }
                            .frame(maxWidth: .infinity)
                            
                            // Right Column - Impact History
                            VStack(spacing: 16) {
                                Text("Impact History")
                                    .font(.title2.bold())
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                LazyVGrid(
                                    columns: [GridItem(.flexible())],
                                    spacing: 16
                                ) {
                                    ForEach(viewModel.impactEntries) { entry in
                                        ImpactHistoryCard(entry: entry)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal)
                    } else {
                        // iPhone Layout
                        VStack(spacing: 24) {
                            CO2Components.EnvironmentalImpactCard(impact: viewModel.environmentalImpact)
                            CO2Components.ImpactHistoryList(entries: viewModel.impactEntries)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 24)
            }
        }
        .background(BoxWallColors.background)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { /* Add new impact entry */ }) {
                    Label("Add Entry", systemImage: "plus.circle.fill")
                        .foregroundColor(BoxWallColors.Brand.green)
                }
            }
            
            if !isIPad {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Supporting Views
private struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Text(unit)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.9))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.white.opacity(0.1))
        .cornerRadius(12)
    }
}

private struct ImpactHistoryCard: View {
    let entry: CO2ImpactEntry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.location.buildingName)
                    .font(.headline)
                Text("\(entry.modulesMoved) modules moved")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(entry.co2Saved)) kg CO₂")
                    .font(.headline)
                    .foregroundColor(.green)
                Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(BoxWallColors.secondaryBackground)
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        CO2ImpactView()
    }
} 