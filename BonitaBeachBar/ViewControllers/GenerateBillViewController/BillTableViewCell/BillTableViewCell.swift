//
//  BillTableViewCell.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/6/23.
//

import UIKit

class BillTableViewCell: UITableViewCell {
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var total: UILabel!
    
    func setupCell(item: StavkaRacuna, row: Int) {
        name.text = item.name
        count.text = "\(item.count)"
        if let priceFormatted = item.price.formatDigits() {
            price.text = priceFormatted
            total.text = (item.price * Double(item.count)).formatDigits()
        }
        if row % 2 == 0 {
            background.backgroundColor = Constants.yellowLight
        } else {
            background.backgroundColor = Constants.yellowMid
        }
    }
}
