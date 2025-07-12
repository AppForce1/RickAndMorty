import Foundation

actor CharacterService {
    private let baseURL = URL(string: "https://rickandmortyapi.com/api/character")!
    
    func fetchCharacter(id: Int) async throws -> Character {
        let url = baseURL.appendingPathComponent(String(id))
        print("Fetching character from URL: \(url)")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard httpResponse.statusCode == 200 else {
            print("Server returned status code: \(httpResponse.statusCode)")
            if let errorMessage = String(data: data, encoding: .utf8) {
                print("Server response: \(errorMessage)")
            }
            throw URLError(.badServerResponse)
        }
        
        do {
            let character = try JSONDecoder().decode(Character.self, from: data)
            print("Successfully decoded character: \(character.name)")
            return character
        } catch {
            print("Failed to decode character: \(error)")
            throw error
        }
    }
} 