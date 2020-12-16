//
//  WidgetModel.swift
//  WorkoutWidgetExtension
//
//  Created by 山田隼也 on 2020/12/16.
//

import Foundation
import Combine
import HealthKit

protocol WidgetModelProtocol: AnyObject {
    var isAuthorizedPublisher: AnyPublisher<Bool, Never> { get }
    func requestAuthorization()
    func readWorkouts()
}

final class WidgetModel: WidgetModelProtocol {
    
    private let healthStore: HKHealthStore
    
    private let isAuthorizedSubject = PassthroughSubject<Bool, Never>()
    
    var isAuthorizedPublisher: AnyPublisher<Bool, Never>
    
    init(healthStore: HKHealthStore = HKHealthStore()) {
        self.healthStore = healthStore
        self.isAuthorizedPublisher = isAuthorizedSubject.eraseToAnyPublisher()
    }
    
    func requestAuthorization() {
        let status = healthStore.authorizationStatus(for: HKObjectType.workoutType())
        switch status {
        case .notDetermined:
            isAuthorizedSubject.send(false)
        default:
            isAuthorizedSubject.send(true)
        }
    }
    
    func readWorkouts() {
        let type = HKObjectType.workoutType()
        let predicate = HKQuery.predicateForWorkouts(with: .running)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            if let _ = error {
                return
            }
            if let workouts = samples as? [HKWorkout] {
                print(workouts)
            }
        }
        healthStore.execute(query)
    }
}
