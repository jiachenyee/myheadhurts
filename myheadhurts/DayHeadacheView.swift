//
//  DayHeadacheView.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/21/24.
//

import SwiftUI
import SwiftData

struct DayHeadacheView: View {
    
    @Query var headaches: [Headache]
    
    var chartType: Headache.HeadacheTrait?
    
    init(date: Date, chartType: Headache.HeadacheTrait?) {
        let endOfDay = date.addingTimeInterval(24 * 60 * 60)
        self.chartType = chartType
        
        _headaches = Query(filter: #Predicate {
            $0.date >= date && $0.date < endOfDay
        }, sort: \.date, order: .reverse )
    }
    var body: some View {
        ZStack {
            let headaches = headaches.filter { headache in
                if let chartType {
                    return headache.traits.contains(chartType)
                } else {
                    return true
                }
            }
            
            if !headaches.isEmpty {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.accentColor)
                    .opacity(Double(headaches.count) / 12)
                
                Text("\(headaches.count)")
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.primary.opacity(0.1))
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
