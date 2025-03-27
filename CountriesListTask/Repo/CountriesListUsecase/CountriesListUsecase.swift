//
//  CountriesList Usecase.swift
//  RickAndMortyTask
//
//  Created by Eslam Mohamed on 04/12/2024.
//

import Foundation



protocol CountriesListUseCaseProtocol {
    func getCountriesList () async throws -> [CountriesListModel]
    func saveSelectedCountries(_ countries: [PresentedDataViewModel]) async
    func getSelectedCountries() async -> [PresentedDataViewModel]
    func clearSelectedCountries() async
}


public final class CountriesListUseCase: CountriesListUseCaseProtocol, HTTPClient {
    var pathProvider = PathProvider(environmentProvider: ApiSettings())
    private let cachingManager = CachingManager.shared
    func getCountriesList() async throws -> [CountriesListModel] {
        let request = CountriesListAction.CountriesList
        guard let url = pathProvider.createURL(type: request) else {
            throw Error.notFoundUrl
        }
        
        let endPoint = RequestEndpoint(
            url: url,
            urlParameters: request.urlParameters,
            authorizationType: .none,
            method: .get,
            parameterEncoding: .queryString
        )
        
        do {
            let response = try await sendRequest(endPoint, model: Array<CountriesListModel>.self)
            return response
        } catch {
            throw error
        }
        
    }
    
    func saveSelectedCountries(_ countries: [PresentedDataViewModel]) async {
        cachingManager.save(countries, forKey: .selectedCountries)
    }
    
    func getSelectedCountries() async -> [PresentedDataViewModel] {
        return cachingManager.load(forKey: .selectedCountries) ?? []
    }
    
    func clearSelectedCountries() async {
        cachingManager.remove(forKey: .selectedCountries)
    }
}

