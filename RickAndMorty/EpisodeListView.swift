//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Jeroen Leenarts on 10/07/2025.
//

import SwiftUI
import SwiftData

struct EpisodeListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Episode.episodeCode) private var episodes: [Episode]
    @Query private var settings: [AppSettings]
    
    @State private var isLoading = false
    @State private var error: Error?
    @State private var selectedEpisode: Episode?
    
    private let episodeService = EpisodeService()
    
    var lastRefreshDate: Date? {
        settings.first?.lastRefreshDate
    }
    
    var body: some View {
        NavigationStack {
            List {
                if let lastRefreshDate {
                    Section {
                        Text("Last updated \(AppSettings.formatLastRefresh(lastRefreshDate))")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Section {
                    if episodes.isEmpty && !isLoading {
                        ContentUnavailableView {
                            Label("No Episodes", systemImage: "tv")
                        } description: {
                            Text("Pull to refresh or tap the refresh button to load episodes")
                        }
                    } else {
                        ForEach(episodes) { episode in
                            NavigationLink {
                                EpisodeDetailView(episode: episode)
                            } label: {
                                EpisodeRowView(episode: episode)
                            }
                        }
                    }
                }
                
                if !episodes.isEmpty {
                    Section {
                        HStack {
                            Spacer()
                            VStack(spacing: 4) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                Text("You're All Caught Up!")
                                    .font(.callout)
                                    .bold()
                                Text("\(episodes.count) episodes total")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                        .listRowBackground(Color.clear)
                    }
                }
            }
            .overlay {
                if isLoading {
                    VStack {
                        ProgressView("Loading episodes...")
                        if !episodes.isEmpty {
                            Text("Updating \(episodes.count) episodes")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.background.opacity(0.8))
                }
            }
            .navigationTitle("Rick and Morty Episodes")
            .toolbar {
                ToolbarItem {
                    Button(action: { 
                        print("Refresh button tapped")
                        Task { 
                            await refreshEpisodes() 
                        }
                    }) {
                        Label("Refresh", systemImage: "arrow.clockwise")
                            .symbolEffect(.bounce, isActive: isLoading)
                    }
                    .disabled(isLoading)
                }
            }
            .refreshable {
                print("Manual refresh triggered")
                await refreshEpisodes()
            }
            .alert("Error Loading Episodes", isPresented: .constant(error != nil)) {
                Button("OK") { error = nil }
                Button("Try Again") {
                    Task {
                        await refreshEpisodes()
                    }
                }
            } message: {
                Text(error?.localizedDescription ?? "")
            }
        }
        .task {
            print("View appeared, episodes count: \(episodes.count)")
            if episodes.isEmpty {
                print("No episodes found, triggering initial load")
                await refreshEpisodes()
            } else {
                print("Found \(episodes.count) existing episodes")
            }
        }
    }
    
    private func refreshEpisodes() async {
        guard !isLoading else {
            print("Refresh already in progress, skipping")
            return
        }
        
        print("Starting episode refresh...")
        isLoading = true
        error = nil
        
        do {
            print("Fetching episodes from API...")
            let newEpisodes = try await episodeService.fetchEpisodes()
            print("Fetched \(newEpisodes.count) episodes")
            
            // Delete existing episodes
            print("Deleting existing episodes...")
            try modelContext.delete(model: Episode.self)
            
            // Insert new episodes
            print("Inserting new episodes...")
            newEpisodes.forEach { episode in
                modelContext.insert(episode)
                print("Inserted episode: \(episode.name) (\(episode.episodeCode))")
            }
            
            // Update last refresh time
            print("Updating last refresh time...")
            if let settings = settings.first {
                settings.lastRefreshDate = .now
            } else {
                modelContext.insert(AppSettings(lastRefreshDate: .now))
            }
            
            print("Saving changes...")
            try modelContext.save()
            print("Refresh completed successfully")
        } catch {
            print("Error during refresh: \(error)")
            self.error = error
        }
        
        isLoading = false
    }
}

struct EpisodeRowView: View {
    let episode: Episode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(episode.name)
                .font(.headline)
            
            HStack(spacing: 8) {
                Text(episode.episodeCode)
                    .font(.subheadline.monospaced())
                    .padding(4)
                    .background(.secondary.opacity(0.2))
                    .cornerRadius(4)
                
                Text(episode.formattedAirDate)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct EpisodeDetailView: View {
    let episode: Episode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Group {
                    Text(episode.name)
                        .font(.title)
                        .bold()
                    
                    HStack {
                        Label("Season \(episode.seasonNumber)", systemImage: "tv")
                        Spacer()
                        Label("Episode \(episode.episodeNumber)", systemImage: "play.circle")
                    }
                    .foregroundStyle(.secondary)
                    
                    Text("Air Date")
                        .font(.headline)
                    Text(episode.airDate)
                        .foregroundStyle(.secondary)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Characters")
                            .font(.headline)
                        
                        CharacterGrid(characterIds: episode.characterIds)
                        
                        Text("\(episode.characterIds.count) characters total")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Link(destination: episode.url) {
                        Label("View on Rick and Morty API", systemImage: "link")
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CharacterGrid: View {
    let characterIds: [Int]
    let columns = [
        GridItem(.adaptive(minimum: 60, maximum: 80), spacing: 8)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(characterIds, id: \.self) { id in
                NavigationLink(destination: CharacterDetailView(characterId: id)) {
                    Text("\(id)")
                        .font(.callout.monospaced())
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(.secondary.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    NavigationStack {
        EpisodeListView()
            .modelContainer(for: Episode.self, inMemory: true)
    }
}
