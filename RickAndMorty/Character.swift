import Foundation
import SwiftData
import SwiftUI

struct Character: Codable, Identifiable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Location
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    var episodeCount: Int {
        episode.count
    }
    
    var imageURL: URL? {
        URL(string: image)
    }
    
    var statusIcon: String {
        switch status.lowercased() {
        case "alive": return "circle.fill"
        case "dead": return "xmark.circle.fill"
        default: return "questionmark.circle.fill"
        }
    }
    
    var statusColor: Color {
        switch status.lowercased() {
        case "alive": return .green
        case "dead": return .red
        default: return .gray
        }
    }
}

struct Location: Codable {
    let name: String
    let url: String
} 