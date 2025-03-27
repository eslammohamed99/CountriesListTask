//
//  CountryDetailViewModel.swift
//  CountriesListTask
//
//  Created by Eslam Mohamed on 27/03/2025.
//

import Foundation
import Combine
class CountryDetailViewModel: CountryDetailViewModelProtocol, ObservableObject {

    // MARK: - Published Variables
    
    @Published var displayModel: PresentedDataViewModel
    // MARK: - Variables
    var actionsSubject = PassthroughSubject<CountryDetailActions, Never>()
    var callback: CountryDetailViewModelCallback
    private var cancellables = Set<AnyCancellable>()
    init(displayModel: PresentedDataViewModel, callback: @escaping CountryDetailViewModelCallback) {
        self.displayModel = displayModel
        self.callback = callback
    }
    // MARK: - Functions
    
    func viewDidLoad() {
        
    }
    
    func bindActions() {
        actionsSubject
            .sink { [weak self] action in
                guard let self = self else{return}
                switch action {
                case .back:
                    self.callback(.back)
                }
            }
            .store(in: &cancellables)
    }
}

extension CountryDetailViewModel {
    enum CountryDetailActions {
        case back
    }
}
