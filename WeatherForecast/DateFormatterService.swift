//
//  DateFormatters.swift
//  WeatherForecast
//
//  Created by Oliver Blass on 12.09.24.
//

import Foundation

struct DateFormatterService {
    let dayAbbrDateFormatter: DateFormatter
    let hhmmDateFormatter: DateFormatter
    
    init() {
        self.dayAbbrDateFormatter = DateFormatter()
        self.dayAbbrDateFormatter.dateFormat = "EE"
        
        self.hhmmDateFormatter = DateFormatter()
        self.hhmmDateFormatter.dateFormat = "HH:mm"
    }
}
