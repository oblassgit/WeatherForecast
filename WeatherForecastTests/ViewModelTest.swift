//
//  ViewModelTest.swift
//  WeatherForecastTests
//
//  Created by Oliver Blass on 10.09.24.
//

import XCTest
@testable import WeatherForecast

final class ViewModelTest: XCTestCase {
    
    private var viewModel: ViewModel?
    
    override func setUpWithError() throws {
        viewModel = ViewModel()

    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testViewModelDataIsNil() throws {
        XCTAssert(viewModel?.data == nil)
    }

    func testViewModelRefreshPerformance() throws {
        viewModel = ViewModel()
        self.measure {
            viewModel?.refreshData()
        }
    }

}
