//
//  SevenDayForecastView.swift
//  WeatherForecast
//
//  Created by Oliver Blass on 29.08.24.
//

import SwiftUI

struct SevenDayForecastView: View {
    var data: [MyWeatherData]?
    
    var body: some View {
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
                            DayForecast(day: value == 0 ? "Today" : day.date ?? "??", isRainy: day.isRainy ?? false, high: Int(day.maxTemp ?? 0), low: Int(day.minTemp ?? 0), isDay: day.isDay ?? false, wmoCode: day.dailyWeatherCode ?? -1)
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
}

struct DayForecast: View {
    let day: String
    let isRainy: Bool
    let high: Int
    let low: Int
    let isDay: Bool
    let wmoCode: Int
    
    
    var body: some View {
        VStack {
            Text(day)
                .font(Font.headline)
            let colorArray = decideWeathericonColorArray(weatherCode: wmoCode, systemName: (ViewModel().getWeatherIconSystemName(wmoCode: String(wmoCode), isDay: isDay)))
                                                       
            Image(systemName: String(ViewModel().getWeatherIconSystemName(wmoCode: String(wmoCode), isDay: isDay))/*decideWeatherIconSystemName(isDay: isDay, isRainy: isRainy, day: day)*/)
                .symbolRenderingMode(.palette)
                .foregroundStyle(colorArray[0], colorArray[1])
                .font(Font.largeTitle)
                .padding(5)
            Text("High: \(high)°")
            Text("Low \(low)°")
                .foregroundStyle(Color.secondary)
        }
        .padding()
    }

}


#Preview {
    
    SevenDayForecastView(data: SampleMyWeatherData().getSampleData())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.blue)
}

/*func decideWeatherIconColor(isDay: Bool, isRainy: Bool, day: String) -> Color {
    if !isDay && day.elementsEqual("Today") {
        return Color.white
    }
    if isRainy {
        return Color.blue
    } else {
        return Color.yellow
    }
}*/

func decideWeathericonColorArray(weatherCode: Int, systemName: String) -> [Color] {
    var colorArray = [Color.white, Color.white]
    
    if systemName == "sun.max.fill" {
        colorArray[0] = Color.yellow
    }
    
    if systemName.contains(Regex<Any>(verbatim: "sun")) {
        colorArray[1] = Color.yellow
    } else if systemName.contains(Regex<Any>(verbatim: "rain")) || systemName.contains(Regex<Any>(verbatim: "drizzle")) {
        colorArray[1] = Color.blue
    }
    return colorArray
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

