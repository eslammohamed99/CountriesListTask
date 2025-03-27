//
//  CountriesListView.swift
//  CountriesListTask
//
//  Created by Eslam Mohamed on 25/03/2025.
//

import UIKit


class CountriesListView: UIViewController, CountriesListViewProtocol {
    var viewModel: CountriesListViewModelProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        title = "countries List"
        navigationController?.navigationBar.prefersLargeTitles = true
        viewModel?.bindActions()
    }
}

private extension CountriesListView {
    func setupUI() {
        if let viewModel = viewModel as? CountriesListViewModel {
            let swiftuiView = CountriesListUIView(viewModel: viewModel)
            addSubSwiftUIView(swiftuiView, to: view, backgroundColor: .white)
        }
    }
}
