//
//  HomeViewModel.swift
//  Workout
//
//  Created by 山田隼也 on 2020/12/14.
//

import Foundation

// MARK: - Input and Output

protocol HomeViewModelInput {
    
}

protocol HomeViewModelOutput {
    
}

protocol HomeViewModelType {
    var input: HomeViewModelInput { get }
    var output: HomeViewModelOutput { get }
}

// MARK: - View Model

final class HomeViewModel: HomeViewModelInput, HomeViewModelOutput {
    
    private let model: HomeModelProtocol
    
    init(model: HomeModelProtocol = HomeModel()) {
        self.model = model
    }
}

extension HomeViewModel: HomeViewModelType {
    var input: HomeViewModelInput { self }
    var output: HomeViewModelOutput { self }
}
