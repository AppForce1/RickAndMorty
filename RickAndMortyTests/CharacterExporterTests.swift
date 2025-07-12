import XCTest
@testable import RickAndMorty

final class CharacterExporterTests: XCTestCase {
    func testExportToCSV() throws {
        // Create a test character
        let character = Character(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: "Genius",
            gender: "Male",
            origin: Location(name: "Earth", url: "https://example.com"),
            location: Location(name: "Earth", url: "https://example.com"),
            image: "https://example.com/image.jpg",
            episode: ["https://example.com/1", "https://example.com/2"],
            url: "https://example.com",
            created: "2023-01-01T00:00:00.000Z"
        )
        
        // Export the character
        let fileURL = try CharacterExporter.exportToCSV(character)
        
        // Read the exported file
        let csvContent = try String(contentsOf: fileURL, encoding: .utf8)
        let lines = csvContent.components(separatedBy: .newlines)
        
        // Verify header
        XCTAssertEqual(lines[0], "Name,Status,Species,Origin,Episode Count")
        
        // Verify content
        let expectedContent = "Rick Sanchez,Alive,Human,Earth,2"
        XCTAssertEqual(lines[1], expectedContent)
        
        // Verify file name format
        XCTAssertTrue(fileURL.lastPathComponent.hasPrefix("character_1_Rick_Sanchez"))
        XCTAssertTrue(fileURL.lastPathComponent.hasSuffix(".csv"))
        
        // Clean up
        try FileManager.default.removeItem(at: fileURL)
    }
    
    func testExportWithSpecialCharacters() throws {
        // Create a character with special characters in the name
        let character = Character(
            id: 2,
            name: "Mr. Poopybutthole, Jr.",
            status: "Alive",
            species: "Poopybutthole",
            type: "",
            gender: "Male",
            origin: Location(name: "unknown", url: ""),
            location: Location(name: "Earth, C-137", url: ""),
            image: "https://example.com/image.jpg",
            episode: ["https://example.com/1"],
            url: "https://example.com",
            created: "2023-01-01T00:00:00.000Z"
        )
        
        // Export the character
        let fileURL = try CharacterExporter.exportToCSV(character)
        
        // Read the exported file
        let csvContent = try String(contentsOf: fileURL, encoding: .utf8)
        let lines = csvContent.components(separatedBy: .newlines)
        
        // Verify content with special characters
        let expectedContent = "Mr. Poopybutthole, Jr.,Alive,Poopybutthole,unknown,1"
        XCTAssertEqual(lines[1], expectedContent)
        
        // Verify filename handling of special characters
        XCTAssertTrue(fileURL.lastPathComponent.contains("Mr_Poopybutthole_Jr"))
        
        // Clean up
        try FileManager.default.removeItem(at: fileURL)
    }
    
    func testExportToNonexistentDirectory() {
        // This test verifies that the exporter creates the necessary directories
        let character = Character(
            id: 3,
            name: "Test Character",
            status: "unknown",
            species: "unknown",
            type: "",
            gender: "unknown",
            origin: Location(name: "unknown", url: ""),
            location: Location(name: "unknown", url: ""),
            image: "https://example.com/image.jpg",
            episode: [],
            url: "https://example.com",
            created: "2023-01-01T00:00:00.000Z"
        )
        
        XCTAssertNoThrow(try CharacterExporter.exportToCSV(character))
    }
} 