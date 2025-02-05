import SwiftUI

/// A generic horizontal scrolling carousel component
struct CarouselView<Content: View, Item: Identifiable>: View {
    /// Items to display in the carousel
    let items: [Item]
    /// Width of each item relative to screen width (0.0 to 1.0)
    let itemWidth: CGFloat
    /// Height of each item
    let itemHeight: CGFloat
    /// Spacing between items
    let spacing: CGFloat
    /// Content builder for each item
    let content: (Item) -> Content
    @State private var currentIndex: Int = 0
    @State private var offset: CGFloat = 0
    @State private var scrollViewWidth: CGFloat = 0
    
    /// Creates a new carousel view
    /// - Parameters:
    ///   - items: Array of items to display
    ///   - itemWidth: Width of each item relative to screen width (default: 0.85)
    ///   - itemHeight: Height of each item
    ///   - spacing: Spacing between items (default: DesignSystem.Layout.spacing)
    ///   - content: Content builder for each item
    init(
        items: [Item],
        itemWidth: CGFloat = 0.85,
        itemHeight: CGFloat,
        spacing: CGFloat = DesignSystem.Layout.spacing,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self.itemWidth = itemWidth
        self.itemHeight = itemHeight
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        VStack(spacing: DesignSystem.Layout.spacing) {
            GeometryReader { geometry in
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: spacing) {
                            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                                content(item)
                                    .frame(
                                        width: UIScreen.main.bounds.width * itemWidth,
                                        height: itemHeight
                                    )
                                    .id(index)
                            }
                        }
                        .padding(.horizontal, DesignSystem.Layout.paddingMedium)
                        .background(
                            GeometryReader { proxy in
                                Color.clear.preference(
                                    key: ScrollOffsetPreferenceKey.self,
                                    value: proxy.frame(in: .named("scroll")).minX
                                )
                            }
                        )
                    }
                    .coordinateSpace(name: "scroll")
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        let screenWidth = UIScreen.main.bounds.width
                        let itemTotalWidth = screenWidth * itemWidth + spacing
                        let estimatedIndex = -Int((value - DesignSystem.Layout.paddingMedium) / itemTotalWidth)
                        
                        if estimatedIndex != currentIndex {
                            currentIndex = max(0, min(estimatedIndex, items.count - 1))
                        }
                    }
                    .onAppear {
                        scrollViewWidth = geometry.size.width
                    }
                    .simultaneousGesture(
                        DragGesture()
                            .onEnded { value in
                                let screenWidth = UIScreen.main.bounds.width
                                let itemTotalWidth = screenWidth * itemWidth + spacing
                                let predictedOffset = value.predictedEndLocation.x - value.location.x
                                
                                if abs(predictedOffset) > itemTotalWidth / 3 {
                                    let newIndex = predictedOffset < 0 
                                        ? min(currentIndex + 1, items.count - 1)
                                        : max(currentIndex - 1, 0)
                                    
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        proxy.scrollTo(newIndex, anchor: .center)
                                        currentIndex = newIndex
                                    }
                                } else {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        proxy.scrollTo(currentIndex, anchor: .center)
                                    }
                                }
                            }
                    )
                }
            }
            .frame(height: itemHeight)
            
            // Page Indicators
            HStack(spacing: 8) {
                ForEach(0..<items.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex 
                            ? BoxWallColors.primary 
                            : BoxWallColors.textSecondary.opacity(0.3))
                        .frame(width: 6, height: 6)
                }
            }
            .padding(.top, 4)
        }
    }
}

// MARK: - Convenience Extensions
extension CarouselView {
    /// Creates a carousel with page indicators
    /// - Parameters:
    ///   - currentIndex: Binding to track current page
    ///   - showIndicators: Whether to show page indicators
    func withPageIndicators(
        currentIndex: Binding<Int>,
        showIndicators: Bool = true
    ) -> some View {
        VStack(spacing: DesignSystem.Layout.spacing) {
            self
            
            if showIndicators {
                // Page Indicators
                HStack(spacing: DesignSystem.Layout.spacing) {
                    ForEach(0..<items.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentIndex.wrappedValue 
                                ? BoxWallColors.primary 
                                : BoxWallColors.textSecondary.opacity(0.3))
                            .frame(width: 6, height: 6)
                    }
                }
                .padding(.horizontal, DesignSystem.Layout.paddingMedium)
            }
        }
    }
}

// MARK: - Dashboard Specific Extension
extension CarouselView where Item == MenuCardItem, Content == DashboardCard {
    /// Creates a carousel specifically for dashboard cards
    /// - Parameters:
    ///   - items: Array of menu items
    ///   - onItemSelected: Action to perform when an item is selected
    static func dashboard(
        items: [MenuCardItem],
        onItemSelected: @escaping (MenuCardItem) -> Void
    ) -> CarouselView {
        CarouselView(
            items: items,
            itemWidth: 0.80,
            itemHeight: 180,
            spacing: 16
        ) { item in
            DashboardCard(
                menuItem: item,
                action: { onItemSelected(item) }
            )
        }
    }
}

// MARK: - Preview
#Preview {
    // Example of dashboard carousel
    CarouselView.dashboard(
        items: MenuCardItem.samples,
        onItemSelected: { _ in }
    )
}

#Preview {
    // Example of generic carousel
    CarouselView(
        items: [1, 2, 3, 4, 5].map { Item(id: $0) },
        itemHeight: 200
    ) { item in
        RoundedRectangle(cornerRadius: DesignSystem.Layout.cornerRadius)
            .fill(BoxWallColors.primary)
            .overlay(Text("\(item.id)").foregroundColor(.white))
    }
}

// Helper for preview
private struct Item: Identifiable {
    let id: Int
} 