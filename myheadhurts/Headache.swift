//
//  Headache.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/18/24.
//

import Foundation
import SwiftData
import HealthKit

@Model
class Headache: Identifiable {
    
    @Attribute(.unique)
    var id = UUID()
    
    var date: Date
    var severity: HeadacheSeverity
    var notes: String = ""
    
    var nausea: Bool
    var vomiting: Bool
    
    var lightheadedness: Bool = false
    var dizziness: Bool = false
    var collapsed: Bool = false
    
    var headacheHealthKitId: UUID? = nil
    var nauseaHealthKitId: UUID? = nil
    var vomitingHealthKitId: UUID? = nil
    
    var dizzinessHealthKitId: UUID? = nil
    var faintingHealthKitId: UUID? = nil
    
    var traits: [HeadacheTrait] {
        var traits: [HeadacheTrait] = []
        if nausea { traits.append(.nausea) }
        if vomiting { traits.append(.vomiting) }
        if lightheadedness { traits.append(.lightheadedness) }
        if dizziness { traits.append(.dizziness) }
        if collapsed { traits.append(.collapsed) }
        return traits
    }
    
    enum HeadacheTrait: String, Codable, CaseIterable, Hashable {
        case nausea
        case vomiting
        case lightheadedness
        case dizziness
        case collapsed
    }
    
    enum HeadacheSeverity: String, Codable, CaseIterable, Hashable {
        case present
        case mild
        case moderate
        case severe
        
        func toHealthKit() -> HKCategoryValueSeverity {
            switch self {
            case .present: return .unspecified
            case .mild: return .mild
            case .moderate: return .moderate
            case .severe: return .severe
            }
        }
    }
    
    init(id: UUID = UUID(), date: Date,
         severity: HeadacheSeverity,
         notes: String,
         nausea: Bool, vomiting: Bool,
         lightheadedness: Bool,
         dizziness: Bool,
         collapsed: Bool) {
        self.id = id
        self.date = date
        self.severity = severity
        self.notes = notes
        self.nausea = nausea
        self.vomiting = vomiting
        self.lightheadedness = lightheadedness
        self.dizziness = dizziness
        self.collapsed = collapsed
    }
    
#if DEBUG
    static var example: Headache {
        Headache(date: .now, severity: .mild, notes: "", nausea: false, vomiting: false, lightheadedness: false, dizziness: false, collapsed: false)
    }
#endif
}
