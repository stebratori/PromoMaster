//
//  UsersTableViewCell.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/8/23.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSubtext: UILabel!
    var user: User?
    
    func setupView(user: User) {
        background.cornerRadius()
        self.user = user
        var visitsCount: Int = 0
        let total = user.getTotalSum().formatDigits()
        lblName.text = user.name
        if let visits = user.visits {
            visitsCount = visits.count
        }
        if user.type == .promo,
           UserService.shared.currentUserIsPromo(),
           !UserService.shared.isCurrentUser(thisUser: user) {
            lblSubtext.isHidden = true
        } else {
            lblSubtext.isHidden = false
            lblSubtext.text = "Broj poseta: \(visitsCount)  |  Total: \(total ?? "0")"
        }
        if UserService.shared.isCurrentUser(thisUser: user) {
            lblName.text = "\(user.name) (You)"
        }
    }
}
