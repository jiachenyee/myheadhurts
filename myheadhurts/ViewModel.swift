//
//  ViewModel.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/20/24.
//

import Foundation
import HealthKit

class ViewModel: ObservableObject {
    
    @Published var isNewEntrySheetPresented = false
    
    let healthStore = HKHealthStore()
    
    static let shared = ViewModel()
}
