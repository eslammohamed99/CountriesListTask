//
//  CountriesListViewModelProtocol.swift
//  CountriesListTask
//
//  Created by Eslam Mohamed on 25/03/2025.
//

import Foundation

enum CountriesListViewModelCallbackType {
    case back
    case gotoDetail(itemInfo:PresentedDataViewModel)
}

typealias CountriesListViewModelCallback = (CountriesListViewModelCallbackType) -> Void

protocol CountriesListViewModelProtocol: AnyObject {
    var callback: CountriesListViewModelCallback { get set }
    func viewDidLoad()
    func bindActions()
    func toggleLoading(_ bool: Bool)
}
