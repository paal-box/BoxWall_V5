import SwiftUI

struct CO2ImpactView: View {
    // MARK: - Properties
    @StateObject private var viewModel = CO2ViewModel()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.colorScheme) private var colorScheme
    @State private var showingCalculatorInfo = false
    
    private var isIPad: Bool {
        horizontalSizeClass == .regular
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
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
        VStack(spacing: 16) {
            // Inventory Stats
            HStack(alignment: .bottom, spacing: 24) {
                // Office Building Icon
                Image(systemName: "building.2.fill")
                    .font(.system(size: 72))
                    .foregroundColor(BoxWallColors.Brand.green)
                    .frame(width: 100, height: 100)
                    .background(BoxWallColors.secondaryBackground.opacity(0.5))
                    .clipShape(Circle())
                
                // Inventory Stats
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your BoxWall Impact")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 20) {
                        VStack(spacing: 4) {
                            Text("\(viewModel.inventoryStats.modules)")
                                .font(.headline)
                            Text("modules")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(spacing: 4) {
                            Text("\(viewModel.inventoryStats.reuses)")
                                .font(.headline)
                            Text("reuses")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(spacing: 4) {
                            Text(viewModel.inventoryStats.co2Saved)
                                .font(.headline)
                                .foregroundColor(.green)
                            Text("kg CO₂ saved")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .padding()
        .background(BoxWallColors.secondaryBackground.opacity(0.5))
        .cornerRadius(12)
    }
    
    private var equivalencySection: some View {
        Color.clear.frame(height: 0) // Removing this section since we moved it up
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
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Savings Calculator")
                    .font(.headline)
                
                Spacer()
                
                Button(action: { showingCalculatorInfo = true }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(BoxWallColors.textSecondary)
                }
            }
            
            VStack(spacing: 16) {
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
                
                // Ceiling Height Selector
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ceiling Height")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 8) {
                        ForEach(viewModel.predefinedHeights, id: \.self) { height in
                            Button(action: {
                                viewModel.setHeight(height)
                            }) {
                                Text("\(height)cm")
                                    .font(.subheadline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        !viewModel.isCustomHeight && Int(viewModel.moduleHeight * 100) == height
                                            ? BoxWallColors.Brand.green
                                            : BoxWallColors.secondaryBackground
                                    )
                                    .foregroundColor(
                                        !viewModel.isCustomHeight && Int(viewModel.moduleHeight * 100) == height
                                            ? .white
                                            : .primary
                                    )
                                    .cornerRadius(8)
                            }
                        }
                        
                        Button(action: {
                            viewModel.isCustomHeight = true
                            if viewModel.customHeight.isEmpty {
                                viewModel.customHeight = String(format: "%.0f", viewModel.moduleHeight * 100)
                            }
                        }) {
                            Text("Custom")
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    viewModel.isCustomHeight
                                        ? BoxWallColors.Brand.green
                                        : BoxWallColors.secondaryBackground
                                )
                                .foregroundColor(
                                    viewModel.isCustomHeight
                                        ? .white
                                        : .primary
                                )
                                .cornerRadius(8)
                        }
                    }
                    
                    if viewModel.isCustomHeight {
                        HStack {
                            TextField("Height (200-400)", text: Binding(
                                get: { viewModel.customHeight },
                                set: { newValue in
                                    viewModel.customHeight = newValue
                                    viewModel.validateCustomHeight()
                                    if viewModel.isValidCustomHeight {
                                        viewModel.setCustomHeight(newValue)
                                    }
                                }
                            ))
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 120)
                            
                            Text("cm")
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            if !viewModel.isValidCustomHeight {
                                Text("Enter 200-400")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.top, 4)
                    }
                }
                
                // Wall Area Slider
                SliderSection(
                    title: "Wall Area",
                    value: $viewModel.totalWallArea,
                    range: 100...10000,
                    subtitle: "Total wall area to be converted",
                    helperText: "Enter the total wall area in m² that could be replaced with BoxWall",
                    format: "%.0f m²"
                )
                
                // Annual Area Moved Slider
                SliderSection(
                    title: "Annual Area Moved",
                    value: $viewModel.annualAreaMoved,
                    range: 0...viewModel.totalWallArea,
                    subtitle: "Average wall area moved per year",
                    helperText: "Estimate how many square meters of walls are moved annually",
                    format: String(format: "%.0f m² (%d%%)", viewModel.annualAreaMoved, Int(viewModel.annualAreaMovedPercentage))
                )
                
                // Area Information
                VStack(alignment: .leading, spacing: 8) {
                    Text("Required Modules")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(String(format: "%.0f modules needed", viewModel.numberOfModules))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text(String(format: "%.1f m² total coverage", viewModel.actualTotalArea))
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
                resultsSection
            }
        }
        .padding()
        .background(BoxWallColors.secondaryBackground.opacity(0.5))
        .cornerRadius(12)
        .alert("About the Savings Calculator", isPresented: $showingCalculatorInfo) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.calculatorTooltip)
        }
    }
    
    private var resultsSection: some View {
        VStack(spacing: 16) {
            Text("Estimated Impact")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text(viewModel.selectedTimeframe.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
            
            HStack(spacing: 16) {
                ResultCard(
                    icon: "leaf.fill",
                    value: viewModel.co2Saved,
                    label: viewModel.co2SavedUnit,
                    color: .green
                )
                
                ResultCard(
                    icon: "creditcard.fill",
                    value: viewModel.financialSavings,
                    label: viewModel.financialSavingsUnit,
                    color: BoxWallColors.Brand.green
                )
            }
        }
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
        VStack(alignment: .leading, spacing: 12) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
            
            // Value and Unit
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(color)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Preview
#Preview {
    CO2ImpactView()
} 