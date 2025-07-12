import XCTest
@testable import RickAndMorty

final class EpisodeTests: XCTestCase {
    func testEpisodeInitialization() {
        let episode = Episode(
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
        
        XCTAssertEqual(episode.id, 1)
        XCTAssertEqual(episode.name, "Pilot")
        XCTAssertEqual(episode.airDate, "December 2, 2013")
        XCTAssertEqual(episode.episodeCode, "S01E01")
        XCTAssertEqual(episode.characterURLs.count, 2)
    }
    
    func testSeasonNumber() {
        let episode1 = makeEpisode(episodeCode: "S01E01")
        let episode2 = makeEpisode(episodeCode: "S02E05")
        let invalidEpisode = makeEpisode(episodeCode: "Invalid")
        
        XCTAssertEqual(episode1.seasonNumber, 1)
        XCTAssertEqual(episode2.seasonNumber, 2)
        XCTAssertEqual(invalidEpisode.seasonNumber, 0)
    }
    
    func testEpisodeNumber() {
        let episode1 = makeEpisode(episodeCode: "S01E01")
        let episode2 = makeEpisode(episodeCode: "S01E10")
        let invalidEpisode = makeEpisode(episodeCode: "Invalid")
        
        XCTAssertEqual(episode1.episodeNumber, 1)
        XCTAssertEqual(episode2.episodeNumber, 10)
        XCTAssertEqual(invalidEpisode.episodeNumber, 0)
    }
    
    func testCharacterIds() {
        let episode = makeEpisode(characterURLs: [
            URL(string: "https://rickandmortyapi.com/api/character/1")!,
            URL(string: "https://rickandmortyapi.com/api/character/2")!,
            URL(string: "https://rickandmortyapi.com/api/character/invalid")! // Invalid URL
        ])
        
        XCTAssertEqual(episode.characterIds, [1, 2])
        XCTAssertEqual(episode.characterIds.count, 2)
    }
    
    func testFormattedAirDate() {
        let episode1 = makeEpisode(airDate: "December 2, 2013")
        let episode2 = makeEpisode(airDate: "2013-12-02") // Different format
        let episode3 = makeEpisode(airDate: "Invalid Date")
        
        XCTAssertEqual(episode1.formattedAirDate, "02/12/2013")
        XCTAssertEqual(episode3.formattedAirDate, "Invalid Date") // Returns original if parsing fails
    }
    
    func testEpisodeComparison() {
        let episode1 = makeEpisode(episodeCode: "S01E01")
        let episode2 = makeEpisode(episodeCode: "S01E02")
        let episode3 = makeEpisode(episodeCode: "S02E01")
        
        XCTAssertLessThan(episode1, episode2) // Same season, different episode
        XCTAssertLessThan(episode2, episode3) // Different season
        XCTAssertGreaterThan(episode3, episode1) // Different season
    }
    
    // MARK: - Helper Methods
    
    private func makeEpisode(
        id: Int = 1,
        name: String = "Test Episode",
        airDate: String = "December 2, 2013",
        episodeCode: String = "S01E01",
        characterURLs: [URL] = []
    ) -> Episode {
        Episode(
            id: id,
            name: name,
            airDate: airDate,
            episodeCode: episodeCode,
            url: URL(string: "https://rickandmortyapi.com/api/episode/1")!,
            created: Date(timeIntervalSince1970: 1591797822),
            characterURLs: characterURLs
        )
    }
} 