//
//  WeatherIconService.swift
//  WeatherForecast
//
//  Created by Oliver Blass on 09.09.24.
//

import Foundation
import SwiftUI

class WeatherIconService {
    
    
    var colorArrayDictonary: Dictionary<String, [Color]>? =  [:]

    
    func addToColorArrayDictonary (_ systemName: String) {
                
   
        var colorArray = [Color.white, Color.white, Color.white]
        
        let systemNameArray = systemName.components(separatedBy: ".")
        
        
        var i = 0
        systemNameArray.forEach { systemNamePart in
            if systemNamePart == "sun" {
                colorArray[i] = Color.yellow
            } else if systemNamePart == "rain" || systemNamePart == "drizzle" {
                colorArray[i] = Color.blue
            }
            i += 1
            
        }
        
        if systemName == "cloud.bolt.rain.fill" {
            colorArray = [Color.white, Color.blue, Color.white]
        }
        
        colorArrayDictonary![systemName] = colorArray
        
        
    
        
        
    }
    
    
    func getWeatherIconSystemName(wmoCode: String, isDay: Bool) -> String {

        return getItemFromJson(isDay: isDay, id: wmoCode)?.image ?? "exclamationmark.questionmark"
        
    }
    
    func getWeatherDescription(wmoCode: String, isDay: Bool) -> String {
        return getItemFromJson(isDay: isDay, id: wmoCode)?.description ?? "Probably pretty bad"
        
    }
    
    func decideWeathericonColorArray(systemName: String) -> [Color] {
        
        if let colorArrayDictonary = colorArrayDictonary, let colorArray = colorArrayDictonary[systemName] {
            return colorArray
        } else {
            addToColorArrayDictonary(systemName)
            return colorArrayDictonary?[systemName] ?? [Color.white, Color.white, Color.white]
        }
        
    }
}
