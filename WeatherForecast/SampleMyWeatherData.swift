//
//  SampleMyWeatherData.swift
//  WeatherForecast
//
//  Created by Oliver Blass on 29.08.24.
//

import Foundation

class SampleMyWeatherData {
    
    func getSampleData() -> [MyWeatherData]? {
        return [
            MyWeatherData(windDirection: "SE", latitude: 0.0, longitude: 0.0, apparentTemperature: 23.4, surfacePressure: 1021),
            MyWeatherData(windDirection: "SSE", latitude: 123, longitude: -23, apparentTemperature: 32, surfacePressure: 989),
            MyWeatherData(windDirection: "NE", latitude: 123, longitude: -23, apparentTemperature: 34, surfacePressure: 999),
            MyWeatherData(windDirection: "NE", latitude: 123, longitude: -23, apparentTemperature: 34, surfacePressure: 999),
            MyWeatherData(windDirection: "NE", latitude: 123, longitude: -23, apparentTemperature: 34, surfacePressure: 999),
            MyWeatherData(windDirection: "NE", latitude: 123, longitude: -23, apparentTemperature: 34, surfacePressure: 999),
            MyWeatherData(windDirection: "NE", latitude: 123, longitude: -23, apparentTemperature: 34, surfacePressure: 999),
        ]
    }
}
