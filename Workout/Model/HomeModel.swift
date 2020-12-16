//
//  HomeModel.swift
//  Workout
//
//  Created by 山田隼也 on 2020/12/14.
//

import Foundation
import Combine
import HealthKit

protocol HomeModelProtocol: AnyObject {
    var isAuthorizedPublisher: AnyPublisher<Bool, Never> { get }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    func requestAuthorization()
}

final class HomeModel: HomeModelProtocol {
    
    private let healthStore: HKHealthStore
    
    private let isAuthorizedSubject = PassthroughSubject<Bool, Never>()
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(true)
    
    var isAuthorizedPublisher: AnyPublisher<Bool, Never>
    var isLoadingPublisher: AnyPublisher<Bool, Never>
    
    init(healthStore: HKHealthStore = HKHealthStore()) {
        self.healthStore = healthStore
        self.isAuthorizedPublisher = isAuthorizedSubject.eraseToAnyPublisher()
        self.isLoadingPublisher = isLoadingSubject.eraseToAnyPublisher()
    }
    
    func requestAuthorization() {
        let status = healthStore.authorizationStatus(for: HKObjectType.workoutType())
        switch status {
        case .notDetermined:
            let read: Set<HKObjectType> = [HKWorkoutType.workoutType()]
            healthStore.requestAuthorization(toShare: nil, read: read) { [weak self] (isGranted, error) in
                if let error = error {
                    print(error)
                    return
                }
                DispatchQueue.main.async {
                    self?.isAuthorizedSubject.send(isGranted)
                    self?.isLoadingSubject.send(false)
                }
            }
        case .sharingAuthorized:
            isAuthorizedSubject.send(true)
            isLoadingSubject.send(false)
        default:
            isAuthorizedSubject.send(false)
            isLoadingSubject.send(false)
        }
    }
}
