//
//  LocationView.swift
//  WeatherForecast
//
//  Created by Oliver Blass on 25.09.24.
//

import SwiftUI

struct LocationView: View {
    
    @ObservedObject var locationSearchService: LocationSearchService
    
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
                
                List {
                    ForEach(locationSearchService.searchResults, id: \.self) { completionResult in
                        //Text(completionResult.city)
                        Button(action: {
                            self.callback(completionResult)
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
}

#Preview {
    LocationView(locationSearchService: LocationSearchService()) { result in
        debugPrint(result)
    }
}
