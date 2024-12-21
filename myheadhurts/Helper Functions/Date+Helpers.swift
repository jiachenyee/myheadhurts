//
//  Date+Helpers.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/20/24.
//

import Foundation

extension Date {
    var startOfWeek: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var dayOfWeek: Int {
        Calendar.current.component(.weekday, from: self) - 1
    }
    
    var formattedDateOnly: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        
        return formatter.string(from: self)
    }
}
