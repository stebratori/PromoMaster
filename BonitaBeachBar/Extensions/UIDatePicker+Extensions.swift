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


