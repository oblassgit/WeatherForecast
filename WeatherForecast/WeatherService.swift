//
//  WeatherService.swift
//  WeatherForecast
//
//  Created by Oliver Blass on 08.08.24.
//

import OpenMeteoSdk
import Foundation
import CoreLocation

struct MyWeatherData {
    var dateObj: Date?
    var date: String?
    var minTemp: Float?
    var maxTemp: Float?
    var maxUVIndex: Double?
    var isDay: Bool?
    var temp: Float?
    var visibility: Float?
    var windSpeed: Float?
    var windDirection: String = ""
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    var apparentTemperature: Float = 0.0
    var surfacePressure: Float = 0.0
    var dailyWeatherCode: Int?
    var currentWeatherCode: Int?
    var sunriseTime: String?
    var sunsetTime: String?
    var hourlyTemp: [Float]
    var hourlyWeatherCode: [Int]
    var isDayHourly: [Bool]
    var uvIndex: Float?
    var hourlyPrecipitation: [Float]
    var precipitation: Float?
}

enum Direction: String, CaseIterable {
    case n, nne, ne, ene, e, ese, se, sse, s, ssw, sw, wsw, w, wnw, nw, nnw
}

extension Direction: CustomStringConvertible  {
    init<D: BinaryFloatingPoint>(_ direction: D) {
        self =  Self.allCases[Int((direction.angle+11.25).truncatingRemainder(dividingBy: 360)/22.5)]
    }
    var description: String { rawValue.uppercased() }
}

extension BinaryFloatingPoint {
    var angle: Self {
        (truncatingRemainder(dividingBy: 360) + 360)
            .truncatingRemainder(dividingBy: 360)
    }
    var direction: Direction { .init(self) }
}

class WeatherService {
    
    private var allData : [MyWeatherData] = []
    private var data = WeatherData(daily: nil, hourly: nil, current: .init(isDay: 0, temperature2m: 0.0, apparentTemperature: 0.0, suracePressure: 0.0, weatherCode: -1, visibility: 0.0, windSpeed: 0.0, windDirection: 0.0, uvIndex: 0.0, precipitation: 0.0))


    public func callWeatherService(location: CLLocationCoordinate2D?) async -> [MyWeatherData] {

        
        let latitude = location?.latitude ?? 0.0
        let longitude = location?.longitude ?? 0.0
        
        
        
        /// Make sure the URL contains `&format=flatbuffers`
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current=is_day,temperature_2m,apparent_temperature,surface_pressure,weather_code,visibility,wind_speed_10m,wind_direction_10m,uv_index,precipitation&hourly=temperature_2m,weather_code,is_day,precipitation&daily=temperature_2m_max,temperature_2m_min,uv_index_max,rain_sum,weather_code,sunrise,sunset&timezone=auto&format=flatbuffers")!
        
        
        
        do {
            let responses = try await WeatherApiResponse.fetch(url: url)
            
            
            /// Process first location. Add a for-loop for multiple locations or weather models
            let response = responses[0]
            
            /// Attributes for timezone and location
            let utcOffsetSeconds = response.utcOffsetSeconds
            let timezone = response.timezone
            let timezoneAbbreviation = response.timezoneAbbreviation
            let latitude = response.latitude
            let longitude = response.longitude
            
            let daily = response.daily!
            let hourly = response.hourly!
            let current = response.current!
            
            
            /// Note: The order of weather variables in the URL query and the `at` indices below need to match!
            data = WeatherData(
                daily: .init(
                    time: daily.getDateTime(offset: utcOffsetSeconds),
                    temperature2mMax: daily.variables(at: 0)!.values,
                    temperature2mMin: daily.variables(at: 1)!.values,
                    rainSum: daily.variables(at: 3)!.values,
                    uvIndexMax: daily.variables(at: 2)!.values,
                    weatherCode: daily.variables(at: 4)!.values,
                    sunrise: daily.variables(at: 5)!.valuesInt64,
                    sunset: daily.variables(at: 6)!.valuesInt64
                ),
                hourly: .init(
                    temperature2m: hourly.variables(at: 0)!.values,
                    weatherCode: hourly.variables(at: 1)!.values.compactMap {flt in Int(flt)},
                    isDay: hourly.variables(at: 2)!.values,
                    precipitation: hourly.variables(at: 3)!.values
                ),
                current: .init(
                        isDay: current.variables(at: 0)!.value,
                        temperature2m: current.variables(at: 1)!.value,
                        apparentTemperature: current.variables(at: 2)!.value,
                        suracePressure: current.variables(at: 3)!.value,
                        weatherCode: current.variables(at: 4)!.value,
                        visibility: current.variables(at: 5)!.value,
                        windSpeed: current.variables(at: 6)!.value,
                        windDirection: current.variables(at: 7)!.value,
                        uvIndex: current.variables(at: 8)!.value,
                        precipitation: current.variables(at: 9)!.value
                    )
            )
                        
            
            if let dailies = data.daily {
                if let current = data.current {
                    if let hourly = data.hourly {
                        var isDay = false
                        var isDayHourly: [Bool] = []
                                                
                        var localToSystemTimeOffset: Int {
                            
                            return Int(utcOffsetSeconds) - TimeZone.current.secondsFromGMT()
                            
                        }
                        
                        for (i, date) in dailies.time.enumerated() {
                            
                            if(Float(current.isDay) != 0) {
                                isDay = true
                            } else {
                                isDay = false
                            }
                            
                            hourly.isDay.forEach { isDay in
                                if(isDay == 1.0) {
                                    isDayHourly.append(true)
                                } else {
                                    isDayHourly.append(false)
                                }
                                
                            }
                            
                            allData.append(MyWeatherData(
                                dateObj: .now,
                                date: DateFormatterService().dayAbbrDateFormatter.string(from: date),
                                minTemp: dailies.temperature2mMin[i],
                                maxTemp: dailies.temperature2mMax[i],
                                maxUVIndex: Double(dailies.uvIndexMax[i]),
                                isDay: isDay,
                                temp: current.temperature2m,
                                visibility: current.visibility,
                                windSpeed: current.windSpeed,
                                windDirection: String(describing: Direction(current.windDirection)),
                                latitude: latitude,
                                longitude: longitude,
                                apparentTemperature: current.apparentTemperature,
                                surfacePressure: current.suracePressure,
                                dailyWeatherCode: Int(dailies.weatherCode[i]),
                                currentWeatherCode: Int(current.weatherCode),
                                sunriseTime: DateFormatterService().hhmmDateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(integerLiteral: dailies.sunrise[i] + Int64(localToSystemTimeOffset)))),
                                sunsetTime: DateFormatterService().hhmmDateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(integerLiteral: dailies.sunset[i]  + Int64(localToSystemTimeOffset)))),
                                hourlyTemp: hourly.temperature2m,
                                hourlyWeatherCode: hourly.weatherCode,
                                isDayHourly: isDayHourly,
                                uvIndex: current.uvIndex,
                                hourlyPrecipitation: hourly.precipitation,
                                precipitation: current.precipitation
                            ))
                        }
                        
                    }
                }
            }
            
            
        } catch {
            print(error.localizedDescription)
        }
        
        return allData
        
    }
}
