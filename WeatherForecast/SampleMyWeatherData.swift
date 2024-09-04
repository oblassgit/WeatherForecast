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
            MyWeatherData(windDirection: "SE", latitude: 0.0, longitude: 0.0, apparentTemperature: 23.4, surfacePressure: 1021, dailyWeatherCode: 0),
            MyWeatherData(windDirection: "SSE", latitude: 123, longitude: -23, apparentTemperature: 32, surfacePressure: 989, dailyWeatherCode: 2),
            MyWeatherData(windDirection: "NE", latitude: 123, longitude: -23, apparentTemperature: 34, surfacePressure: 999, dailyWeatherCode: 3),
            MyWeatherData(windDirection: "NE", latitude: 123, longitude: -23, apparentTemperature: 34, surfacePressure: 999, dailyWeatherCode: 45),
            MyWeatherData(windDirection: "NE", latitude: 123, longitude: -23, apparentTemperature: 34, surfacePressure: 999, dailyWeatherCode: 61),
            MyWeatherData(windDirection: "NE", latitude: 123, longitude: -23, apparentTemperature: 34, surfacePressure: 999, dailyWeatherCode: 85),
            MyWeatherData(windDirection: "NE", latitude: 123, longitude: -23, apparentTemperature: 34, surfacePressure: 999, dailyWeatherCode: 96),
        ]
    }
}
