import Foundation

struct Project: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let type: String?
    let location: String?
    let floor: String?
    var soundproofing: Bool
    var status: ProjectStatus
    var deliveryStatus: DeliveryStatus
    var attachments: [ProjectAttachment]
    let createdAt: Date
    
    init(
        name: String,
        description: String,
        type: String? = nil,
        location: String? = nil,
        floor: String? = nil,
        soundproofing: Bool = false,
        status: ProjectStatus = .draft,
        deliveryStatus: DeliveryStatus = .pending,
        attachments: [ProjectAttachment] = [],
        createdAt: Date = Date()
    ) {
        self.name = name
        self.description = description
        self.type = type
        self.location = location
        self.floor = floor
        self.soundproofing = soundproofing
        self.status = status
        self.deliveryStatus = deliveryStatus
        self.attachments = attachments
        self.createdAt = createdAt
    }
}

enum ProjectStatus: String {
    case draft = "Draft"
    case submitted = "Submitted"
    case inProgress = "In Progress"
    case completed = "Completed"
}

enum DeliveryStatus: String {
    case pending = "Pending"
    case preparing = "Preparing"
    case installing = "Installing"
    case completed = "Completed"
}

struct ProjectAttachment: Identifiable {
    let id = UUID()
    let name: String
    let type: AttachmentType
    let url: URL
    
    enum AttachmentType: String {
        case pdf = "PDF"
        case dwg = "DWG"
    }
} 