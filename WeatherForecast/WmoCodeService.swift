//
//  WmoCodeService.swift
//  WeatherForecast
//
//  Created by Oliver Blass on 04.09.24.
//

import Foundation

struct ResponseData: Decodable {
    var wmoItem: [WmoItem]
}
struct WmoItem : Decodable {
    let id: String
    let description: String
    let image: String
}

var wmoItemDictionary: Dictionary<String, WmoItem>? = nil

func fillDictionary(_ fileName: String) {
    wmoItemDictionary = [:]
    do {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            
            // Load the data from the file
            let data = try Data(contentsOf: url)
            
            // Parse the JSON data
            let weatherData = try JSONDecoder().decode([WmoItem].self, from: data)
            
            // Now you can access the parsed data
            for wmoItem in weatherData {
                wmoItemDictionary![wmoItem.id] = wmoItem
            }
        }
    } catch {
        print("Error loading or parsing the JSON: \(error)")
    }
}

func getItemFromJson(fileName: String, id: String) -> WmoItem? {
    if wmoItemDictionary == nil {
        fillDictionary(fileName)
    }
    
    
    if let wmoItemDictionary = wmoItemDictionary, let wmoItem = wmoItemDictionary[id] {
        return wmoItem
    } else {
        print("Could not find the file.")
    }
    
    return nil
}

