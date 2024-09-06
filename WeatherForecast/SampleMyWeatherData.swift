//
//  SampleMyWeatherData.swift
//  WeatherForecast
//
//  Created by Oliver Blass on 29.08.24.
//

import Foundation

class SampleMyWeatherData {
    
    func getSampleData() -> [MyWeatherData]? {
        let hourlyTemp: [Float] = [20.1, 24.1, 23.5, 29.3, 29, 28, 28, 28, 29, 32, 33, 34, 33, 30, 30, 32, 29, 27, 26, 25, 25, 24, 23,20]
        return [
            MyWeatherData(isDay: true, windDirection: "SE", latitude: 0.0, longitude: 0.0, apparentTemperature: 23.4, surfacePressure: 1021, dailyWeatherCode: 0, hourlyTemp: hourlyTemp),
            MyWeatherData(windDirection: "SSE", latitude: 123, longitude: -23, apparentTemperature: 32, surfacePressure: 989, dailyWeatherCode: 2, hourlyTemp: hourlyTemp),
            MyWeatherData(isDay: true, windDirection: "NE", latitude: 123, longitude: -23, apparentTemperature: 34, surfacePressure: 999, dailyWeatherCode: 3, hourlyTemp: hourlyTemp),
            MyWeatherData(windDirection: "NE", latitude: 123, longitude: -23, apparentTemperature: 34, surfacePressure: 999, dailyWeatherCode: 45, hourlyTemp: hourlyTemp),
            MyWeatherData(windDirection: "NE", latitude: 123, longitude: -23, apparentTemperature: 34, surfacePressure: 999, dailyWeatherCode: 61, hourlyTemp: hourlyTemp),
            MyWeatherData(windDirection: "NE", latitude: 123, longitude: -23, apparentTemperature: 34, surfacePressure: 999, dailyWeatherCode: 85, hourlyTemp: hourlyTemp),
            MyWeatherData(isDay: true, windDirection: "NE", latitude: 123, longitude: -23, apparentTemperature: 34, surfacePressure: 999, dailyWeatherCode: 96, hourlyTemp: hourlyTemp),
        ]
    }
}
