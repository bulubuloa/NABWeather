//
//  Utils.swift
//  NABWeather
//
//  Created by Omnimobile on 2/7/22.
//

import Foundation

struct Utils {
    static func epoch2Date(_ epoch: Double) -> Date {
        return Date(timeIntervalSince1970: epoch)
    }
    
    static func formatDate() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy"
        return dateFormatter
    }
    
    static func diffMins(date1: Date, date2: Date) -> Int? {
        let diffs = Calendar.current.dateComponents([.minute], from: date1, to: date2)
        return diffs.minute
    }
}
