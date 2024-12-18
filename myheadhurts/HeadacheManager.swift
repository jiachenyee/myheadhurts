//
//  HeadacheManager.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/18/24.
//

import Foundation
import Observation

@Observable
class HeadacheManager {
    private var _headaches: [HeadacheEntry] = [] {
        didSet {
            save()
        }
    }
    
    var headaches: [HeadacheEntry] {
        get {
            _headaches.sorted { $0.date > $1.date }
        }
        set {
            _headaches = newValue
        }
    }
    
    init() {
        load()
    }
    
    private func getArchiveURL() -> URL {
        URL.documentsDirectory.appending(path: "headaches.json")
    }
    
    private func save() {
        let archiveURL = getArchiveURL()
        let jsonEncoder = JSONEncoder()
        
        let encodedHeadaches = try? jsonEncoder.encode(headaches)
        try? encodedHeadaches?.write(to: archiveURL, options: .noFileProtection)
    }
    
    private func load() {
        let archiveURL = getArchiveURL()
        let jsonDecoder = JSONDecoder()
        
        if let retrievedHeadacheData = try? Data(contentsOf: archiveURL),
           let headachesDecoded = try? jsonDecoder.decode([HeadacheEntry].self, from: retrievedHeadacheData) {
            headaches = headachesDecoded
        }
    }
}
