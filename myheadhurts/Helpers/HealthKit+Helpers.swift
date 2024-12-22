//
//  HealthKit+Helpers.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/22/24.
//

import Foundation
import HealthKit

extension HKHealthStore {
    func executeQuery(for sampleType: HKSampleType, limit: Int = 1, from fromDate: Date, to toDate: Date) async throws -> [HKSample] {
        let predicate = HKQuery.predicateForSamples(withStart: fromDate,
                                                    end: toDate,
                                                    options: [])
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(sampleType: sampleType,
                                      predicate: predicate,
                                      limit: limit,
                                      sortDescriptors: nil) { query, sample, error in
                
                if let sample {
                    continuation.resume(returning: sample)
                } else if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: [])
                }
            }
            
            self.execute(query)
        }
    }
}
