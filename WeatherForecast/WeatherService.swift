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
    var isRainy: Bool?
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
    
    
    
    public func callWeatherService(location: CLLocationCoordinate2D?) async -> [MyWeatherData] {
        
        /*let locationManager = LocationManager()
        locationManager.checkLocationAuthorization()
        let latitude = locationManager.lastKnownLocation?.latitude ?? 0.0
        let longitude = locationManager.lastKnownLocation?.longitude ?? 0.0*/
        
        let latitude = location?.latitude ?? 0.0
        let longitude = location?.longitude ?? 0.0
        
        
        
        /// Make sure the URL contains `&format=flatbuffers`
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current=is_day,temperature_2m,apparent_temperature,surface_pressure,weather_code&hourly=visibility,wind_speed_10m,wind_direction_10m&daily=temperature_2m_max,temperature_2m_min,uv_index_max,rain_sum,weather_code&timezone=Europe%2FBerlin&format=flatbuffers")!
        
        
        var data = WeatherData(daily: nil, hourly: nil, current: .init(isDay: 0, temperature2m: 0.0, apparentTemperature: 0.0, suracePressure: 0.0, weatherCode: -1))
        var allData : [MyWeatherData] = []
        
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
                    weatherCode: daily.variables(at: 4)!.values
                ),
                hourly: .init(
                    visibility: hourly.variables(at: 0)!.values,
                    windSpeed: hourly.variables(at: 1)!.values,
                    windDirection: hourly.variables(at: 2)!.values
                ),
                current: .init(
                        isDay: current.variables(at: 0)!.value,
                        temperature2m: current.variables(at: 1)!.value,
                        apparentTemperature: current.variables(at: 2)!.value,
                        suracePressure: current.variables(at: 3)!.value,
                        weatherCode: current.variables(at: 4)!.value
                    )
            )
                        
            /// Timezone `.gmt` is deliberately used.
            /// By adding `utcOffsetSeconds` before, local-time is inferred
            let dateFormatter = DateFormatter()
            
            
            dateFormatter.dateFormat = "EE"
            if let dailies = data.daily {
                if let current = data.current {
                    if let hourly = data.hourly {
                        var rainy = false
                        var isDay = false
                        for (i, date) in dailies.time.enumerated() {
                            // print("\(dateFormatter.string(from: date)) \(dailies.rainSum[i])")

                            if(Float(dailies.rainSum[i]) > Float(8.0)) {
                                rainy = true
                            } else {
                                rainy = false
                            }
                            
                            if(Float(current.isDay) != 0) {
                                isDay = true
                            } else {
                                isDay = false
                            }

                            
                            allData.append(MyWeatherData(
                                dateObj: date,
                                date: dateFormatter.string(from: date),
                                minTemp: dailies.temperature2mMin[i],
                                maxTemp: dailies.temperature2mMax[i],
                                isRainy: rainy,
                                maxUVIndex: Double(dailies.uvIndexMax[i]),
                                isDay: isDay,
                                temp: current.temperature2m,
                                visibility: hourly.visibility[0],
                                windSpeed: hourly.windSpeed[0],
                                windDirection: String(describing: Direction(hourly.windDirection[0])),
                                latitude: latitude,
                                longitude: longitude,
                                apparentTemperature: current.apparentTemperature,
                                surfacePressure: current.suracePressure,
                                dailyWeatherCode: Int(dailies.weatherCode[i]),
                                currentWeatherCode: Int(current.weatherCode)
                                
                                
                            ))
                            
                            // print(dailies.uvIndexMax[i])
                            
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
