//
//  PrecipitationChartView.swift
//  WeatherForecast
//
//  Created by Oliver Blass on 23.10.24.
//

import SwiftUI
import Charts
import Foundation

fileprivate struct HourlyData : Identifiable {
    var id = UUID()
    
    var date: Date
    var precipitation: Float
    
    
    init(date: Date, precipitation: Float) {
        self.date = date
        self.precipitation = precipitation
    }
}

struct PrecipitationChartView: View {
    let precipitationArray: [Float]
    let startDate: Date
    let currentDate: Date
    let currentPercip: Float
    @State private var chartSelection: Date?
    
    var weatherIconService = WeatherIconService()
    
    
    
    fileprivate var data: [HourlyData] {
        var array: [HourlyData] = []
        var i = 0
        
    
        precipitationArray.forEach { precipitation in
            array.append(HourlyData(date: (startDate.addingTimeInterval(TimeInterval(i * 60 * 60))), precipitation: precipitation))
            i += 1
            
        }
        
        return array
    }
    
    
    var body: some View {
        
        VStack(alignment: .leading, content: {
            HStack {
                Image(systemName: "drop.fill")
                    .font(.subheadline)
                Text("Precipitation")
                    .font(.subheadline.smallCaps())
            }.foregroundStyle(Color.secondary)
            Divider()
            
            if (chartSelection == nil) {
                Text("\(Int(currentPercip.rounded())) mm")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            } else {
                Text(" ")
                    .font(.title)
            }
            
            
            Chart (data) {
                if let chartSelection {
                    let closestDatum = closestDatum(to: chartSelection)
                    RuleMark(x: .value("Time", closestDatum))
                        .annotation(
                            position: .top,
                            overflowResolution: .init(x: .fit, y: .disabled)
                        ) {
                            HStack {
                                VStack {
                                    
                                    Text(decideRuleMarkString(precipitation: getPrecip(for: closestDatum)))
                                        .padding(.horizontal).fixedSize()
                                    
                                    Text("\(formatDateToTimeStamp(date: closestDatum))")
                                        .padding(.horizontal).fixedSize()
                                    
                                    
                                    
                                }
                            }
                            
                            
                            
                        }
                        .foregroundStyle(.secondary)
                        .foregroundStyle(Color.gray.opacity(0.1))


                
                    
                }

                
                
                
                
                
            
                BarMark(x: .value("Time", $0.date), y: .value("Temperature", $0.precipitation))
                
                
                
                
                
                
            }
            .chartYScale(domain: 0...calculateChartScale(data: data))
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
    
    func getPrecip(for date: Date) -> Float {
        return data.first(where: { Calendar.current.isDate($0.date, equalTo: date, toGranularity: .hour) })?.precipitation ?? 0.0
    }
    
    fileprivate func closestDatum(to date: Date) -> Date {
        return data.sorted { abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date)) }.first!.date
    }
    
    func decideRuleMarkString(precipitation: Float) -> String {
        if precipitation < 1 && precipitation > 0 {
            return "<1 mm"
        } else {
            return Int(precipitation.rounded()).description + " mm"
        }
    }
    
    fileprivate func calculateChartScale(data: [HourlyData]) -> Float {
        let maxPrecip = data.max { firstElement, secondElement in
            firstElement.precipitation > secondElement.precipitation
        }?.precipitation ?? 0.0
        
        if maxPrecip > 10.0 {
            return maxPrecip + 5.0
        } else {
            return 10
        }
    }
}

private func formatDateToTimeStamp(date: Date) -> String {
    return DateFormatterService().hhmmDateFormatter.string(from: date)
}





#Preview {
    PrecipitationChartView(precipitationArray: [1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.5, 1.9, 3.2, 3.2, 3.2, 3.2, 3.2, 3.2, 1.2, 0.4, 0.0, 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], startDate: Calendar.current.startOfDay(for: .now), currentDate: .now, currentPercip: 3.2)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)
    
}
