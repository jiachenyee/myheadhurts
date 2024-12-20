//
//  ViewModel.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/20/24.
//

import Foundation

class ViewModel: ObservableObject {
    @Published var isNewEntrySheetPresented = false
    
    static let shared = ViewModel()
}
