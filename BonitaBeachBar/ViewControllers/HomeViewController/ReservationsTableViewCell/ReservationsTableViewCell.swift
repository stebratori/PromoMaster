//
//  ReservationsTableViewCell.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/16/23.
//

import UIKit

class ReservationsTableViewCell: UITableViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var guestName: UILabel!
    @IBOutlet weak var lblTableNumber: UILabel!
    @IBOutlet weak var viewComment: UIView!
    @IBOutlet weak var lblPromoName: UILabel!
    @IBOutlet weak var viewBookedBy: UIView!
    var reservation: Reservation?
    
    func setupView(reservation: Reservation) {
        self.reservation = reservation
        guestName.text = reservation.guest.name
        if let table = reservation.table {
            lblTableNumber.text = table
        }
        if let promo = reservation.promo {
            viewBookedBy.isHidden = false
            lblPromoName.text = promo.name
        } else {
            viewBookedBy.isHidden = true
        }
        if reservation.comment != nil {
            viewComment.isHidden = false
        } else {
            viewComment.isHidden = true
        }
    }
}
