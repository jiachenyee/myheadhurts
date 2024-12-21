//
//  ViewModel+HealthKit.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/21/24.
//

import Foundation
import HealthKit

extension ViewModel {
    func requestAuthorization() async {
        let data = Set([
            HKObjectType.categoryType(forIdentifier: .headache)!,
            HKObjectType.categoryType(forIdentifier: .nausea)!,
            HKObjectType.categoryType(forIdentifier: .vomiting)!,
            HKObjectType.categoryType(forIdentifier: .dizziness)!,
            HKObjectType.categoryType(forIdentifier: .fainting)!
        ])
        
        guard HKHealthStore.isHealthDataAvailable() else {
            return
        }
        
        try? await healthStore.requestAuthorization(toShare: data, read: data)
    }
    
    func createNewHealthKitRecord(for headache: Headache) async {
        let records = [
            headacheRecord(for: headache),
            presenceRecord(for: headache, category: .nausea),
            presenceRecord(for: headache, category: .vomiting),
            presenceRecord(for: headache, category: .dizziness),
            faintingRecord(for: headache)
        ].compactMap(\.self)
        
        try? await healthStore.save(records)
    }
    
    fileprivate func headacheRecord(for headache: Headache) -> HKCategorySample {
        let categoryType = HKObjectType.categoryType(forIdentifier: .headache)!
        
        let sample = HKCategorySample(type: categoryType,
                                      value: headache.severity.toHealthKit().rawValue,
                                      start: headache.date, end: headache.date)
        
        headache.headacheHealthKitId = sample.uuid
        
        return sample
    }
    
    fileprivate func presenceRecord(for headache: Headache,
                                category categoryType: HKCategoryTypeIdentifier) -> HKCategorySample? {
        
        guard (categoryType == .nausea && headache.nausea) ||
                (categoryType == .vomiting && headache.vomiting) ||
                (categoryType == .dizziness && headache.dizziness) else { return nil }
        
        let sample = HKCategorySample(type: HKObjectType.categoryType(forIdentifier: categoryType)!,
                                      value: HKCategoryValueSeverity.unspecified.rawValue,
                                      start: headache.date, end: headache.date)
        
        switch categoryType {
        case .nausea:
            headache.nauseaHealthKitId = sample.uuid
        case .vomiting:
            headache.vomitingHealthKitId = sample.uuid
        case .dizziness:
            headache.dizzinessHealthKitId = sample.uuid
        default: break
        }
        
        return sample
    }
    
    fileprivate func faintingRecord(for headache: Headache) -> HKCategorySample {
        let categoryType = HKObjectType.categoryType(forIdentifier: .fainting)!
        
        var value = HKCategoryValueSeverity.mild
        
        if headache.collapsed {
            value = .severe
        }
        
        let sample = HKCategorySample(type: categoryType,
                                      value: value.rawValue,
                                      start: headache.date, end: headache.date)
        
        headache.faintingHealthKitId = sample.uuid
        
        return sample
    }
}
