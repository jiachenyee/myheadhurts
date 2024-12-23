//
//  myheadhurtsApp.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/18/24.
//

import SwiftUI
import WidgetKit

@main
struct myheadhurtsApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Headache.self)
        .onChange(of: scenePhase) { oldValue, newValue in
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
