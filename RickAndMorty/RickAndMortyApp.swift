//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Jeroen Leenarts on 10/07/2025.
//

import SwiftUI
import SwiftData

@main
struct RickAndMortyApp: App {
    let container: ModelContainer
    
    init() {
        print("Initializing app...")
        do {
            let schema = Schema([
                Episode.self,
                AppSettings.self
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            print("Creating ModelContainer with schema...")
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            print("ModelContainer created successfully")
        } catch {
            print("Failed to initialize ModelContainer: \(error)")
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                EpisodeListView()
            }
        }
        .modelContainer(container)
    }
}
