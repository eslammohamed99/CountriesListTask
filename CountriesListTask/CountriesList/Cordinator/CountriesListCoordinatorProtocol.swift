//
//  CountriesListCoordinatorProtocol.swift
//  CountriesListTask
//
//  Created by Eslam Mohamed on 25/03/2025.
//


import Foundation
import UIKit
enum CountriesListCoordinatorCallbackType {
    case back
}
typealias CountriesListCoordinatorCall = ((CountriesListCoordinatorCallbackType) -> Void)
protocol CountriesListCoordinatorUseCaseProtocol {
    var window: UIWindow { get set }
}
protocol CountriesListCoordinatorProtocol: AnyObject {
    init(useCase: CountriesListCoordinatorUseCaseProtocol)
    func start()
}

