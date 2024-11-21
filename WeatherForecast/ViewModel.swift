//
//  ViewModel.swift
//  WeatherForecast
//
//  Created by Oliver Blass on 03.09.24.
//

import Foundation
import CoreLocation

class ViewModel: ObservableObject {
    @Published var data: [MyWeatherData]?
    @Published var placeName: String?
    var shouldUseLocationManager: Bool = true
    private var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.3230, longitude: -122.0322)
    
    private var locationManager = LocationManager()
    
    
    func refreshData() {
        locationManager.checkLocationAuthorization()

        if shouldUseLocationManager {
            if(locationManager.manager.authorizationStatus == CLAuthorizationStatus.authorizedAlways || locationManager.manager.authorizationStatus == CLAuthorizationStatus.authorizedWhenInUse) {
                locationManager.lookUpCurrentLocation { place in
                    if place != nil {
                        self.placeName = (place?.locality ?? "")
                    }
                    if place == nil && self.placeName == nil {
                        self.placeName = "Cupertino"
                    }
                    self.fetchData(place: place?.location?.coordinate)
                }
            } else {
                self.placeName = "Cupertino"
                self.fetchData(place: CLLocationCoordinate2D(latitude: 37.3230, longitude: -122.0322))
            }
            debugPrint("placeName: " + (self.placeName ?? "No placename found"))
        }
        
        
    }
    
    func fetchData(place: CLLocationCoordinate2D?) {
        Task.init {
            let data = await WeatherService().callWeatherService(location: place)
            if !data.isEmpty {
                self.data = data
            }
        }
    }
    
    func setLocation(newLocation: CLLocationCoordinate2D?, placeName: String) {
        if let newLocation = newLocation {
            shouldUseLocationManager = false
            location = newLocation
            fetchData(place: location)
            self.placeName = placeName
        } else {
            shouldUseLocationManager = true
            refreshData()
        }
    }
    
    
    
}
