//
//  WeatherData.swift
//  WeatherForecast
//
//  Created by Oliver Blass on 08.08.24.
//

import Foundation

struct DailyWeatherData {
    let daily: Daily?
    
    struct Daily {
        let time: [Date]
        let temperature2mMax: [Float]
        let temperature2mMin: [Float]
        let rainSum: [Float]
        let uvIndexMax: [Float]
    }
}
