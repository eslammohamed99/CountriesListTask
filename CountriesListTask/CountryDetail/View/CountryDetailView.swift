//
//  CountryDetailView.swift
//  CountriesListTask
//
//  Created by Eslam Mohamed on 27/03/2025.
//

import UIKit


class CountryDetailView: UIViewController, CountryDetailViewProtocol {
    var viewModel: CountryDetailViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel?.bindActions()
        configureNavigation()
    }
    
    private func configureNavigation() {
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

private extension CountryDetailView {
    func setupUI() {
        if let viewModel = viewModel as? CountryDetailViewModel {
            let swiftuiView = CountryDetailUIView(viewModel: viewModel)
            addSubSwiftUIView(swiftuiView, to: view, backgroundColor: .white)
        }
    }
}

