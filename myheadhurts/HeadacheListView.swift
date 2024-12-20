//
//  HeadacheListView.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/18/24.
//

import SwiftUI
import SwiftData

struct HeadacheListView: View {
    
    @Query(sort: \Headache.date, order: .reverse) var headaches: [Headache]
    
    @Environment(\.modelContext) private var modelContext
    
    var dates: [Date] {
        getAllDates()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(dates, id: \.self) { date in
                HeadacheListSectionView(startOfDay: date)
                    .padding(.top, 16)
            }
//            .onDelete { indexSet in
//                for index in indexSet {
//                    modelContext.delete(headaches[index])
//                }
//            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
    
    func getAllDates() -> [Date] {
        var dates = [Date]()
        
        // this is only possible because headaches is sorted
        for headache in headaches {
            let sod = headache.date.startOfDay
            if dates.last != sod {
                dates.append(sod)
            }
        }
        
        return dates
    }
}

#Preview {
    HeadacheListView()
}


