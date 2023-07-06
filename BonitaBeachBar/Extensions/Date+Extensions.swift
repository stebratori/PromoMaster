//
//  Date+Extensions.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/27/23.
//

import Foundation

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
    
    func isToday() -> Bool {
        let todayDay = Calendar.current.component(.day, from: Date())
        let todayMonth = Calendar.current.component(.month, from: Date())
        let todayYear = Calendar.current.component(.year, from: Date())
        
        let selfDay = Calendar.current.component(.day, from: self)
        let selfMonth = Calendar.current.component(.month, from: self)
        let selfYear = Calendar.current.component(.year, from: self)
        
        return todayDay == selfDay && todayMonth == selfMonth && todayYear == selfYear
    }
    
    func isEqual(toDate date: Date?) -> Bool {
        guard let date = date else { return false }
        let dateDay = Calendar.current.component(.day, from: date)
        let dateMonth = Calendar.current.component(.month, from: date)
        let dateYear = Calendar.current.component(.year, from: date)
        
        let selfDay = Calendar.current.component(.day, from: self)
        let selfMonth = Calendar.current.component(.month, from: self)
        let selfYear = Calendar.current.component(.year, from: self)
        
        return dateDay == selfDay && dateMonth == selfMonth && dateYear == selfYear
    }
    
    func isEearlier(thanDate date: Date?) -> Bool {
        guard let date = date else { return false }
        let dateDay = Calendar.current.component(.day, from: date)
        let dateMonth = Calendar.current.component(.month, from: date)
        let dateYear = Calendar.current.component(.year, from: date)
        
        let selfDay = Calendar.current.component(.day, from: self)
        let selfMonth = Calendar.current.component(.month, from: self)
        let selfYear = Calendar.current.component(.year, from: self)
        
        let sameDay: Bool = dateDay == selfDay && dateMonth == selfMonth && dateYear == selfYear
        return sameDay ? false : date > self
    }
    
    func isLater(thanDate date: Date?) -> Bool {
        guard let date = date else { return false }
        let dateDay = Calendar.current.component(.day, from: date)
        let dateMonth = Calendar.current.component(.month, from: date)
        let dateYear = Calendar.current.component(.year, from: date)
        
        let selfDay = Calendar.current.component(.day, from: self)
        let selfMonth = Calendar.current.component(.month, from: self)
        let selfYear = Calendar.current.component(.year, from: self)
        
        let sameDay: Bool = dateDay == selfDay && dateMonth == selfMonth && dateYear == selfYear
        return sameDay ? false : date < self
    }
}
