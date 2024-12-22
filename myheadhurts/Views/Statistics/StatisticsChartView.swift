//
//  StatisticsChartView.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/20/24.
//

import SwiftUI
import Charts

struct StatisticsChartView: View {
    
    var chartType: Headache.HeadacheTrait?
    
    var thisWeekHeadache: [Headache]
    
    init(thisWeekHeadache: [Headache], chartType: Headache.HeadacheTrait? = nil) {
        self.thisWeekHeadache = thisWeekHeadache
        self.chartType = chartType
        
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.accent
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.label.withAlphaComponent(0.2)
    }
    
    var body: some View {
        NavigationLink {
            StatisticsCalendarView(chartType: chartType)
        } label: {
            VStack {
                HStack {
                    Text(chartType?.rawValue ?? "headaches")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color(.label))
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color(.secondaryLabel))
                }
                
                if let chartShape = getChartShape() {
                    Chart {
                        ForEach(chartShape, id: \.day) { shape in
                            BarMark(
                                x: .value("Day", shape.day),
                                y: .value("\(chartType?.rawValue ?? "Headache") Count", shape.count)
                            )
                        }
                    }
                } else {
                    ContentUnavailableView("no data, thankfully", systemImage: "pencil.and.list.clipboard")
                        .foregroundStyle(Color(.label))
                }
            }
            .padding(.bottom, 48)
            .padding(.horizontal)
        }
    }
    
    func getChartShape() -> [ChartShape]? {
        var chartShapes = [
            ChartShape(day: "sun", count: 0),
            ChartShape(day: "mon", count: 0),
            ChartShape(day: "tue", count: 0),
            ChartShape(day: "wed", count: 0),
            ChartShape(day: "thu", count: 0),
            ChartShape(day: "fri", count: 0),
            ChartShape(day: "sat", count: 0)
        ]
        
        for headache in thisWeekHeadache {
            if let chartType, !headache.traits.contains(chartType) {
                continue
            }
            chartShapes[Calendar.current.component(.weekday, from: headache.date) - 1].count += 1
        }
        
        if chartShapes.allSatisfy({ $0.count == 0 }) {
            return nil
        }
        
        return chartShapes
    }
    
    struct ChartShape: Identifiable {
        var day: String
        var count: Int
        var id = UUID()
    }
}

#Preview {
    StatisticsChartView(thisWeekHeadache: [])
}
