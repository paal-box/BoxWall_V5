import SwiftUI

struct NotificationButton: View {
    let count: Int
    @State private var isAnimating = false
    
    var body: some View {
        Button(action: {}) {
            Image(systemName: "bell.fill")
                .font(BoxWallTypography.icon(size: 20))
                .foregroundColor(BoxWallColors.textPrimary)
                .overlay(alignment: .topTrailing) {
                    if count > 0 {
                        ZStack {
                            Circle()
                                .fill(BoxWallColors.attention)
                                .frame(width: 18, height: 18)
                                .scaleEffect(isAnimating ? 1.1 : 1.0)
                            
                            Text("\(count)")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .offset(x: 8, y: -8)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.0).repeatForever()) {
                                isAnimating = true
                            }
                        }
                    }
                }
        }
    }
} 