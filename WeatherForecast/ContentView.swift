//
//  ContentView.swift
//  WeatherForecast
//
//  Created by Oliver Blass on 07.08.24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    
    @Environment(\.scenePhase) var scenePhase
    
    @State var shouldPresentLocationSheet = false
    
    var body: some View {
        
                
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                HStack {
                    Image(systemName: "location.fill").foregroundStyle(viewModel.shouldUseLocationManager ? .blue : .primary)
                    Text(viewModel.placeName ?? "").multilineTextAlignment(.center)
                }.onTapGesture {
                    shouldPresentLocationSheet.toggle()
                }.sheet(isPresented: $shouldPresentLocationSheet, onDismiss: {
                    
                }, content: {
                    LocationView(locationSearchService: LocationSearchService(), callback: { result in
                        if let result = result {
                            viewModel.setLocation(newLocation: CLLocationCoordinate2D(latitude: result.latitude, longitude: result.longitude), placeName: result.city)
                            viewModel.refreshData()
                        } else {
                            viewModel.shouldUseLocationManager = true
                            viewModel.refreshData()
                        }
                        shouldPresentLocationSheet.toggle()
                    })
                })
                
                let isDay = viewModel.data?.first?.isDay ?? false

                
                
                TodayForecastView(viewModel: viewModel, isDayTime: isDay)
                SevenDayForecastView(data: viewModel.data)
                
            }
            
            HStack {
                GlassyCardView(viewDescription: "visibility", iconName: "eye.fill", smallIconName: "", bigText: "\(Int(viewModel.data?.first?.visibility ?? 1) / 1000) km", smallText: "", showSmall: true, unit: "")
                    .padding(.leading)
                
                GlassyCardView(viewDescription: "wind", iconName: "wind", smallIconName: "safari", bigText: "\(Int(viewModel.data?.first?.windSpeed ?? 0)) km/h", smallText: String(viewModel.data?.first?.windDirection ?? "??"), showSmall: true, unit: "")
                    .padding(.trailing)
            }
            
            UvIndexView(data: viewModel.data)
            

            HStack {
                GlassyCardView(viewDescription: "apparent", iconName: "thermometer.sun", smallIconName: "", bigText: "\(Int(viewModel.data?.first?.apparentTemperature.rounded() ?? 0)) °", smallText: "", showSmall: false, unit: "")
                    .padding(.leading)
                
                GlassyCardView(viewDescription: "pressure", iconName: "gauge.with.dots.needle.bottom.50percent", smallIconName: "", bigText: " \(Int(viewModel.data?.first?.surfacePressure ?? 0).formatted())", smallText: "", showSmall: false, unit: "hPa")
                    .padding(.trailing)
            }
            
            WeatherChartView(temperatureArray: Array(viewModel.data?.first?.hourlyTemp.prefix(25) ?? [0.0,0.0]),weatherCodeArray: viewModel.data?.first?.hourlyWeatherCode ?? [0,0],isDayArray: viewModel.data?.first?.isDayHourly, startDate: Calendar.current.startOfDay(for: .now), currentDate: .now, currentTemp: Double(viewModel.data?.first?.temp ?? 0.0))
                .frame(height: 300)
                .padding(.horizontal)
            
            HStack {
                GlassyCardView(viewDescription: "sunrise", iconName: "sunrise.fill", smallIconName: "", bigText: viewModel.data?.first?.sunriseTime ?? "00:00", smallText: "", showSmall: false, unit: "")
                    .padding(.leading)
                GlassyCardView(viewDescription: "sunset", iconName: "sunset.fill", smallIconName: "", bigText: viewModel.data?.first?.sunsetTime ?? "00:00", smallText: "", showSmall: false, unit: "")
                    .padding(.trailing)
            }
            if viewModel.data != nil {
                Text("Last updated at \(DateFormatterService().hhmmDateFormatter.string(from: viewModel.data?.first?.dateObj ?? .distantPast))")
            }
            
            Link("Weather data by Open-Meteo.com", destination: URL(string: "https://open-meteo.com")!)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            
        }
        .containerRelativeFrame([.horizontal, .vertical])
        .background(Gradient(colors: [.backgroundColor1, .backgroundColor3, .backgroundColor2]).opacity(0.8))
        
        .onAppear(perform: {
        }).onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                debugPrint("scenePhase: Active")
                viewModel.refreshData()
            } else if newPhase == .inactive {
                debugPrint("scenePhase: Inactive")
            } else if newPhase == .background {
                debugPrint("scenePhase: Background")
            }
        }
    }
    }
    
#Preview {
    ContentView(viewModel: ViewModel())
}

struct TodayForecastView: View {
    
    @ObservedObject var viewModel: ViewModel
    var isDayTime: Bool
    var weatherIconService = WeatherIconService()

    var body: some View {
        let data = viewModel.data

        
        VStack {
            
            Text(" \(Int(data?.first?.temp?.rounded() ?? 0.0))°")
                .font(Font.system(size: 60))
                .padding(1)
            
            let colorArray = weatherIconService.decideWeathericonColorArray(systemName: weatherIconService.getWeatherIconSystemName(wmoCode: String(data?.first?.currentWeatherCode ?? -1), isDay: data?.first?.isDay ?? true))
            Image(systemName: String(weatherIconService.getWeatherIconSystemName(wmoCode: String(data?.first?.currentWeatherCode ?? -1), isDay: data?.first?.isDay ?? true)))
                .symbolRenderingMode(.palette)
                .foregroundStyle(colorArray[0], colorArray[1], colorArray[2])
                .font(Font.largeTitle)
                .padding(1)
            Text(weatherIconService.getWeatherDescription(wmoCode: String(data?.first?.currentWeatherCode ?? 99), isDay: isDayTime))
                .font(.title3)
            Text("High \(Int(data?.first?.maxTemp?.rounded() ?? 0.0))°")
            Text("Low \(Int(data?.first?.minTemp?.rounded() ?? 0.0))°")
                .foregroundStyle(Color.secondary)
                .padding(.bottom)
            
        }
    }
}

struct UvIndexView: View {
    var data: [MyWeatherData]?
    
    
    var body: some View {
        
        let maxUvIndex = data?.first?.maxUVIndex ?? 0.0
        let uvIndex = data?.first?.uvIndex ?? 0.0
        VStack {
            
            
            
            
            
            HStack {
                Image(systemName: "sun.max.fill")
                    .font(.subheadline)
                Text("uv index")
                    .font(.subheadline.smallCaps())
                Spacer()
            }
            .foregroundStyle(Color.secondary)
            .padding(.top)
            .padding(.horizontal)
            
            Divider()
            
            Group {
                HStack {
                    Text(String(Int(uvIndex.rounded())))
                    Spacer()
                }
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                HStack {
                    Text(decideUVIndexDescription(uvIndex: Int(uvIndex.rounded())))
                        .font(.title2)
                    Spacer()
                }
            }.padding(.horizontal)
            
            
            
            Gauge(value: uvIndex, in: 0...12) {
            } currentValueLabel: {
                Text(String(uvIndex))
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {Text("12")}
                .gaugeStyle(AccessoryLinearGaugeStyle())
                .tint(Gradient(colors: [.green, .yellow, .red, .purple]))
                .padding(.horizontal)
            
            
            HStack {
                Text("The UV Index will reach \(Int(maxUvIndex.rounded())) today.")
                Spacer()
            }
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



