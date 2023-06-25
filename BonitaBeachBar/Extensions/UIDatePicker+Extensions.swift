//
//  UIDatePicker+Extensions.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/21/23.
//

import UIKit

extension UIDatePicker {
    func stringDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
}

extension Date {
    func stringDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: self)
    }
    
    func previousDay() -> Date? {
        var dayComponent = DateComponents()
        dayComponent.day = -1
        let theCalendar = Calendar.current
        let nextDate = theCalendar.date(byAdding: dayComponent, to: self)
        return nextDate
    }
    
    func nextDay() -> Date? {
        var dayComponent = DateComponents()
        dayComponent.day = 1
        let theCalendar = Calendar.current
        let nextDate = theCalendar.date(byAdding: dayComponent, to: self)
        return nextDate
    }
}
