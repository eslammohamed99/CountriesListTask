//
//  CountriesListCoordinator.swift
//  CountriesListTask
//
//  Created by Eslam Mohamed on 25/03/2025.
//

import UIKit

class CountriesListCoordinator: BaseCoordinator, CountriesListCoordinatorProtocol {
    private var callback: CountriesListCoordinatorCall?
    private var viewModel: CountriesListViewModelProtocol?
    private weak var window: UIWindow?
    required init(useCase: CountriesListCoordinatorUseCaseProtocol) {
        window = useCase.window
        super.init()
        viewModel = CountriesListViewModel(callback: processViewModelCallback(),
                                           locationManager: LocationManager(), useCase: CountriesListUseCase())
    }

    func start() {
        let view: CountriesListViewProtocol & UIViewController = CountriesListView()
        view.viewModel = viewModel
        let navigationController = UINavigationController(rootViewController: view)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        self.navigationController = navigationController
    }
    
    func gotoDetailCountry(countryInfo: PresentedDataViewModel){
        struct UseCase: CountryDetailCoordinatorUseCaseProtocol {
            var navigationController: UINavigationController
            var countryInfo: PresentedDataViewModel
        }
        guard let navigationController = navigationController else {
            return
        }
        let coordinator = CountryDetailCoordinator(
            useCase: UseCase(navigationController: navigationController,
                             countryInfo: countryInfo))
        addChild(coordinator)
        coordinator.start(
            callback: { [weak self] type in
                guard let self = self else {
                    return
                }
                switch type {
                case.back:
                    self.navigationController?.popViewController(animated: true)
                }
            })
    }
}

private extension CountriesListCoordinator {
    func processViewModelCallback() -> CountriesListViewModelCallback {
        return { [weak self] type in
            switch type {
            case .back:
                break
            case let .gotoDetail(itemInfo):
                self?.gotoDetailCountry(countryInfo: itemInfo)
            }
        }
    }
}
