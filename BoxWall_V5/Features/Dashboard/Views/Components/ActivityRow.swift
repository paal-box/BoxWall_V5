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
    @Namespace private var animation
    let scrollProxy: ScrollViewProxy
    
    // Add tab bar height constant
    private let tabBarHeight: CGFloat = DesignSystem.Layout.tabBarHeight
    
    init(activity: Activity, viewModel: DashboardViewModel, scrollProxy: ScrollViewProxy) {
        self.activity = activity
        self.scrollProxy = scrollProxy
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Main Card Content
            Button(action: {
                withAnimation(.spring()) {
                    isExpanded.toggle()
                }
                
                if isExpanded {
                    // Scroll the expanded card into view with a slight delay
                    // to allow animation to start
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            scrollProxy.scrollTo("activity-\(activity.id)", anchor: .center)
                        }
                    }
                }
            }) {
                HStack(spacing: 16) {
                    // Activity Icon with Status
                    ZStack {
                        Circle()
                            .fill(activity.type.color.opacity(0.1))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: activity.type.icon)
                            .font(BoxWallTypography.icon(size: 16))
                            .foregroundColor(activity.type.color)
                        
                        // Priority Indicator
                        if activity.actionRequired {
                            Circle()
                                .fill(activity.priority.color)
                                .frame(width: 8, height: 8)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 1)
                                )
                                .offset(x: 12, y: -12)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(activity.title)
                            .font(BoxWallTypography.body)
                            .foregroundColor(BoxWallColors.textPrimary)
                        
                        Text(activity.location)
                            .font(BoxWallTypography.subheadline)
                            .foregroundColor(BoxWallColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    // Time Info
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(activity.date.simpleDateDisplay())
                            .font(BoxWallTypography.caption)
                            .foregroundColor(BoxWallColors.textSecondary)
                        
                        if let deadline = activity.deadline {
                            Text("Due \(deadline.formatted(date: .numeric, time: .omitted))")
                                .font(BoxWallTypography.caption)
                                .foregroundColor(activity.priority.color)
                        }
                    }
                    
                    // Expand/Collapse Indicator
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(BoxWallColors.textSecondary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
            }
            .padding(12)
            .background(BoxWallColors.background)
            .accessibilityIdentifier("activity-\(activity.id)")
            
            // Expanded Content
            if isExpanded {
                VStack(spacing: 16) {
                    // Description
                    Text(activity.description)
                        .font(BoxWallTypography.subheadline)
                        .foregroundColor(BoxWallColors.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Project Info if available
                    if let projectNumber = activity.projectNumber {
                        HStack {
                            Label("Project #\(projectNumber)", systemImage: "folder")
                                .font(BoxWallTypography.caption)
                            Spacer()
                            Button("View Project") {
                                // Navigate to project
                            }
                            .font(BoxWallTypography.caption)
                            .foregroundColor(BoxWallColors.primary)
                        }
                    }
                    
                    // Action Buttons
                    HStack(spacing: 12) {
                        // Contact Button
                        Button(action: { showingContactSheet = true }) {
                            Label("Contact Support", systemImage: "message")
                                .font(BoxWallTypography.caption)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(BoxWallColors.primary)
                                .cornerRadius(8)
                        }
                        
                        // Mark as Done Button
                        Button(action: {}) {
                            Label("Mark Done", systemImage: "checkmark")
                                .font(BoxWallTypography.caption)
                                .foregroundColor(BoxWallColors.primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(BoxWallColors.primary.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(12)
                .background(BoxWallColors.background)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.05), radius: 5, x: 0, y: 2)
        .animation(.spring(), value: isExpanded)
        .padding(.horizontal)
        .sheet(isPresented: $showingContactSheet) {
            ContactSupportView(
                activity: activity,
                viewModel: viewModel
            )
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