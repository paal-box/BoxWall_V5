import SwiftUI

// Helper Extensions
extension UIView {
    var allSubviews: [UIView] {
        var allSubviews = subviews
        for subview in subviews {
            allSubviews.append(contentsOf: subview.allSubviews)
        }
        return allSubviews
    }
}

extension UIScrollView {
    func scrollToView(withIdentifier id: String) {
        if let targetView = self.allSubviews.first(where: { $0.accessibilityIdentifier == id }) {
            let targetRect = targetView.convert(targetView.bounds, to: self)
            let paddedRect = CGRect(
                x: targetRect.minX,
                y: max(0, targetRect.minY - 20),
                width: targetRect.width,
                height: targetRect.height + 100
            )
            scrollRectToVisible(paddedRect, animated: true)
        }
    }
}

struct ActivityRow: View {
    let activity: Activity
    @StateObject private var viewModel: DashboardViewModel
    @State private var isExpanded = false
    @State private var showingContactSheet = false
    @State private var showingContactSupport = false
    let scrollProxy: ScrollViewProxy
    
    // Add tab bar height constant
    private let tabBarHeight: CGFloat = DesignSystem.Layout.tabBarHeight
    
    init(activity: Activity, viewModel: DashboardViewModel, scrollProxy: ScrollViewProxy) {
        self.activity = activity
        self.scrollProxy = scrollProxy
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Main Card Content
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isExpanded.toggle()
                    
                    // Only scroll if expanding and after a slight delay
                    if isExpanded {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                scrollProxy.scrollTo("activity-\(activity.id)", anchor: .center)
                            }
                        }
                    }
                }
            }) {
                HStack(spacing: 16) {
                    // Activity Icon
                    Image(systemName: activity.type.icon)
                        .font(.system(size: 20))
                        .foregroundColor(activity.type.color)
                        .frame(width: 32)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(activity.title)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(BoxWallColors.textPrimary)
                        
                        Text(activity.location)
                            .font(.system(size: 15))
                            .foregroundColor(BoxWallColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    // Time Info
                    Text(activity.date.timeAgoDisplay())
                        .font(.system(size: 15))
                        .foregroundColor(BoxWallColors.textSecondary)
                }
                .padding(.vertical, 12)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            // Expanded Content
            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    // Description
                    Text(activity.description)
                        .font(.system(size: 15))
                        .foregroundColor(BoxWallColors.textPrimary)
                        .padding(.top, 8)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    
                    // Project Info if available
                    if let projectNumber = activity.projectNumber {
                        HStack {
                            Text("Project #\(projectNumber)")
                                .font(.system(size: 13))
                            Spacer()
                            Button("View Project") {
                                // Navigate to project
                            }
                            .font(.system(size: 13))
                            .foregroundColor(BoxWallColors.Brand.green)
                        }
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
                    // Action Buttons
                    HStack(spacing: 12) {
                        // Contact Button
                        Button(action: { showingContactSupport = true }) {
                            Text("Contact Support")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(BoxWallColors.Brand.green)
                                .cornerRadius(8)
                        }
                        
                        // Mark as Done Button
                        Button(action: {}) {
                            Text("Mark Done")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(BoxWallColors.Brand.green)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(BoxWallColors.Brand.greenLight)
                                .cornerRadius(8)
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
                .padding(.horizontal, 48)
                .padding(.bottom, 16)
            }
        }
        .background(BoxWallColors.background)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isExpanded)
        .sheet(isPresented: $showingContactSupport) {
            ContactSupportView(activity: activity)
        }
    }
}

// MARK: - Preview
#Preview {
    ScrollViewReader { proxy in
        VStack {
            ForEach(Activity.samples.prefix(2)) { activity in
                ActivityRow(
                    activity: activity,
                    viewModel: DashboardViewModel(),
                    scrollProxy: proxy
                )
            }
        }
        .padding()
        .background(BoxWallColors.groupedBackground)
    }
} 