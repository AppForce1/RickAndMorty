//
//  Item.swift
//  RickAndMorty
//
//  Created by Jeroen Leenarts on 10/07/2025.
//

import Foundation
import SwiftData

@Model
final class Episode {
    // MARK: - Properties
    var id: Int
    var name: String
    var airDate: String
    var episodeCode: String  // Format: S01E01
    var url: URL
    var created: Date
    var characterURLs: [URL]
    
    var characterIds: [Int] {
        characterURLs.compactMap { url -> Int? in
            guard let lastComponent = url.pathComponents.last,
                  let id = Int(lastComponent) else {
                print("Failed to extract ID from URL: \(url)")
                return nil
            }
            return id
        }
    }
    
    // Computed properties
    var seasonNumber: Int {
        guard let seasonStr = episodeCode.split(separator: "E").first,
              let season = Int(seasonStr.dropFirst()) else { return 0 }
        return season
    }
    
    var episodeNumber: Int {
        guard let episodeStr = episodeCode.split(separator: "E").last,
              let episode = Int(episodeStr) else { return 0 }
        return episode
    }
    
    var formattedAirDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        // First try to parse the original air date
        if let date = dateFormatter.date(from: airDate) {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: date)
        }
        
        // If that fails, try other common formats
        dateFormatter.dateFormat = "MMMM d, yyyy"
        if let date = dateFormatter.date(from: airDate) {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: date)
        }
        
        // If all parsing fails, return the original string
        return airDate
    }
    
    // MARK: - Initialization
    init(id: Int, name: String, airDate: String, episodeCode: String, url: URL, created: Date, characterURLs: [URL]) {
        self.id = id
        self.name = name
        self.airDate = airDate
        self.episodeCode = episodeCode
        self.url = url
        self.created = created
        self.characterURLs = characterURLs
    }
    
    // Convenience initializer for preview data
    static func preview() -> Episode {
        Episode(
            id: 1,
            name: "Pilot",
            airDate: "December 2, 2013",
            episodeCode: "S01E01",
            url: URL(string: "https://rickandmortyapi.com/api/episode/1")!,
            created: Date(timeIntervalSince1970: 1591797822),
            characterURLs: [
                URL(string: "https://rickandmortyapi.com/api/character/1")!,
                URL(string: "https://rickandmortyapi.com/api/character/2")!
            ]
        )
    }
}

// MARK: - Identifiable
extension Episode: Identifiable { }

// MARK: - Comparable
extension Episode: Comparable {
    static func < (lhs: Episode, rhs: Episode) -> Bool {
        if lhs.seasonNumber == rhs.seasonNumber {
            return lhs.episodeNumber < rhs.episodeNumber
        }
        return lhs.seasonNumber < rhs.seasonNumber
    }
}
