//
//  WeatherForecastTests.swift
//  WeatherForecastTests
//
//  Created by Oliver Blass on 07.08.24.
//

import XCTest
import CoreLocation
@testable import WeatherForecast

final class WeatherForecastTests: XCTestCase {

    override func setUpWithError() throws {
        fillDictionaryDay()
        fillDictionaryNight()
    }
    

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testJsonItemDictonary() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        XCTAssert(getItemFromJson(isDay: true, id: "0")?.image == "sun.max.fill")
        XCTAssert(getItemFromJson(isDay: false, id: "0")?.image == "moon.stars.fill")
        
        XCTAssert(getItemFromJson(isDay: true, id: "0")?.description == "Sunny")
        XCTAssert(getItemFromJson(isDay: false, id: "0")?.description == "Clear")


        
    }

}
