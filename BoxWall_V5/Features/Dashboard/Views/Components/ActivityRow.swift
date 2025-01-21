import SwiftUI

struct ActivityRow: View {
    let activity: Activity
    @StateObject private var viewModel: DashboardViewModel
    @State private var isExpanded = false
    @State private var showingContactSheet = false
    
    init(activity: Activity, viewModel: DashboardViewModel) {
        self.activity = activity
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Main Card Content
            Button(action: { withAnimation(.spring()) { isExpanded.toggle() }}) {
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
                                .offset(x: 14, y: -14)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(activity.title)
                                .font(BoxWallTypography.body)
                                .foregroundColor(BoxWallColors.textPrimary)
                            
                            // Mini Icons for Quick Info
                            HStack(spacing: 4) {
                                if activity.actionRequired {
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(activity.priority.color)
                                }
                                if activity.projectNumber != nil {
                                    Image(systemName: "number.circle.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(BoxWallColors.info)
                                }
                                if activity.deadline != nil {
                                    Image(systemName: "calendar.circle.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(BoxWallColors.primary)
                                }
                            }
                        }
                        
                        Text(activity.location)
                            .font(BoxWallTypography.subheadline)
                            .foregroundColor(BoxWallColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    // Time Info
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(activity.date.timeAgo)
                            .font(BoxWallTypography.caption)
                            .foregroundColor(BoxWallColors.textSecondary)
                        
                        if let deadline = activity.deadline {
                            Text(deadline.formatted(date: .abbreviated, time: .omitted))
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
            .background(Color(.systemBackground))
            
            // Expanded Content
            if isExpanded {
                VStack(spacing: 16) {
                    // Description
                    Text(activity.description)
                        .font(BoxWallTypography.body)
                        .foregroundColor(BoxWallColors.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Project Info if available
                    if let projectNumber = activity.projectNumber {
                        HStack {
                            Label("Project #\(projectNumber)", systemImage: "folder")
                                .font(BoxWallTypography.subheadline)
                            Spacer()
                            Button("View Project") {
                                // Navigate to project
                            }
                            .font(BoxWallTypography.subheadline)
                            .foregroundColor(BoxWallColors.primary)
                        }
                    }
                    
                    // Action Buttons
                    HStack(spacing: 12) {
                        // Contact Button
                        Button(action: { showingContactSheet = true }) {
                            Label("Contact Support", systemImage: "message")
                                .font(BoxWallTypography.subheadline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(BoxWallColors.primary)
                                .cornerRadius(8)
                        }
                        
                        // Mark as Done Button
                        Button(action: {}) {
                            Label("Mark Done", systemImage: "checkmark")
                                .font(BoxWallTypography.subheadline)
                                .foregroundColor(BoxWallColors.primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(BoxWallColors.primary.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(12)
                .background(Color(.systemBackground))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        .animation(.spring(), value: isExpanded)
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
    VStack {
        ForEach(Activity.samples.prefix(2)) { activity in
            ActivityRow(
                activity: activity,
                viewModel: DashboardViewModel()
            )
        }
    }
    .padding()
    .background(Color(.systemGroupedBackground))
} 