//
//  myheadhurtswatchApp.swift
//  myheadhurtswatch Watch App
//
//  Created by Jia Chen Yee on 12/23/24.
//

import SwiftUI
import SwiftData

@main
struct myheadhurtswatch_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Headache.self)
        }
    }
}
