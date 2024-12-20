//
//  StatisticsView.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/20/24.
//

import SwiftUI
import SwiftData

struct StatisticsView: View {
    
    @Query var headaches: [Headache]
    
    var thisWeekHeadache: [Headache] {
        headaches.filter { $0.date > .now.startOfWeek }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            VStack {
                TabView {
                    StatisticsChartView(thisWeekHeadache: thisWeekHeadache)
                    StatisticsChartView(thisWeekHeadache: thisWeekHeadache, chartType: .nausea)
                    StatisticsChartView(thisWeekHeadache: thisWeekHeadache, chartType: .vomiting)
                    StatisticsChartView(thisWeekHeadache: thisWeekHeadache, chartType: .lightheadedness)
                    StatisticsChartView(thisWeekHeadache: thisWeekHeadache, chartType: .dizziness)
                    StatisticsChartView(thisWeekHeadache: thisWeekHeadache, chartType: .collapsed)
                }
                .frame(height: 250)
                .tint(.accentColor)
                .tabViewStyle(.page)
                .padding([.top])
            }
            .frame(maxWidth: .infinity)
            .background(Material.thinMaterial)
            .clipShape(.rect(cornerRadius: 8))
            .shadow(color: .black.opacity(0.2), radius: 4)
            
            HStack(spacing: 16) {
                StatisticNumberHighlightView(value: headaches.count,
                                             title: "total")
                
                StatisticNumberHighlightView(value: thisWeekHeadache.count,
                                             title: "this week")
            }
        }
        .padding()
    }
}

#Preview {
    StatisticsView()
}
