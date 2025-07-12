import Foundation

struct CharacterExporter {
    static func exportToCSV(_ character: Character) throws -> URL {
        // Create CSV header and content
        let header = "Name,Status,Species,Origin,Episode Count\n"
        let content = "\(character.name),\(character.status),\(character.species),\(character.origin.name),\(character.episodeCount)\n"
        let csvString = header + content
        
        // Get documents directory
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = "character_\(character.id)_\(character.name.replacingOccurrences(of: " ", with: "_")).csv"
        let fileURL = documentsPath.appendingPathComponent(fileName)
        
        // Write to file
        try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
        
        return fileURL
    }
} 