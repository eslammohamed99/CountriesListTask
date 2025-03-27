//
//  CountryDetailCoordinatorProtocol.swift
//  CountriesListTask
//
//  Created by Eslam Mohamed on 27/03/2025.
//

import Foundation
import UIKit
enum CountryDetailCoordinatorCallbackType {
    case back
}
typealias CountryDetailCoordinatorCall = ((CountryDetailCoordinatorCallbackType) -> Void)
protocol CountryDetailCoordinatorUseCaseProtocol {
    var navigationController: UINavigationController { get set }
    var countryInfo: PresentedDataViewModel { get }
}
protocol CountryDetailCoordinatorProtocol: AnyObject {
    init(useCase: CountryDetailCoordinatorUseCaseProtocol)
    func start(callback: @escaping CountryDetailCoordinatorCall)
}

