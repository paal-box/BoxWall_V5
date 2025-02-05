import Foundation
import SwiftUI

struct SupportingDocument: Identifiable {
    let id = UUID()
    let name: String
    let url: URL
    let size: Int64
    let type: DocumentType
    
    enum DocumentType: String {
        case pdf = "PDF"
        case image = "Image"
        case dwg = "DWG"
        case other = "Other"
        
        var icon: String {
            switch self {
            case .pdf: return "doc.fill"
            case .image: return "photo.fill"
            case .dwg: return "ruler.fill"
            case .other: return "doc.fill"
            }
        }
    }
} 