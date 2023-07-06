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
    @IBOutlet weak var lblFavorites: UILabel!
    var visit: Visit?

    func setupView(visit: Visit) {
        guard let guest = visit.guest, let bill = visit.bill else { return }
        lblGuestName.text = guest.name
        lblTotal.text =  "Total: \(bill.total.formatDigits() ?? "0") rsd"
        lblDate.text = "Date: \(visit.date)"
        if let promo = visit.promo {
            lblPromoName.text = "Booked by: \(promo.name)"
        }
        var counter = 3
        var favText: String = ""
        for stavka in visit.favorites() {
            if counter > 0 {
                favText += "\(stavka.name) "
                counter -= 1
            } else {
                break
            }
        }
        lblFavorites.text = favText
    }
}
