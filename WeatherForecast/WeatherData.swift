//
//  WeatherData.swift
//  WeatherForecast
//
//  Created by Oliver Blass on 08.08.24.
//

import Foundation

struct WeatherData {
    let daily: Daily?
    let hourly: Hourly?
    let current: Current?

    struct Current {
        let isDay: Float
        let temperature2m: Float
        let apparentTemperature: Float
        let suracePressure: Float
        let weatherCode: Float
        let visibility: Float
        let windSpeed: Float
        let windDirection: Float
    }
    struct Hourly {
    
        
    }
    struct Daily {
        let time: [Date]
        let temperature2mMax: [Float]
        let temperature2mMin: [Float]
        let rainSum: [Float]
        let uvIndexMax: [Float]
        let weatherCode: [Float]
        let sunrise: [Int64]
        let sunset: [Int64]
    }
}
