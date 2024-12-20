//
//  LogEntryIntent.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/21/24.
//

import Foundation
import AppIntents

struct LogEntryIntent: AppIntent {
    static var title: LocalizedStringResource = "Log a Headache"
    static var description = IntentDescription("Log a headache episode.")
    
    static var openAppWhenRun: Bool = true
    
    init() {
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        ViewModel.shared.isNewEntrySheetPresented = true
        return .result()
    }
}
