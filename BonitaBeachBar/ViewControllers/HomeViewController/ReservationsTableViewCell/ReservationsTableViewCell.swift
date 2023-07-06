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
    @IBOutlet weak var lblPromoName: UILabel!
    @IBOutlet weak var viewBookedBy: UIView!
    @IBOutlet weak var imgComment: UIView!
    @IBOutlet weak var imgGetMoney: UIImageView!
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
        if let reservationDate = reservation.date.toDate(),
            reservationDate.isEearlier(thanDate: Date()) {
            imgGetMoney.isHidden = false
            imgComment.isHidden = true
        } else {
            imgGetMoney.isHidden = true
            if let comment = reservation.comment, comment.count > 0 {
                imgComment.isHidden = false
            } else {
                imgComment.isHidden = true
            }
        }
        
    }
}
