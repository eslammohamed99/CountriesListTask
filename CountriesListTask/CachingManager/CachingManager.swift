//
//  CachingManager.swift
//  CountriesListTask
//
//  Created by Eslam Mohamed on 26/03/2025.
//

// MARK: - CachingManager.swift
import Foundation

class CachingManager {
    static let shared = CachingManager()
    
    private let userDefaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private init() {}
    
    enum CacheKey: String {
        case selectedCountries = "com.countrieslist.selectedCountries"
    }
    
    func save<T: Encodable>(_ object: T, forKey key: CacheKey) {
        do {
            let data = try encoder.encode(object)
            userDefaults.set(data, forKey: key.rawValue)
        } catch {
            print("Error saving object for key \(key.rawValue): \(error)")
        }
    }
    
    func load<T: Decodable>(forKey key: CacheKey) -> T? {
        guard let data = userDefaults.data(forKey: key.rawValue) else {
            return nil
        }
        
        do {
            let object = try decoder.decode(T.self, from: data)
            return object
        } catch {
            print("Error loading object for key \(key.rawValue): \(error)")
            return nil
        }
    }
    
    func remove(forKey key: CacheKey) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
    
    func clearAll() {
        for key in CacheKey.allCases {
            userDefaults.removeObject(forKey: key.rawValue)
        }
    }
}

// Make CacheKey conform to CaseIterable if you want to use clearAll()
extension CachingManager.CacheKey: CaseIterable {}
