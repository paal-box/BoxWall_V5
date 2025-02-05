import SwiftUI

struct ShopView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("Shop Coming Soon")
                .font(.title)
                .foregroundColor(BoxWallColors.textPrimary)
            
            Text("Our shop is currently under development")
                .font(.subheadline)
                .foregroundColor(BoxWallColors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BoxWallColors.background)
        .navigationTitle("Shop")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                        .font(.title2)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ShopView()
    }
} 