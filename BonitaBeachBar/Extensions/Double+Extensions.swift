//
//  Double+Extensions.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/6/23.
//

import Foundation

extension Double {
    func formatDigits() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(for: Int(self))
    }
}
