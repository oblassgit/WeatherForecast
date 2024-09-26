//
//  LocationView.swift
//  WeatherForecast
//
//  Created by Oliver Blass on 25.09.24.
//

import SwiftUI
import SwiftData

struct LocationView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @ObservedObject var locationSearchService: LocationSearchService
    
    @Query(sort: \CityResult.city) private var recentLocations: [CityResult]

    
    var callback: (CityResult?) -> Void
    
    @State private var searchText = ""
        
    var body: some View {
        VStack {
            NavigationSplitView {
                Button(action: {
                    self.callback(nil)
                }, label: {
                    HStack {
                        Image(systemName: "location.fill")
                        Text("Current Location")
                    }
                })
                if locationSearchService.searchResults.isEmpty {
                    List {
                        ForEach(recentLocations, id: \.self) { location in
                            Button(action: {
                                self.callback(location)
                                
                            }, label: { Text("\(location.city), \(location.country)")
                            })
                        }.onDelete(perform: { indexSet in
                            deleteLocation(offsets: indexSet)
                        })
                    }
                }
                
                List {
                    ForEach(locationSearchService.searchResults, id: \.self) { completionResult in
                        Button(action: {
                            self.callback(completionResult)
                            addLocation(newLocation: completionResult)
                            
                            
                        }, label: { Text("\(completionResult.city), \(completionResult.country)")
                        })
                            
                    }
                }
                .searchable(text: $locationSearchService.queryFragment)
            } detail: {
                Text("Select a place")
                    .navigationTitle("Weather")
            }
            
        }
        
        
        
        
        
        
    }
    
    private func addLocation(newLocation: CityResult) {
        var isUnique = true
        //ensures that there are no duplicates added to the recentLocations
        recentLocations.forEach { location in
            isUnique = (location.city != newLocation.city || location.country != newLocation.country) && isUnique
        }
        if isUnique {
            modelContext.insert(newLocation)
        }
        
    }
    
    private func deleteLocation(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(recentLocations[index])
        }
    }
}

#Preview {
    LocationView(locationSearchService: LocationSearchService()) { result in
        debugPrint(result)
    }
}
