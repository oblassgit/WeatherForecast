//
//  WeatherForecastApp.swift
//  WeatherForecast
//
//  Created by Oliver Blass on 07.08.24.
//

import SwiftUI
import SwiftData

@main
struct WeatherForecastApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CityResult.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ViewModel())
        }
        .modelContainer(sharedModelContainer)
    }
}
