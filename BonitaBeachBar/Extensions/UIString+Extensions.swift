//
//  UIString+Extensions.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 5/30/23.
//

import Foundation

extension String {
    func formatSpecialCharacters() -> String {
        let stringFormatted1: String = self.replacingOccurrences(of: "ć", with: "c")
        let stringFormatted2: String = stringFormatted1.replacingOccurrences(of: "č", with: "c")
        let stringFormatted3: String = stringFormatted2.replacingOccurrences(of: "š", with: "s")
        let stringFormatted4: String = stringFormatted3.replacingOccurrences(of: "ž", with: "z")
        return stringFormatted4
    }
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.date(from:self)
    }
}
