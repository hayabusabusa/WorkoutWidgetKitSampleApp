//
//  HomeViewModel.swift
//  Workout
//
//  Created by 山田隼也 on 2020/12/14.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    private let model: HomeModelProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var isAuthorized: Bool = false
    @Published var isLoading: Bool = true
    
    init(model: HomeModelProtocol = HomeModel()) {
        self.model = model
        
        let isAuthorizedStream = model.isAuthorizedPublisher
            .assign(to: \.isAuthorized, on: self)
        let isLoadingStream = model.isLoadingPublisher
            .assign(to: \.isLoading, on: self)
        
        cancellables = [isAuthorizedStream, isLoadingStream]
    }
    
    func onAppear() {
        model.requestAuthorization()
    }
}
