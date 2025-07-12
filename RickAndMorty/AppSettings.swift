import Foundation
import SwiftData

@Model
final class AppSettings {
    var lastRefreshDate: Date?
    
    init(lastRefreshDate: Date? = nil) {
        self.lastRefreshDate = lastRefreshDate
    }
    
    static func formatLastRefresh(_ date: Date?) -> String {
        guard let date else { return "Never" }
        
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: .now)
    }
} 