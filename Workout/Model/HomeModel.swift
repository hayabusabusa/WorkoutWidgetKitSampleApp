//
//  HomeModel.swift
//  Workout
//
//  Created by 山田隼也 on 2020/12/14.
//

import Foundation
import HealthKit

protocol HomeModelProtocol: AnyObject {
    var isAuthorized: Bool { get }
    func requestAuthorization()
}

final class HomeModel: HomeModelProtocol {
    
    private let healthStore: HKHealthStore
    
    @Published
    var isAuthorized: Bool = false
    
    init(healthStore: HKHealthStore = HKHealthStore()) {
        self.healthStore = healthStore
    }
    
    func requestAuthorization() {
        let read: Set<HKObjectType> = [HKWorkoutType.workoutType()]
        healthStore.requestAuthorization(toShare: nil, read: read) { [weak self] (isGranted, error) in
            if let error = error {
                print(error)
                return
            }
            self?.isAuthorized = isGranted
        }
    }
}
