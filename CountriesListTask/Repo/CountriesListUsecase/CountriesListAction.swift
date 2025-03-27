//
//  CountriesList Action.swift
//  RickAndMortyTask
//
//  Created by Eslam Mohamed on 04/12/2024.
//

import Foundation

enum CountriesListAction: NetworkAction {
    
    case CountriesList
   
    var path: String {
        switch self {
        case .CountriesList :
            return "all"
        }
    }

    var parameters: [String: AnyHashable]? {
        switch self {
        default:
            return nil
        }
    }

    var headers: [String: String] {
        
        switch self {
        default:
            return [:]
        }
    }
    var version: String {
        switch self {
        default:
            return "v2"
        }
    }
    
    var urlParameters: [String: AnyHashable]? {
        switch self {
        default:
            return [:]
        }
    }
}
