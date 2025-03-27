//
//  CountriesListViewModel.swift
//  CountriesListTask
//
//  Created by Eslam Mohamed on 25/03/2025.
//

import Foundation
import Combine
import CoreLocation
class CountriesListViewModel: @preconcurrency CountriesListViewModelProtocol, ObservableObject {
    // MARK: - Published Variables
    
    @Published var displayModel: [PresentedDataViewModel] = []
    @Published var selectedCountries: [PresentedDataViewModel] = []
     var allCountries: [CountriesListModel] = []
    @Published var isLoading = false
    @Published var addMore = true
    @Published var showMaxLimitAlert = false
    @Published var searchText: String = ""
    private let maxCountrySelection = 5
    // MARK: - Variables
    private(set) var selectedFilter: String? = nil
    var actionsSubject = PassthroughSubject<CountriesListActions, Never>()
    var callback: CountriesListViewModelCallback
    private var cancellables = Set<AnyCancellable>()
    private var useCase: CountriesListUseCaseProtocol
    let locationManager: LocationManagerCallBackDelegate
    
    init(callback: @escaping CountriesListViewModelCallback,
         locationManager: LocationManagerCallBackDelegate,
         useCase: CountriesListUseCaseProtocol) {
        self.callback = callback
        self.useCase = useCase
        self.locationManager = locationManager
        
        Task {
            await loadSelectedCountries()
            
        }
    }
    // MARK: - Functions
    
    func viewDidLoad() {
        Task {
            await fetchCountries()
        }
        locationManager.startUpdatingLocation()
    }
    
    func bindActions() {
        actionsSubject
            .sink { [weak self] action in
                guard let self = self else{return}
                switch action {
                case .back:
                    self.callback(.back)
                case let  .gotoDetail(item):
                    self.callback(.gotoDetail(itemInfo: item))
                }
            }
            .store(in: &cancellables)

        // Add search text filtering
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchQuery in
                self?.filterCountries(searchQuery: searchQuery)
            }
            .store(in: &cancellables)
        
        locationManager.userLocation
            .sink { [weak self] location in
                self?.setUserNearstLocation()
            }
            .store(in: &cancellables)
            
            // Add subscription to access status
        locationManager.getAccess
            .sink { [weak self] hasAccess in
                guard let self = self else { return }
                self.setUserDefaultLocation()
            }
            .store(in: &cancellables)
        
    }
    
    func filterCountries(searchQuery: String) -> [PresentedDataViewModel]{
            if searchQuery.isEmpty {
              //  displayModel = allCountries.toModels()
                return allCountries.toModels()
            } else {
                let lowercasedQuery = searchQuery.lowercased()
               return allCountries.toModels().filter { country in
                    // Filter by name, city or currency
                    return (country.curency?.name?.lowercased().contains(lowercasedQuery) ?? false) ||
                    (country.capitalName.lowercased().contains(lowercasedQuery))
                }
            }
        }

    @MainActor
     func fetchCountries() async {
        do {
            toggleLoading(true)
            let countriesResult = try await useCase.getCountriesList()
            toggleLoading(false)
            allCountries = countriesResult
            displayModel = countriesResult.toModels()
            self.setUserNearstLocation()
            self.setUserDefaultLocation()
            
        } catch {
            //  dataStatus = .failure(.invalidData)
        }
    }
    
    @MainActor
    func toggleLoading(_ bool: Bool) {
        isLoading = bool
    }

    private func updateAddMoreState() {
        // Enable "Add More" only if we're under the maximum limit
        addMore = selectedCountries.count < maxCountrySelection
    }
    
    // Add this function to your CountriesListViewModel
    func toggleCountrySelection(_ country: PresentedDataViewModel) {
        if isCountrySelected(country) {
            // If already selected, remove it
            selectedCountries.removeAll { $0.name == country.name }
        } else {
            // If not selected, check if maximum limit reached
            if selectedCountries.count >= maxCountrySelection {
                // Show alert instead of adding
                showMaxLimitAlert = true
                return
            }
            // If under limit, add it
            selectedCountries.append(country)
        }
        updateAddMoreState()
        // Save the updated selection
        Task {
            await saveSelectedCountries()
        }
    }
    
    // Helper function to check if a country is already selected
    func isCountrySelected(_ country: PresentedDataViewModel) -> Bool {
        return selectedCountries.contains(where: { $0.name == country.name })
    }

    // MARK: - Caching Methods
       
       @MainActor
       private func saveSelectedCountries() async {
           await useCase.saveSelectedCountries(selectedCountries)
       }
       
       @MainActor
       private func loadSelectedCountries() async {
           let countries = await useCase.getSelectedCountries()
           selectedCountries = countries
           updateAddMoreState()
       }
    
    func findNearestCountry(userLocation: CLLocationCoordinate2D) -> PresentedDataViewModel? {
        guard !displayModel.isEmpty else { return nil }
        
        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        
        var nearestCountry: PresentedDataViewModel?
        var minDistance = CLLocationDistance.greatestFiniteMagnitude
        
        for country in displayModel {
            // Skip countries with invalid locations
            guard let countryLocation = country.location else { continue }
            
            // Use CLLocation's built-in distance calculation
            let distance = countryLocation.distance(from: userCLLocation)
            
            if distance < minDistance {
                minDistance = distance
                nearestCountry = country
            }
        }
        
        return nearestCountry
    }
    
    func setUserNearstLocation() {
        if let location = locationManager.userLocation.value {
            if let nearest = findNearestCountry(userLocation: location),selectedCountries.isEmpty {
                toggleCountrySelection(nearest)
                print("Selected nearest country: \(nearest.name) after countries loaded")
            }
        }
    }
    func setUserDefaultLocation() {
        if let hasAccess = locationManager.getAccess.value {
            if hasAccess == true { return }
            if let egyptCountry = self.filterCountries(searchQuery: "Cairo").first, selectedCountries.isEmpty {
                self.toggleCountrySelection(egyptCountry)
                print("Location access status: \(hasAccess == false ? "Denied" : "Undetermined"), defaulting to Egypt")
            }
        }
    }

}

extension CountriesListViewModel {
    enum CountriesListActions {
        case back
        case gotoDetail(info:PresentedDataViewModel)
    }
}
