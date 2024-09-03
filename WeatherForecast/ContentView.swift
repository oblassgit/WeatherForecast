//
//  ContentView.swift
//  WeatherForecast
//
//  Created by Oliver Blass on 07.08.24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    var location: CLLocation?
    
    @State private var data: [MyWeatherData]?
    
    
    
    var body: some View {
                
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                let isDayTime = data?[0].isDay ?? false
                let isRainy = data?[0].isRainy ?? false
                
                
                
                TodayForecastView(data: data, isDayTime: isDayTime, isRainy: isRainy)
                SevenDayForecastView(data: data)
                
            }
            
            HStack {
                GlassyCardView(viewDescription: "visibility", iconName: "eye.fill", smallIconName: "", bigText: "\(Int(data?[0].visibility ?? 1) / 1000) km", smallText: "", showSmall: true, unit: "")
                    .padding(.leading)
                
                GlassyCardView(viewDescription: "wind", iconName: "wind", smallIconName: "safari", bigText: "\(Int(data?[0].windSpeed ?? 0)) km/h", smallText: String(data?[0].windDirection ?? "??"), showSmall: true, unit: "")
                    .padding(.trailing)
            }
            
            UvIndexView(data: data)
            

            HStack {
                GlassyCardView(viewDescription: "apparent", iconName: "thermometer.sun", smallIconName: "", bigText: "\(Int(data?[0].apparentTemperature ?? 0)) °", smallText: "", showSmall: false, unit: "")
                    .padding(.leading)
                
                GlassyCardView(viewDescription: "pressure", iconName: "gauge.with.dots.needle.bottom.50percent", smallIconName: "", bigText: " \(Int(data?[0].surfacePressure ?? 0).formatted())", smallText: "", showSmall: false, unit: "hPa")
                    .padding(.trailing)
            }
            
            Spacer()
            
            
        }
        .containerRelativeFrame([.horizontal, .vertical])
        .background(Gradient(colors: [.blue, .indigo, .cyan]).opacity(0.8))
        .onAppear(perform: {
            Task.init {
                var locationManager = LocationManager()
                locationManager.checkLocationAuthorization()
                data  = await WeatherService().callWeatherService(location: locationManager.lastKnownLocation)
                if(locationManager.manager.authorizationStatus == CLAuthorizationStatus.notDetermined) {
                    data  = await WeatherService().callWeatherService(location: locationManager.lastKnownLocation)
                }
                
            }
        })
    }
    }
    
#Preview {
    ContentView()
}

struct TodayForecastView: View {
    
    var data: [MyWeatherData]?
    var isDayTime: Bool
    var isRainy: Bool

    var body: some View {
        
        VStack {
            
            
            HStack {
                Image(systemName: "location.fill")
                Text("lat. \(String(format: "%.2f", data?[0].latitude ?? 0.0)) long. \(String(format: "%.2f", data?[0].longitude ?? 0.0))")
            }
            Text(" \(Int(data?[0].temp ?? 0.0))°")
                .font(Font.system(size: 60))
                .padding(1)
            Image(systemName: decideWeatherIconSystemName(isDay: isDayTime, isRainy: isRainy, day: "Today"))
                .foregroundStyle(decideWeatherIconColor(isDay: isDayTime, isRainy: isRainy, day: "Today"))
                .font(Font.largeTitle)
                .padding(1)
            Text("High \(Int(data?[0].maxTemp ?? 0.0))°")
            Text("Low \(Int(data?[0].minTemp ?? 0.0))°")
                .foregroundStyle(Color.secondary)
                .padding(.bottom)
            
        }
    }
}

struct UvIndexView: View {
    var data: [MyWeatherData]?
    
    var body: some View {
        VStack {
            let maxUvIndex = data?[0].maxUVIndex ?? 0.0
            
            HStack {
                Image(systemName: "sun.max.fill")
                    .font(.subheadline)
                Text("max-uv-index")
                    .font(.subheadline.smallCaps())
                Spacer()
            }.foregroundStyle(Color.secondary)
                .padding(.horizontal)
                .padding(.top)

            Divider()
                .padding(.horizontal)
            
            VStack {
                HStack {
                    Text(String(Int(maxUvIndex.rounded())))
                    Spacer()
                }
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                HStack {
                    Text(decideUVIndexDescription(uvIndex: Int(maxUvIndex.rounded())))
                        .font(.title2)
                    Spacer()
                }
            }
            .padding(.leading)
            
            Gauge(value: maxUvIndex, in: 0...12) {
            } currentValueLabel: {
                Text(String(maxUvIndex))
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {Text("12")}
                .gaugeStyle(AccessoryLinearGaugeStyle())
                .tint(Gradient(colors: [.green, .yellow, .red, .purple]))
                .padding(.horizontal)
                .padding(.bottom)
            
        }
        .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .opacity(0.25)
                    .shadow(radius: 10)
            }
        .padding(.horizontal)
    }
}


