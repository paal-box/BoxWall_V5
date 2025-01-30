import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel = NewsViewModel()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    private var columns: [GridItem] {
        if horizontalSizeClass == .regular {
            [
                GridItem(.flexible(), spacing: 24),
                GridItem(.flexible(), spacing: 24)
            ]
        } else {
            [GridItem(.flexible())]
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Latest News")
                            .font(BoxWallTypography.title1)
                            .foregroundColor(BoxWallColors.textPrimary)
                        
                        Text("Stay updated with BoxWall")
                            .font(BoxWallTypography.subheadline)
                            .foregroundColor(BoxWallColors.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 16)
                    
                    if viewModel.isLoading && viewModel.articles.isEmpty {
                        LoadingView()
                    } else if let error = viewModel.errorMessage {
                        ErrorView(error: error) {
                            Task {
                                await viewModel.loadNews()
                            }
                        }
                    } else {
                        // News Grid
                        LazyVGrid(columns: columns, spacing: 24) {
                            ForEach(viewModel.articles) { article in
                                NewsArticleCard(article: article)
                                    .onTapGesture {
                                        viewModel.openArticle(article)
                                    }
                            }
                        }
                        .padding(.horizontal)
                        .animation(.easeInOut, value: horizontalSizeClass)
                    }
                }
                .padding(.bottom, 24)
            }
            .background(BoxWallColors.background.ignoresSafeArea())
            .refreshable {
                await viewModel.loadNews()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

struct NewsArticleCard: View {
    let article: NewsArticle
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let imageURL = article.imageURL {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                } placeholder: {
                    Rectangle()
                        .fill(BoxWallColors.textSecondary.opacity(0.1))
                        .overlay {
                            Image(systemName: "newspaper.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(BoxWallColors.textSecondary.opacity(0.3))
                        }
                        .frame(height: 200)
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text(article.title)
                    .font(BoxWallTypography.headline)
                    .foregroundColor(BoxWallColors.textPrimary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                Text(article.formattedDate)
                    .font(BoxWallTypography.caption)
                    .foregroundColor(BoxWallColors.textSecondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(BoxWallColors.textSecondary.opacity(0.1))
                    .clipShape(Capsule())
            }
            .padding(16)
        }
        .background(colorScheme == .dark ? Color.black : .white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: BoxWallColors.textPrimary.opacity(isHovered ? 0.1 : 0.05), 
                radius: isHovered ? 15 : 10, 
                x: 0, 
                y: isHovered ? 8 : 5)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(BoxWallColors.textSecondary.opacity(0.1), lineWidth: 1)
        )
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            
            Text("Loading latest news...")
                .font(BoxWallTypography.subheadline)
                .foregroundColor(BoxWallColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }
}

struct ErrorView: View {
    let error: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(BoxWallTypography.icon(size: 32))
                .foregroundColor(BoxWallColors.warning)
            
            Text(error)
                .font(BoxWallTypography.body)
                .foregroundColor(BoxWallColors.textSecondary)
                .multilineTextAlignment(.center)
            
            Button(action: retryAction) {
                Label("Try Again", systemImage: "arrow.clockwise")
                    .font(BoxWallTypography.subheadline)
                    .foregroundColor(BoxWallColors.primary)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(BoxWallColors.primary.opacity(0.1))
                    .clipShape(Capsule())
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity)
        .background(BoxWallColors.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(BoxWallColors.textSecondary.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

#Preview {
    NewsView()
} 