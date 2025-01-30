// Filename: wix-news-function.js
import wixData from 'wix-data';

export async function get_news(request) {
    try {
        // Query the Wix Blog collection
        const posts = await wixData.query("Blog/Posts")
            .limit(10)  // Get latest 10 posts
            .descending("publishedDate")
            .find();
        
        // Transform posts to match our app's data structure
        const items = posts.items.map(post => ({
            title: post.title,
            description: post.excerpt || post.content.slice(0, 200) + "...",
            publishedDate: post.publishedDate,
            author: post.owner?.name || "BoxWall Team",
            coverImage: post.coverImage?.url,
            slug: post.slug
        }));
        
        return {
            body: {
                items: items
            },
            headers: {
                "Content-Type": "application/json"
            }
        };
    } catch (error) {
        console.error("Error fetching news:", error);
        return {
            body: {
                items: []
            },
            headers: {
                "Content-Type": "application/json"
            }
        };
    }
} 