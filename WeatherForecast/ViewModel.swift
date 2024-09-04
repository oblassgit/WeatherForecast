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
    
    
    func refreshData() {
        Task.init {
            var locationManager = LocationManager()
            locationManager.checkLocationAuthorization()
            data  = await WeatherService().callWeatherService(location: locationManager.lastKnownLocation)
            if(locationManager.manager.authorizationStatus == CLAuthorizationStatus.notDetermined) {
                data  = await WeatherService().callWeatherService(location: locationManager.lastKnownLocation)
            }
            /*
            if let _ = data?[0].temp {
                data![0].temp! += Float.random(in: 5...10)
            }
             */
        }
    }
}
