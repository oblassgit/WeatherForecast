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
    
    private var locationManager = LocationManager()
    
    
    func refreshData() {
        locationManager.checkLocationAuthorization()

        if(locationManager.manager.authorizationStatus == CLAuthorizationStatus.authorizedAlways || locationManager.manager.authorizationStatus == CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.lookUpCurrentLocation { place in
                if place != nil {
                    self.placeName = (place?.locality ?? "") + ", " + (place?.administrativeArea ?? "")
                }
                if place == nil && self.placeName == nil {
                    self.placeName = "Cupertino, CA"
                }
                self.fetchData(place: place?.location?.coordinate)
            }
        } else {
            self.placeName = "Cupertino, CA"
            self.fetchData(place: CLLocationCoordinate2D(latitude: 37.3230, longitude: 122.0322))
        }
        debugPrint("placeName: " + (self.placeName ?? "No placename found"))
        
    }
    
    func fetchData(place: CLLocationCoordinate2D?) {
        Task.init {
            locationManager.checkLocationAuthorization()
            let data = await WeatherService().callWeatherService(location: place)
            if !data.isEmpty {
                self.data = data
            }
        }
    }
    
    
    
}
