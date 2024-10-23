//
//  File.swift
//  DateWheelPicker
//
//  Created by Evgeniy Kugut on 24.10.2024.
//

import Foundation

extension Date {

    static func from(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date? {
        guard let calendar = NSCalendar(calendarIdentifier: .gregorian) else {
            return nil
        }

        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second

        return calendar.date(from: dateComponents)
    }

    static func lastDay(forYear year: Int, month: Int) -> Int? {
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: year, month: month)
        if let date = calendar.date(from: dateComponents),
           let range = calendar.range(of: .day, in: .month, for: date) {
            return range.count
        }
        return nil
    }

    var year: Int {
        Calendar.current.dateComponents([.year], from: self).year!
    }

    var month: Int {
        Calendar.current.dateComponents([.month], from: self).month!
    }

    var day: Int {
        Calendar.current.dateComponents([.day], from: self).day!
    }

    var hour: Int {
        Calendar.current.dateComponents([.hour], from: self).hour!
    }

    var minute: Int {
        Calendar.current.dateComponents([.minute], from: self).minute!
    }

    var second: Int {
        Calendar.current.dateComponents([.second], from: self).second!
    }

}
