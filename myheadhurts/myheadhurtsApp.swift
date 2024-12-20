//
//  myheadhurtsApp.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/18/24.
//

import SwiftUI
import SwiftData

@main
struct myheadhurtsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Headache.self)
    }
}
