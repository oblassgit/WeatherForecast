//
//  WeatherChartView.swift
//  WeatherForecast
//
//  Created by Oliver Blass on 06.09.24.
//

import SwiftUI
import Charts
import Foundation

struct HourlyTemperature : Identifiable {
    var id = UUID()
    
    var date: Date
    var temperature: Double
    
    
    
    
    init(date: Date, temperature: Double) {
        let calendar = Calendar.autoupdatingCurrent
        self.date = date
        self.temperature = temperature
    }
}

struct WeatherChartView: View {
    let temperatureArray: [Float]
    let startDate: Date
    let currentDate: Date
    let currentTemp: Double
    @State private var chartSelection: Date?
    @State private var chartYSelection: Double?
    
    
    
    var data: [HourlyTemperature] {
        var array: [HourlyTemperature] = []
        var i = 0
        temperatureArray.forEach { temperature in
            array.append(HourlyTemperature(date: (startDate.addingTimeInterval(TimeInterval(i * 60 * 60))), temperature: Double(temperature)))
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
                            VStack {
                                Text("\(Int(getTemp(for: chartSelection).rounded())) °C")
                                
                                Text("\(formatDateToTimeStamp(date: chartSelection))")
                                
                                
                            }
                            
                            
                            
                        }
                        .foregroundStyle(.secondary)
                        .foregroundStyle(Color.gray.opacity(0.1))
                    
                    
                }
                
                
                
                
                
                /*RuleMark(x: .value("", currentDate)).foregroundStyle(Color.gray.opacity(0.1))
                    .annotation(
                        position: .bottom,
                        overflowResolution: .init(x: .fit, y: .disabled)
                    ) {
                        ZStack {
                            Text("\(formatDateToTimeStamp(date: currentDate))")
                                .font(.caption)
                                .foregroundStyle(.primary)
                        }
                        
                    }*/
                
                
                AreaMark(x: .value("Time", $0.date), y: .value("Temperature", $0.temperature)).interpolationMethod(.catmullRom)
                    .foregroundStyle(Gradient(colors: [Color.yellow.opacity(0.5), Color.green.opacity(0.3), Color.blue.opacity(0.2)]))
                
                LineMark(x: .value("Time", $0.date), y: .value("Temperature", $0.temperature))
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(lineWidth: 5))
                    .foregroundStyle(Gradient(colors: [Color.yellow, Color.green, Color.blue]))
                
                
                
                
                
                
            }
            .chartXSelection(value: $chartSelection)
            .chartYSelection(value: $chartYSelection)
            
            
            
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
}

private func formatDateToTimeStamp(date: Date) -> String {
    var dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.string(from: date)
}





#Preview {
    WeatherChartView(temperatureArray: [20.1, 24.1, 23.5, 29.3, 30, 28, 28, 28, 29, 32, 33, 34, 33, 30, 30, 32, 29, 27, 26, 25, 25, 24, 23,20], startDate: Calendar.current.startOfDay(for: .now), currentDate: .now, currentTemp: 25.3)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)
    
}
