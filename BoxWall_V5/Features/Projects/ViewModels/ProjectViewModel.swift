import Foundation

@MainActor
class ProjectViewModel: ObservableObject {
    @Published private(set) var projects: [Project] = []
    
    init() {
        #if DEBUG
        loadSampleData()
        #endif
    }
    
    private func loadSampleData() {
        projects = [
            Project(
                name: "Cissi Klein School",
                description: """
                Customer: Trøndelag Fylkeskommune
                Location: Trondheim, Norway
                Specifications:
                • 289 Modules
                • Material: Pine
                • Dimensions: 340cm x 60cm
                • Sound Class: 50dB
                """,
                type: "Education",
                location: "Trondheim",
                floor: "Floor 2",
                soundproofing: true,
                status: .inProgress,
                deliveryStatus: .installing
            ),
            Project(
                name: "Medical Center",
                description: "Soundproof walls for examination rooms",
                type: "Healthcare",
                location: "Oslo",
                floor: "Floor 3",
                soundproofing: true,
                status: .submitted
            )
        ]
    }
    
    func addProject(_ project: Project) {
        projects.append(project)
        objectWillChange.send()
    }
    
    func updateProjectStatus(_ project: Project, status: ProjectStatus) {
        guard let index = projects.firstIndex(where: { $0.id == project.id }) else { return }
        var updatedProject = project
        updatedProject.status = status
        projects[index] = updatedProject
        objectWillChange.send()
    }
} 