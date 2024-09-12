//
//  WmoCodeService.swift
//  WeatherForecast
//
//  Created by Oliver Blass on 04.09.24.
//

import Foundation


struct WmoItem : Decodable {
    let id: String
    let description: String
    let image: String
}

var wmoItemDictionaryDay: Dictionary<String, WmoItem>? = nil
var wmoItemDictionaryNight: Dictionary<String, WmoItem>? = nil


func fillDictionaryDay() {
    wmoItemDictionaryDay = [:]
    do {
        if let url = Bundle.main.url(forResource: "BetterWmoCodes", withExtension: "json") {
            
            // Load the data from the file
            let data = try Data(contentsOf: url)
            
            // Parse the JSON data
            let weatherData = try JSONDecoder().decode([WmoItem].self, from: data)
            
            // Now you can access the parsed data
            for wmoItem in weatherData {
                wmoItemDictionaryDay![wmoItem.id] = wmoItem
            }
        }
    } catch {
        debugPrint("Error loading or parsing the JSON: \(error)")
    }
}

func fillDictionaryNight() {
    wmoItemDictionaryNight = [:]
    do {
        if let url = Bundle.main.url(forResource: "BetterWmoCodesNight", withExtension: "json") {
            
            // Load the data from the file
            let data = try Data(contentsOf: url)
            
            // Parse the JSON data
            let weatherData = try JSONDecoder().decode([WmoItem].self, from: data)
            
            // Now you can access the parsed data
            for wmoItem in weatherData {
                wmoItemDictionaryNight![wmoItem.id] = wmoItem
            }
        }
    } catch {
        debugPrint("Error loading or parsing the JSON: \(error)")
    }
}

func getItemFromJson(isDay:Bool, id: String) -> WmoItem? {
    if isDay {
        if wmoItemDictionaryDay == nil {
            fillDictionaryDay()
        }
        if let wmoItemDictionary = wmoItemDictionaryDay, let wmoItem = wmoItemDictionary[id] {
            return wmoItem
        } else {
            debugPrint("Could not find the WMO-Code: \(id)")
        }
    } else {
        if wmoItemDictionaryNight == nil {
            fillDictionaryNight()
        }
        if let wmoItemDictionary = wmoItemDictionaryNight, let wmoItemNight = wmoItemDictionary[id] {
            return wmoItemNight
        } else {
            debugPrint("Could not find the WMO-Code: \(id)")
        }
    }
    return nil
}

