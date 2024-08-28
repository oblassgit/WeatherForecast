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
    
    @State var data: [MyWeatherData]?
    
    
    
    var body: some View {
                
        ScrollView(.vertical, showsIndicators: false) {
            VStack(){
                let isDayTime = data?[0].isDay ?? false
                let todayIsRainy = data?[0].isRainy ?? false
                
                
                HStack {
                    Image(systemName: "location.fill")
                    Text("lat. \(String(format: "%.2f", data?[0].latitude ?? 0.0)) long. \(String(format: "%.2f", data?[0].longitude ?? 0.0))")
                }
                Text(" \(Int(data?[0].temp ?? 0.0))°")
                    .font(Font.system(size: 60))
                    .padding(1)
                Image(systemName: decideWeatherIconSystemName(isDay: isDayTime, isRainy: todayIsRainy, day: "Today"))
                    .foregroundStyle(decideWeatherIconColor(isDay: isDayTime, isRainy: todayIsRainy, day: "Today"))
                    .font(Font.largeTitle)
                    .padding(1)
                Text("High \(Int(data?[0].maxTemp ?? 0.0))°")
                Text("Low \(Int(data?[0].minTemp ?? 0.0))°")
                    .foregroundStyle(Color.secondary)
                    .padding(.bottom)
                
                
                
                VStack {
                    HStack {
                        Image(systemName: "calendar")
                            .font(.subheadline)
                        Text("7-day-forecast")
                            .font(.subheadline.smallCaps())
                        Spacer()
                    }.foregroundStyle(Color.secondary)
                        .padding(.horizontal)
                        .padding(.top)

                    Divider()
                        .padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false){
                        
                        HStack{
                            if let data = data {
                                ForEach(0 ..< data.count) { value in
                                    let day = data[value]
                                    DayForecast(day: value == 0 ? "Today" : day.date ?? "??", isRainy: day.isRainy ?? false, high: Int(day.maxTemp ?? 0), low: Int(day.minTemp ?? 0), isDay: day.isDay ?? false)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    
                }
                .frame(minHeight: 125)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                        .opacity(0.25)
                        .shadow(radius: 10)
                }
                .padding(.horizontal)
                
            }
            
            HStack {
                GlassyCardView(viewDescription: "visibility", iconName: "eye.fill", smallIconName: "", bigText: "\(Int(data?[0].visibility ?? 1) / 1000) km", smallText: "", showSmall: true, unit: "")
                    .padding(.leading)
                
                GlassyCardView(viewDescription: "wind", iconName: "wind", smallIconName: "safari", bigText: "\(Int(data?[0].windSpeed ?? 0)) km/h", smallText: String(data?[0].windDirection ?? "??"), showSmall: true, unit: "")
                    .padding(.trailing)
            }
            
            
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

struct DayForecast: View {
    let day: String
    let isRainy: Bool
    let high: Int
    let low: Int
    let isDay: Bool
    
    
    var body: some View {
        VStack {
            Text(day)
                .font(Font.headline)
            
            Image(systemName: decideWeatherIconSystemName(isDay: isDay, isRainy: isRainy, day: day))
                .foregroundStyle(decideWeatherIconColor(isDay: isDay, isRainy: isRainy, day: day))
                .font(Font.largeTitle)
                .padding(5)
            Text("High: \(high)°")
            Text("Low \(low)°")
                .foregroundStyle(Color.secondary)
        }
        .padding()
    }

}

func decideWeatherIconColor(isDay: Bool, isRainy: Bool, day: String) -> Color {
    if !isDay && day.elementsEqual("Today") {
        return Color.white
    }
    if isRainy {
        return Color.blue
    } else {
        return Color.yellow
    }
}

func decideWeatherIconSystemName(isDay: Bool, isRainy: Bool, day: String) -> String {
    if !isDay && isRainy && day.elementsEqual("Today") {
        return "cloud.moon.rain.fill"
    }
    if !isDay && !isRainy && day.elementsEqual("Today") {
        return "moon.stars.fill"
    }
    if isRainy {
        return "cloud.rain.fill"
    } else {
        return "sun.max.fill"
    }
}

func decideUVIndexDescription(uvIndex: Int) -> String {
    if((0...2).contains(uvIndex)) {
        return "Low"
    }
    if((3...5).contains(uvIndex)) {
        return "Medium"
    }
    if((6...7).contains(uvIndex)) {
        return "High"
    }
    if((8...10).contains(uvIndex)) {
        return "Very High"
    }
    if(uvIndex > 10) {
        return "Extreme"
    } else {
        return "We're so dead"
    }
}


