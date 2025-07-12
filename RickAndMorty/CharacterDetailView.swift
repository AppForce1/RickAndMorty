import SwiftUI

struct CharacterDetailView: View {
    let characterId: Int
    
    @State private var character: Character?
    @State private var isLoading = false
    @State private var error: Error?
    @State private var exportMessage: String?
    @State private var showingExportMessage = false
    @State private var exportedFileURL: URL?
    
    private let characterService = CharacterService()
    
    var body: some View {
        ScrollView {
            if let character {
                VStack(spacing: 16) {
                    // Character Image
                    AsyncImage(url: character.imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(.secondary.opacity(0.2))
                            .overlay {
                                ProgressView()
                            }
                    }
                    .frame(height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 8)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Name and Status
                        HStack {
                            Text(character.name)
                                .font(.title)
                                .bold()
                            Spacer()
                            Image(systemName: character.statusIcon)
                                .foregroundStyle(character.statusColor)
                        }
                        
                        // Status and Species
                        HStack {
                            Label(character.status, systemImage: character.statusIcon)
                                .foregroundStyle(character.statusColor)
                            Text("•")
                                .foregroundStyle(.secondary)
                            Text(character.species)
                        }
                        .font(.headline)
                        
                        // Type (if present)
                        if !character.type.isEmpty {
                            CharacterInfoRow(title: "Type", value: character.type)
                        }
                        
                        // Gender
                        CharacterInfoRow(title: "Gender", value: character.gender)
                        
                        // Origin
                        CharacterInfoRow(title: "Origin", value: character.origin.name)
                        
                        // Current Location
                        CharacterInfoRow(title: "Location", value: character.location.name)
                        
                        // Episode Count
                        CharacterInfoRow(title: "Appears in", value: "\(character.episodeCount) episodes")
                        
                        // Export and Share Buttons
                        HStack {
                            Button(action: exportCharacter) {
                                Label("Export", systemImage: "square.and.arrow.down")
                            }
                            .buttonStyle(.bordered)
                            
                            if let exportedFileURL {
                                ShareLink(item: exportedFileURL) {
                                    Label("Share", systemImage: "square.and.arrow.up")
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        .padding(.top)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            } else if isLoading {
                VStack(spacing: 12) {
                    ProgressView()
                    Text("Loading character #\(characterId)...")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            } else if let error {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.secondary)
                    
                    Text("Failed to Load")
                        .font(.headline)
                    
                    Text(error.localizedDescription)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Button("Try Again") {
                        Task {
                            await loadCharacter()
                        }
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Character #\(characterId)")
        .refreshable {
            await loadCharacter()
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    Task {
                        await loadCharacter()
                    }
                } label: {
                    Label("Refresh", systemImage: "arrow.clockwise")
                        .symbolEffect(.bounce, isActive: isLoading)
                }
                .disabled(isLoading)
            }
        }
        .task {
            print("Loading character #\(characterId)")
            await loadCharacter()
        }
        .alert("Export Result", isPresented: $showingExportMessage) {
            Button("OK") { }
        } message: {
            if let exportMessage {
                Text(exportMessage)
            }
        }
    }
    
    private func loadCharacter() async {
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        
        do {
            print("Refreshing character #\(characterId)")
            character = try await characterService.fetchCharacter(id: characterId)
            print("Successfully refreshed character: \(character?.name ?? "unknown")")
        } catch {
            print("Failed to refresh character #\(characterId): \(error)")
            self.error = error
        }
        
        isLoading = false
    }
    
    private func exportCharacter() {
        guard let character = character else { return }
        
        do {
            let fileURL = try CharacterExporter.exportToCSV(character)
            exportedFileURL = fileURL
            exportMessage = "Character details exported successfully.\nTap the Share button to send the file."
            showingExportMessage = true
        } catch {
            exportMessage = "Failed to export character details: \(error.localizedDescription)"
            showingExportMessage = true
        }
    }
}

struct CharacterInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
            Text(value)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        CharacterDetailView(characterId: 1)
    }
} 