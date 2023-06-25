//
//  UIView+Extensions.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/7/23.
//

import UIKit

extension UIView {
    func cornerRadius() {
        clipsToBounds = true
        layer.cornerRadius = 12
    }
}
