//
//  HeadacheEntry.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/18/24.
//

import Foundation

struct HeadacheEntry: Codable, Identifiable {
    
    var id = UUID()
    
    var date: Date
    var severity: HeadacheSeverity
    var notes: String = ""
    
    var nausea: Bool
    var vomiting: Bool
    
    enum HeadacheSeverity: String, Codable, CaseIterable, Hashable {
        case present
        case mild
        case moderate
        case severe
    }
    
#if DEBUG
    static var example: HeadacheEntry {
        HeadacheEntry(date: .now, severity: .mild, nausea: false, vomiting: false)
    }
#endif
}
