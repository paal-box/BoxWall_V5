import Foundation

struct NewsArticle: Identifiable {
    let id = UUID()
    let title: String
    let imageURL: URL?
    let date: Date
    let webURL: URL
    
    var formattedDate: String {
        date.formatted(date: .abbreviated, time: .omitted)
    }
}

// MARK: - Sample Data
extension NewsArticle {
    static let samples = [
        NewsArticle(
            title: "BoxWall Launches New Sustainability Initiative",
            imageURL: URL(string: "https://boxwall.no/blogg/sustainability"),
            date: Date().addingTimeInterval(-86400 * 2), // 2 days ago
            webURL: URL(string: "https://boxwall.no/blogg/sustainability")!
        ),
        NewsArticle(
            title: "Introducing BoxWall Premium Series",
            imageURL: URL(string: "https://boxwall.no/blogg/premium"),
            date: Date().addingTimeInterval(-86400 * 5), // 5 days ago
            webURL: URL(string: "https://boxwall.no/blogg/premium")!
        )
    ]
} 