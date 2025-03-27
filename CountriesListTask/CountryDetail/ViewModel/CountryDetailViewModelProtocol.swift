//
//  CountryDetailViewModelCallbackType.swift
//  CountriesListTask
//
//  Created by Eslam Mohamed on 27/03/2025.
//


import UIKit
enum CountryDetailViewModelCallbackType {
    case back
}

typealias CountryDetailViewModelCallback = (CountryDetailViewModelCallbackType) -> Void

protocol CountryDetailViewModelProtocol: AnyObject {
    var callback: CountryDetailViewModelCallback { get set }
    func viewDidLoad()
    func bindActions()
}
