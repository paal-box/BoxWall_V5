import SwiftUI

struct ReFlexView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // ReFlex Icon
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: 60))
                    .foregroundColor(BoxWallColors.Brand.green)
                    .padding(.top, 40)
                
                Text("ReFlex Marketplace")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                
                Text("Sell unused modules for cash back and track their CO₂ savings")
                    .font(.system(size: 17, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                // Placeholder content
                Text("Coming Soon")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
                    .padding(.bottom, 40)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ReFlexView()
} 