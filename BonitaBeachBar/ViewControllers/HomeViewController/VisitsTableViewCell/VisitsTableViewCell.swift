//
//  VisitsTableViewCell.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/8/23.
//

import UIKit

class VisitsTableViewCell: UITableViewCell {
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var lblGuestName: UILabel!
    @IBOutlet weak var lblPromoName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    var visit: Visit?

    func setupView(visit: Visit) {
        background.cornerRadius()
        guard let guest = visit.guest, let bill = visit.bill else { return }
        lblGuestName.text = guest.name
        lblTotal.text =  bill.total.formatDigits()
        lblDate.text = visit.date
        if let promo = visit.promo {
            lblPromoName.text = promo.name
        }
    }
}
