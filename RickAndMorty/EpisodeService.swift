import Foundation
import SwiftData

struct EpisodeResponse: Codable {
    let info: PageInfo
    let results: [EpisodeDTO]
}

struct PageInfo: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct EpisodeDTO: Codable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, url, created, characters
        case airDate = "air_date"
        case episode
    }
}

actor EpisodeService {
    private let baseURL = URL(string: "https://rickandmortyapi.com/api/episode")!
    private let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
    
    func fetchEpisodes() async throws -> [Episode] {
        print("Starting episode fetch from \(baseURL)")
        var allEpisodes: [Episode] = []
        var nextPageURL: URL? = baseURL
        var pageCount = 0
        
        while let url = nextPageURL {
            pageCount += 1
            print("Fetching page \(pageCount) from \(url)")
            
            let (data, urlResponse) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            guard httpResponse.statusCode == 200 else {
                print("Server returned status code: \(httpResponse.statusCode)")
                if let errorMessage = String(data: data, encoding: .utf8) {
                    print("Server response: \(errorMessage)")
                }
                throw URLError(.badServerResponse)
            }
            
            let episodeResponse = try JSONDecoder().decode(EpisodeResponse.self, from: data)
            print("Received \(episodeResponse.results.count) episodes in page \(pageCount)")
            
            let episodes = episodeResponse.results.map { dto -> Episode in
                let episode = Episode(
                    id: dto.id,
                    name: dto.name,
                    airDate: dto.airDate,
                    episodeCode: dto.episode,
                    url: URL(string: dto.url)!,
                    created: dateFormatter.date(from: dto.created) ?? Date(),
                    characterURLs: dto.characters.compactMap { URL(string: $0) }
                )
                print("Created episode: \(episode.name) (\(episode.episodeCode))")
                return episode
            }
            
            allEpisodes.append(contentsOf: episodes)
            nextPageURL = episodeResponse.info.next.flatMap { URL(string: $0) }
            
            print("Total episodes fetched so far: \(allEpisodes.count)")
        }
        
        print("Completed fetching all episodes. Total count: \(allEpisodes.count)")
        return allEpisodes
    }
} 
