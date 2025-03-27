//
//  CountriesListTaskTests.swift
//  CountriesListTaskTests
//
//  Created by Eslam Mohamed on 25/03/2025.
//

import XCTest
import Combine
import CoreLocation
@testable import CountriesListTask

final class CountriesListViewModelTests: XCTestCase {
    
    // MARK: - Variables
        var viewModel: CountriesListViewModel!
        var mockUseCase: MockCountriesListUseCase!
        var mockLocationManager: MockLocationManager!
        var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
            super.setUp()
            mockUseCase = MockCountriesListUseCase()
            mockLocationManager = MockLocationManager()
            viewModel = CountriesListViewModel(
                callback: { _ in },
                locationManager: mockLocationManager,
                useCase: mockUseCase
            )
        }
        
        override func tearDown() {
            viewModel = nil
            mockUseCase = nil
            mockLocationManager = nil
            cancellables.removeAll()
            super.tearDown()
        }
    
    // MARK: - Tests
        
        func testFetchCountries() async {
            // Given: Mock data returned from the use case
            let mockCountries = [
                CountriesListModel(name: "Egypt",
                                   latlng: [30.0,21.0],
                                   capital: "Cairo",
                                   nativeName: "Egypt"),

                CountriesListModel(name: "France",
                                   latlng: [22.0,30.0],
                                   capital: "Paris",
                                   nativeName: "France")
                
            ]
            mockUseCase.countriesList = mockCountries
            
            // When: Fetching countries
            await viewModel.fetchCountries()
            
            // Then: `displayModel` should be updated with the mocked countries
            XCTAssertEqual(viewModel.displayModel.count, 2)
            XCTAssertEqual(viewModel.displayModel.first?.name, "Egypt")
        }
    func testSearchCountries() {
        // Given: A list of countries
        viewModel.allCountries = [
            CountriesListModel(name: "Egypt", latlng: nil, capital: "Cairo", nativeName: nil, currencies: [CurrencyModel(code: nil, name: "EGP", symbol: nil)], flag: nil, flags: nil),
           CountriesListModel(name: "France", latlng: nil, capital: "Paris", nativeName: nil, currencies: [CurrencyModel(code: nil, name: "Euro", symbol: nil)], flag: nil, flags: nil)
        ]
        
        // When: Searching for "France"
        let filtered = viewModel.filterCountries(searchQuery: "Euro")
        
        // Debug logs
        print("Display Model:", viewModel.displayModel.map { $0.name })
        print("Filtered Results:", filtered.map { $0.name })
        
        // Then: Only "France" should appear in results
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.name, "France")
    }
        
        func testToggleCountrySelection() {
            // Given: A country to select
            let country = PresentedDataViewModel(model: CountriesListModel(name: "Egypt",capital: "Cairo"))
            
            // When: Selecting the country
            viewModel.toggleCountrySelection(country)
            
            // Then: The country should be added to `selectedCountries`
            XCTAssertTrue(viewModel.isCountrySelected(country))
            
            // When: Selecting it again
            viewModel.toggleCountrySelection(country)
            
            // Then: It should be removed
            XCTAssertFalse(viewModel.isCountrySelected(country))
        }
        
        func testMaxCountrySelection() {
            // Given: The max selection limit is 5
            for i in 1...5 {
                viewModel.selectedCountries.append(PresentedDataViewModel(model: CountriesListModel(name: "Country\(i)", capital: "Capital\(i)")))
            }
            
            // When: Trying to select another country
            let newCountry = PresentedDataViewModel(model: CountriesListModel(name: "Country6", capital: "Capital6"))
            viewModel.toggleCountrySelection(newCountry)
            
            // Then: It should not be added, and an alert should show
            XCTAssertFalse(viewModel.isCountrySelected(newCountry))
            XCTAssertTrue(viewModel.showMaxLimitAlert)
        }
        
//        func testSetNearestLocation() {
//            // Given: A mock location in France
//            mockLocationManager.userLocation.send(CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522))
//            
//            // When: Calling `setUserNearstLocation`
//            viewModel.setUserNearstLocation()
//            
//            // Then: The nearest country should be auto-selected (if exists)
//            XCTAssertFalse(viewModel.selectedCountries.isEmpty)
//        }
        
        func testSetDefaultLocation() {
            viewModel.allCountries = [
                CountriesListModel(name: "Egypt", latlng: nil, capital: "Cairo", nativeName: nil, currencies: [CurrencyModel(code: nil, name: "EGP", symbol: nil)], flag: nil, flags: nil),
               CountriesListModel(name: "France", latlng: nil, capital: "Paris", nativeName: nil, currencies: [CurrencyModel(code: nil, name: "Euro", symbol: nil)], flag: nil, flags: nil)
            ]
            // Given: No location access
            mockLocationManager.getAccess.send(false)
            
            // When: Calling `setUserDefaultLocation`
            viewModel.setUserDefaultLocation()
            
            // Then: It should default to "Egypt"
            XCTAssertEqual(viewModel.selectedCountries.first?.name, "Egypt")
        }
    }

    // MARK: - Mock Use Case
class MockCountriesListUseCase: CountriesListUseCaseProtocol {
    func clearSelectedCountries() async {
        
    }
    
        var countriesList: [CountriesListModel] = []
        
        func getCountriesList() async throws -> [CountriesListModel] {
            return countriesList
        }
        
        func saveSelectedCountries(_ countries: [PresentedDataViewModel]) async {}
        
        func getSelectedCountries() async -> [PresentedDataViewModel] {
            return []
        }
    }

    // MARK: - Mock Location Manager
class MockLocationManager: LocationManagerCallBackDelegate {
    func startUpdatingLocation() {
        
    }
    
    public var userLocation: CurrentValueSubject<CLLocationCoordinate2D?, Never> = .init(nil)
    
    public var getAccess: CurrentValueSubject<Bool?, Never> = .init(nil)
    
    private var locationManager = CLLocationManager()
}
    
