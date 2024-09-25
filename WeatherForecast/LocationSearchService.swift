//
//  LocalSearchService.swift
//  WeatherForecast
//
//  Created by Oliver Blass on 25.09.24.
//

import Foundation
import Combine
import MapKit


extension Array {
    func unique<T:Hashable>(by: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(by(value)) {
                set.insert(by(value))
                arrayOrdered.append(value)
            }
        }

        return arrayOrdered
    }
}

class LocationSearchService: NSObject, ObservableObject {
    
    enum LocationStatus: Equatable {
        case idle
        case noResults
        case isSearching
        case error(String)
        case result
    }
    
    @Published var queryFragment: String = ""
    @Published private(set) var status: LocationStatus = .idle
    @Published private(set) var searchResults: [CityResult] = []
    
    private var queryCancellable: AnyCancellable?
    private let searchCompleter: MKLocalSearchCompleter!
    var tmpSearchResults: [CityResult] = []

    init(searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()) {
        self.searchCompleter = searchCompleter
        super.init()
        self.searchCompleter.delegate = self
        self.searchCompleter.resultTypes = MKLocalSearchCompleter.ResultType([.address])
        
        queryCancellable = $queryFragment
            .receive(on: DispatchQueue.main)
        // we're debouncing the search, because the search completer is rate limited.
        // feel free to play with the proper value here
            .debounce(for: .milliseconds(250), scheduler: RunLoop.main, options: nil)
            .sink(receiveValue: { fragment in
                self.status = .isSearching
                if !fragment.isEmpty && self.queryFragment.count >= 3 {
                    self.searchCompleter.queryFragment = fragment
                } else {
                    self.tmpSearchResults = []
                    self.status = .idle
                    self.searchResults = []
                }
            })
    }
    
    func getLocations(result: MKLocalSearchCompletion, completion: @escaping ([CityResult]) -> Void)
    {
        /*let request = MKLocalSearch.Request(completion: result)
         let search = MKLocalSearch(request: request)
         search.start
         {
         (response, error) in
         guard let response = response else { /* error! */ }
         
         for item in response.mapItems
         {
         if let location = item.placemark.location
         {
         // You have your location
         }
         }
         }*/
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        
        let request = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: request)
        
        search.start { (response, error) in
            defer {
                dispatchGroup.leave()
            }
            
            guard let response = response else { return }
            
            for item in response.mapItems {
                if let location = item.placemark.location {
                    
                    let city = item.placemark.locality ?? ""
                    var country = item.placemark.country ?? ""
                    if country.isEmpty {
                        country = item.placemark.countryCode ?? ""
                    }
                    
                    if !city.isEmpty {
                        let cityResult = CityResult(city: city, country: country, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                        self.tmpSearchResults.append(cityResult)
                    }
                }
            }
        }
        
        
        dispatchGroup.notify(queue: .main) {
            let tmpResults = self.tmpSearchResults.filter { $0.city.lowercased().contains(self.queryFragment.lowercased()) == true}            
            completion(tmpResults.unique{$0.city})
        }
        
    }
    
}

extension LocationSearchService: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        debugPrint("Result changed!")
        // Depending on what you're searching, you might need to filter differently or
        // remove the filter altogether. Filtering for an empty Subtitle seems to filter
        // out a lot of places and only shows cities and countries.
        //self.searchResults = completer.results //.filter({ $0.subtitle == "" })
        completer.results.forEach { result in
            getLocations(result: result) { cityResults in
                DispatchQueue.main.async {
                    self.searchResults = cityResults
                }
                
            }
        }
        debugPrint(searchResults.count)

        
        self.status = completer.results.isEmpty ? .noResults : .result
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        self.status = .error(error.localizedDescription)
    }
}

struct CityResult: Hashable {
        var city: String
        var country: String
        var latitude: Double
        var longitude: Double
    }
