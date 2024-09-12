//
//  WeatherChartView.swift
//  WeatherForecast
//
//  Created by Oliver Blass on 06.09.24.
//

import SwiftUI
import Charts
import Foundation

struct HourlyData : Identifiable {
    var id = UUID()
    
    var date: Date
    var temperature: Double
    var systemName: String
    var colorArray: [Color]
    
    
    init(date: Date, temperature: Double, systemName: String, colorArray: [Color]) {
        self.date = date
        self.temperature = temperature
        self.systemName = systemName
        self.colorArray = colorArray
    }
}

struct WeatherChartView: View {
    let temperatureArray: [Float]
    let weatherCodeArray: [Int]
    let isDayArray: [Bool]?
    let startDate: Date
    let currentDate: Date
    let currentTemp: Double
    @State private var chartSelection: Date?
    @State private var chartYSelection: Double?
    
    var weatherIconService = WeatherIconService()
    
    
    
    var data: [HourlyData] {
        var array: [HourlyData] = []
        var i = 0
        var isDay: Bool?
        
    
        temperatureArray.forEach { temperature in
            isDay = isDayArray?[i] ?? true
            let systemName = weatherIconService.getWeatherIconSystemName(wmoCode: String(weatherCodeArray[i]), isDay: isDay ?? false)
            let colorArray = weatherIconService.decideWeathericonColorArray(systemName: systemName)
            array.append(HourlyData(date: (startDate.addingTimeInterval(TimeInterval(i * 60 * 60))), temperature: Double(temperature), systemName: systemName, colorArray: colorArray))
            
            
            i += 1
            
        }
        
        return array
    }
    
    
    var body: some View {
        
        VStack(alignment: .leading, content: {
            HStack {
                Image(systemName: "thermometer")
                    .font(.subheadline)
                Text("temperature throughout the day")
                    .font(.subheadline.smallCaps())
            }.foregroundStyle(Color.secondary)
            Divider()
            
            if (chartSelection == nil) {
                Text("\(Int(currentTemp.rounded())) °C")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            } else {
                Text(" ")
                    .font(.title)
            }
            
            
            Chart (data) {
                if let chartSelection {
                    RuleMark(x: .value("Time", chartSelection))
                        .annotation(
                            position: .top,
                            overflowResolution: .init(x: .fit, y: .disabled)
                        ) {
                            HStack {
                                VStack {
                                    
                                    Text("\(Int(getTemp(for: chartSelection).rounded())) °C").padding(.horizontal)
                                    
                                    Text("\(formatDateToTimeStamp(date: chartSelection))").padding(.horizontal)
                                    
                                    
                                    
                                }
                                let colorArray = getColorArray(for: chartSelection)
                                Image(systemName: getSystemName(for: chartSelection)).font(.title).foregroundStyle(colorArray[0], colorArray[1], colorArray[2])
                                
                                
                            }
                            
                            
                            
                        }
                        .foregroundStyle(.secondary)
                        .foregroundStyle(Color.gray.opacity(0.1))


                
                    
                }

                
                
                
                
                AreaMark(x: .value("Time", $0.date), y: .value("Temperature", $0.temperature))
                    .interpolationMethod(.cardinal)
                    .foregroundStyle(Gradient(colors: [Color.yellow.opacity(0.5), Color.green.opacity(0.3), Color.blue.opacity(0.2)]))
                
                LineMark(x: .value("Time", $0.date), y: .value("Temperature", $0.temperature))
                    .interpolationMethod(.cardinal)
                    .lineStyle(StrokeStyle(lineWidth: 5))
                    .foregroundStyle(Gradient(colors: [Color.yellow, Color.green, Color.blue]))
                
                
                
                
                
                
            }
            .chartXSelection(value: $chartSelection)
            
            
            
        })
        .frame(minHeight: 50, maxHeight: 350)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .opacity(0.25)
                .shadow(radius: 10)
        }
    }
    
    func getTemp(for date: Date) -> Double {
        return data.first(where: { Calendar.current.isDate($0.date, equalTo: date, toGranularity: .hour) })?.temperature ?? 0.0
    }
    
    func getSystemName(for date: Date) -> String {
        let systemName = data.first(where: { Calendar.current.isDate($0.date, equalTo: date, toGranularity: .hour) })?.systemName ?? ""
        return systemName
    }
    
    func getColorArray(for date: Date) -> [Color] {
        return data.first(where: { Calendar.current.isDate($0.date, equalTo: date, toGranularity: .hour) })?.colorArray ?? [Color.white, Color.white, Color.white]
    }
}

private func formatDateToTimeStamp(date: Date) -> String {
    return DateFormatterService().hhmmDateFormatter.string(from: date)
}





#Preview {
    WeatherChartView(temperatureArray: [20.1, 24.1, 23.5, 29.3, 30, 28, 28, 28, 29, 32, 33, 34, 33, 30, 30, 32, 29, 27, 26, 25, 25, 24, 23,20, 19], weatherCodeArray: [0,1,1,1,2,1,1,1,1,3,1,1,0,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1], isDayArray: [true, false,false, false,false, false,true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false], startDate: Calendar.current.startOfDay(for: .now), currentDate: .now, currentTemp: 25.3)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)
    
}
