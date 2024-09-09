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
            data  = await WeatherService().callWeatherService(location: locationManager.lastKnownLocation?.coordinate)
            if(locationManager.manager.authorizationStatus == CLAuthorizationStatus.notDetermined) {
                data  = await WeatherService().callWeatherService(location: locationManager.lastKnownLocation?.coordinate)
            }
            
            locationManager.lookUpCurrentLocation { place in
                self.placeName = (place?.locality ?? "") + ", " + (place?.administrativeArea ?? "")
            }
            
            let item = getItemFromJson(fileName: "BetterWmoCodes", id: "0")
        }
    }

}
