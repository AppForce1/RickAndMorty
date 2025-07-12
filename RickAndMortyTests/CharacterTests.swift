import XCTest
import SwiftUI

@testable import RickAndMorty

final class CharacterTests: XCTestCase {
    let sampleCharacterData: [String: Any] = [
        "id": 1,
        "name": "Rick Sanchez",
        "status": "Alive",
        "species": "Human",
        "type": "Genius",
        "gender": "Male",
        "origin": ["name": "Earth", "url": "https://rickandmortyapi.com/api/location/1"],
        "location": ["name": "Earth", "url": "https://rickandmortyapi.com/api/location/20"],
        "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
        "episode": [
            "https://rickandmortyapi.com/api/episode/1",
            "https://rickandmortyapi.com/api/episode/2"
        ],
        "url": "https://rickandmortyapi.com/api/character/1",
        "created": "2017-11-04T18:48:46.250Z"
    ]
    
    func testCharacterDecoding() throws {
        let jsonData = try JSONSerialization.data(withJSONObject: sampleCharacterData)
        let character = try JSONDecoder().decode(Character.self, from: jsonData)
        
        XCTAssertEqual(character.id, 1)
        XCTAssertEqual(character.name, "Rick Sanchez")
        XCTAssertEqual(character.status, "Alive")
        XCTAssertEqual(character.species, "Human")
        XCTAssertEqual(character.type, "Genius")
        XCTAssertEqual(character.gender, "Male")
        XCTAssertEqual(character.origin.name, "Earth")
        XCTAssertEqual(character.location.name, "Earth")
        XCTAssertEqual(character.episodeCount, 2)
    }
    
    func testStatusIcon() {
        let aliveCharacter = makeCharacter(status: "Alive")
        let deadCharacter = makeCharacter(status: "Dead")
        let unknownCharacter = makeCharacter(status: "unknown")
        
        XCTAssertEqual(aliveCharacter.statusIcon, "circle.fill")
        XCTAssertEqual(deadCharacter.statusIcon, "xmark.circle.fill")
        XCTAssertEqual(unknownCharacter.statusIcon, "questionmark.circle.fill")
    }
    
    func testStatusColor() {
        let aliveCharacter = makeCharacter(status: "Alive")
        let deadCharacter = makeCharacter(status: "Dead")
        let unknownCharacter = makeCharacter(status: "unknown")
        
        XCTAssertEqual(aliveCharacter.statusColor, .green)
        XCTAssertEqual(deadCharacter.statusColor, .red)
        XCTAssertEqual(unknownCharacter.statusColor, .gray)
    }
    
    func testImageURL() {
        let character = makeCharacter(imageURL: "https://example.com/image.jpg")
        XCTAssertEqual(character.imageURL?.absoluteString, "https://example.com/image.jpg")
        
        let invalidCharacter = makeCharacter(imageURL: "invalid-url")
        XCTAssertNil(invalidCharacter.imageURL)
    }
    
    // MARK: - Helper Methods
    
    private func makeCharacter(
        status: String = "Alive",
        imageURL: String = "https://example.com/image.jpg"
    ) -> Character {
        Character(
            id: 1,
            name: "Test Character",
            status: status,
            species: "Human",
            type: "",
            gender: "Male",
            origin: Location(name: "Earth", url: "https://example.com"),
            location: Location(name: "Earth", url: "https://example.com"),
            image: imageURL,
            episode: ["https://example.com/1"],
            url: "https://example.com",
            created: "2023-01-01T00:00:00.000Z"
        )
    }
} 
