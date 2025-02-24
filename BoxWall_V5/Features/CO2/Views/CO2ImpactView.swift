import SwiftUI

struct CO2ImpactView: View {
    // MARK: - Properties
    @StateObject private var viewModel = CO2ViewModel()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.colorScheme) private var colorScheme
    
    private var isIPad: Bool {
        horizontalSizeClass == .regular
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // User Profile Section
                    userProfileSection
                    
                    // CO2 Equivalency Section
                    equivalencySection
                    
                    // Savings Calculator
                    savingsCalculatorSection
                    
                    // 10 Year Projection
                    projectionSection
                    
                    // Historical Data
                    historicalDataSection
                }
                .padding(.horizontal, isIPad ? 24 : 16)
            }
            .background(BoxWallColors.background)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("CO₂ Savings")
        }
    }
    
    // MARK: - View Components
    private var userProfileSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                // Placeholder for profile image
                Circle()
                    .fill(BoxWallColors.secondaryBackground)
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Floor 4")
                        .font(.headline)
                    Text("Tenant X")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            HStack {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .foregroundColor(.blue)
                Text("Reuses: 2")
                    .foregroundColor(.blue)
            }
            .font(.subheadline)
        }
        .padding()
        .background(BoxWallColors.secondaryBackground.opacity(0.5))
        .cornerRadius(12)
    }
    
    private var equivalencySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your CO₂ savings are equivalent to:")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 20) {
                equivalencyItem(
                    icon: "leaf.fill",
                    value: "260",
                    unit: "trees",
                    color: .green
                )
                
                equivalencyItem(
                    icon: "car.fill",
                    value: "13.3",
                    unit: "cars/day",
                    color: .blue
                )
                
                equivalencyItem(
                    icon: "bolt.fill",
                    value: "12732.6",
                    unit: "kWh",
                    color: .yellow
                )
            }
        }
        .padding()
        .background(BoxWallColors.secondaryBackground.opacity(0.5))
        .cornerRadius(12)
    }
    
    private func equivalencyItem(icon: String, value: String, unit: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 24))
            
            Text(value)
                .font(.headline)
            
            Text(unit)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var savingsCalculatorSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Savings Calculator")
                    .font(.headline)
                
                Spacer()
                
                Button(action: { /* Add help action */ }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(BoxWallColors.textSecondary)
                }
            }
            
            VStack(spacing: 24) {
                // Timeframe Picker
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Time Period")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("(for calculation)")
                            .font(.caption)
                            .foregroundColor(BoxWallColors.textSecondary)
                    }
                    
                    Picker("Time Period", selection: $viewModel.selectedTimeframe) {
                        ForEach(TimeFrame.allCases, id: \.self) { timeframe in
                            Text(timeframe.rawValue)
                                .tag(timeframe)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Text(viewModel.selectedTimeframe.description)
                        .font(.caption)
                        .foregroundColor(BoxWallColors.textSecondary)
                }
                
                // Module Height Slider
                SliderSection(
                    title: "Module Height",
                    value: $viewModel.moduleHeight,
                    range: 2.4...4.0,
                    subtitle: "Please select your average ceiling height",
                    helperText: "Standard module starts at 2.4m",
                    format: "%.1f m"
                )
                
                HStack(spacing: 4) {
                    Image(systemName: "leaf.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                    Text("CO₂ per unit: \(Int(viewModel.getCO2PerUnit(forHeight: viewModel.moduleHeight))) kg")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 4)
                
                SliderSection(
                    title: "Wall Movements",
                    value: $viewModel.wallMovements,
                    range: 0...10,
                    subtitle: "Expected number of refits over building lifetime",
                    helperText: "Each refit represents a complete reconfiguration of the wall modules",
                    format: "%.0f"
                )
                
                SliderSection(
                    title: "Modules",
                    value: $viewModel.modules,
                    range: 0...500,
                    subtitle: "Total number of modules in the project",
                    helperText: "More modules = greater potential for CO₂ savings through reuse",
                    format: "%.0f"
                )
                
                // Area Information
                VStack(alignment: .leading, spacing: 8) {
                    Text("Area")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(String(format: "%.1f m² per module", viewModel.moduleArea))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text(String(format: "%.1f m² total area", viewModel.totalArea))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "square.dashed")
                            .foregroundColor(BoxWallColors.textSecondary)
                            .font(.system(size: 24))
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(BoxWallColors.secondaryBackground.opacity(0.5))
                    .cornerRadius(8)
                }
                
                // Results
                VStack(spacing: 16) {
                    VStack(spacing: 4) {
                        Text("Estimated Impact")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(viewModel.selectedTimeframe.description)
                            .font(.caption)
                            .foregroundColor(BoxWallColors.textSecondary)
                    }
                    
                    HStack(spacing: 20) {
                        ResultCard(
                            icon: "leaf.fill",
                            value: viewModel.co2Saved,
                            label: "CO₂ Saved",
                            color: .green
                        )
                        
                        ResultCard(
                            icon: "creditcard.fill",
                            value: viewModel.financialSavings,
                            label: "Cost Savings",
                            color: BoxWallColors.Brand.green
                        )
                    }
                }
            }
        }
        .padding()
        .background(BoxWallColors.secondaryBackground.opacity(0.5))
        .cornerRadius(12)
    }
    
    private var projectionSection: some View {
        Color.clear.frame(height: 100)
    }
    
    private var historicalDataSection: some View {
        Color.clear.frame(height: 150)
    }
}

// MARK: - Supporting Views
private struct SliderSection: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    var subtitle: String? = nil
    var helperText: String? = nil
    var format: String = "%.0f"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text(String(format: format, value))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Slider(value: $value, in: range)
                .tint(BoxWallColors.Brand.green)
            
            if let subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if let helperText {
                Text(helperText)
                    .font(.caption)
                    .foregroundColor(BoxWallColors.textSecondary)
                    .padding(.top, 2)
            }
        }
    }
}

private struct ResultCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(.headline)
                .foregroundColor(color)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Preview
#Preview {
    CO2ImpactView()
} 