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
        Task.init {
            locationManager.checkLocationAuthorization()
            if(locationManager.manager.authorizationStatus == CLAuthorizationStatus.authorizedAlways || locationManager.manager.authorizationStatus == CLAuthorizationStatus.authorizedWhenInUse) {
                data  = await WeatherService().callWeatherService(location: locationManager.lastKnownLocation?.coordinate)
                locationManager.lookUpCurrentLocation { place in
                        self.placeName = (place?.locality ?? "") + ", " + (place?.administrativeArea ?? "")
                }
            } else {
                data  = await WeatherService().callWeatherService(location: CLLocationCoordinate2D(latitude: 37.3230, longitude: 122.0322))
                self.placeName = ("Cupertino, CA")
            }
        }
    }

}
