//
//  CountryDetailCoordinator.swift
//  CountryDetailTask
//
//  Created by Eslam Mohamed on 27/03/2025.
//
import Foundation
import UIKit

class CountryDetailCoordinator: BaseCoordinator, CountryDetailCoordinatorProtocol {
    
    
    private var callback: CountryDetailCoordinatorCall?
    private var viewModel: CountryDetailViewModelProtocol?
    required init(useCase: CountryDetailCoordinatorUseCaseProtocol) {
        super.init(navigationController: useCase.navigationController)
        viewModel = CountryDetailViewModel(displayModel: useCase.countryInfo, callback: processViewModelCallback())
    }

    func start(callback: @escaping CountryDetailCoordinatorCall) {
        self.callback = callback
        let view: CountryDetailViewProtocol & UIViewController = CountryDetailView()
        view.viewModel = viewModel
        navigationController?.pushViewController(view, animated: true)
    }

}

private extension CountryDetailCoordinator {
    func processViewModelCallback() -> CountryDetailViewModelCallback {
        return { [weak self] type in
            switch type {
            case .back:
                self?.callback?(.back)
            }
        }
    }
}
