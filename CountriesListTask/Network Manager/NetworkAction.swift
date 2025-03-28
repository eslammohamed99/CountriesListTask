//
//  NetworkAction.swift
//  RickAndMortyTask
//
//  Created by Eslam Mohamed on 04/12/2024.
//

import Foundation


public typealias HTTPHeaders = [String:String]
protocol NetworkAction {
    var path: String {get}
    var parameters: [String: AnyHashable]? {get}
    var headers: HTTPHeaders {get}
    var version: String {get}
}
extension NetworkAction {
    var headers: HTTPHeaders {
        get{
            var header = HTTPHeaders()
            header["Content-Type"] = "application/json"
            return header
        }
    }
    var version: String {
        return "v2"
    }
    
    var parameters: [String: AnyHashable]? {
        return nil
    }
}

