import SwiftUI
import SwiftSoup

@MainActor
final class NewsViewModel: ObservableObject {
    @Published var articles: [NewsArticle] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = "https://boxwall.no/blogg"
    private let imageBaseURL = "https://static.wixstatic.com/media"
    private let networkTimeout: TimeInterval = 30
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd. MMM. yyyy"
        formatter.locale = Locale(identifier: "nb_NO")
        return formatter
    }()
    
    private var currentTask: Task<Void, Never>?
    
    init() {
        Task {
            await loadNews()
        }
    }
    
    func loadNews() async {
        // Cancel any existing task
        currentTask?.cancel()
        
        // Create new task
        currentTask = Task {
            if isLoading { return }
            
            isLoading = true
            errorMessage = nil
            
            do {
                guard let url = URL(string: baseURL) else {
                    throw URLError(.badURL)
                }
                
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.timeoutInterval = networkTimeout
                request.cachePolicy = .reloadIgnoringLocalCacheData
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    break // Success
                case 404:
                    throw URLError(.resourceUnavailable)
                case 500...599:
                    throw URLError(.badServerResponse)
                default:
                    throw URLError(.badServerResponse)
                }
                
                let htmlString = String(data: data, encoding: .utf8) ?? ""
                let doc = try SwiftSoup.parse(htmlString)
                
                let blogPosts = try doc.select("article")
                print("Debug - Found \(blogPosts.size()) articles")
                
                var newsArticles: [NewsArticle] = []
                
                for (index, post) in blogPosts.array().enumerated() {
                    if Task.isCancelled { break }
                    
                    do {
                        let title = try post.select("h2").first()?.text() ?? ""
                        let subtitle = try post.select(".post-excerpt").first()?.text()
                        let content = try post.select(".post-content").first()?.text() ?? ""
                        let dateStr = try post.select(".post-metadata__date").first()?.text() ?? ""
                        
                        var postURL = try post.select("a.blog-link-hover-color").first()?.attr("href")
                        if postURL == nil || postURL?.isEmpty == true {
                            postURL = try post.select("a[href*=/post/]").first()?.attr("href")
                        }
                        
                        guard let finalPostURL = postURL, !finalPostURL.isEmpty,
                              let url = URL(string: finalPostURL) else {
                            print("Debug - Skipping article: Invalid or missing post URL")
                            continue
                        }
                        
                        var imageURL: String? = nil
                        if let wowImage = try post.select("wow-image").first(),
                           let imageInfo = try? wowImage.attr("data-image-info") {
                            if let data = imageInfo.data(using: .utf8),
                               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                               let imageData = json["imageData"] as? [String: Any],
                               let uri = imageData["uri"] as? String {
                                imageURL = "\(imageBaseURL)/\(uri)"
                            }
                        }
                        
                        let article = NewsArticle(
                            title: title,
                            subtitle: subtitle,
                            content: content,
                            imageURL: imageURL.flatMap { URL(string: $0) },
                            date: dateFormatter.date(from: dateStr) ?? Date(),
                            webURL: url
                        )
                        
                        newsArticles.append(article)
                    } catch {
                        print("Error parsing article \(index + 1): \(error)")
                        continue
                    }
                }
                
                if Task.isCancelled { return }
                
                if newsArticles.isEmpty {
                    articles = NewsArticle.samples
                    errorMessage = "Could not load latest news. Showing sample data."
                } else {
                    articles = newsArticles.sorted(by: { $0.date > $1.date })
                }
                
            } catch URLError.timedOut {
                if !Task.isCancelled {
                    articles = NewsArticle.samples
                    errorMessage = "Connection timed out. Showing sample data."
                }
            } catch URLError.notConnectedToInternet {
                if !Task.isCancelled {
                    articles = NewsArticle.samples
                    errorMessage = "No internet connection. Showing sample data."
                }
            } catch {
                if !Task.isCancelled {
                    print("Error loading news: \(error)")
                    articles = NewsArticle.samples
                    errorMessage = "Failed to load news. Showing sample data."
                }
            }
            
            if !Task.isCancelled {
                isLoading = false
            }
        }
    }
    
    func openArticle(_ article: NewsArticle) {
        guard let url = URL(string: article.webURL.absoluteString) else { return }
        UIApplication.shared.open(url)
    }
    
    deinit {
        currentTask?.cancel()
    }
} 