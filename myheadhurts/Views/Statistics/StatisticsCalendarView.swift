//
//  StatisticsCalendarView.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/21/24.
//

import SwiftUI
import SwiftData

struct StatisticsCalendarView: View {
    
    @Query var headaches: [Headache]
    
    static let fetchDescriptor: FetchDescriptor<Headache> = {
        var fetchDescriptor = FetchDescriptor<Headache>()
        
        fetchDescriptor.fetchLimit = 1
        fetchDescriptor.sortBy = [.init(\.date, order: .forward)]
        
        return fetchDescriptor
    }()
    
    @Query(fetchDescriptor) var oldestHeadache: [Headache]
    
    var chartType: Headache.HeadacheTrait?
    
    @State private var width: Double = 0
    
    var body: some View {
        let oldestEntryDate = oldestHeadache.first!.date.startOfDay
        let numberOfDays = oldestEntryDate.distance(to: Date.now.startOfDay) / 86400 + 1
        
        let dates = (-oldestEntryDate.dayOfWeek..<Int(numberOfDays)).map {
            oldestEntryDate.addingTimeInterval(86400 * Double($0))
        }
        
        ScrollView {
            VStack {
                HStack {
                    ForEach(String.daysOfWeek, id: \.self) { day in
                        Text(day)
                            .font(.caption)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                LazyVGrid(columns: .init(repeating: .init(), count: 7)) {
                    ForEach(dates, id: \.self) { date in
                        DayHeadacheView(date: date, chartType: chartType)
                    }
                }
            }
            .onGeometryChange(for: Double.self) { proxy in
                proxy.size.width
            } action: { newValue in
                width = newValue
            }
            .padding()
        }
        .navigationTitle(chartType?.rawValue ?? "headaches")
    }
}
