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
    @IBOutlet weak var lblVisits: UILabel!
    @IBOutlet weak var lblFavorite: UILabel!
    var user: User?
    
    func setupView(user: User) {
        self.user = user
        var visitsCount: Int = 0
        let total = user.getTotalSum().formatDigits()
        lblName.text = user.name
        lblVisits.isHidden = true
        
        // Show Visits and Favorites if any
        if let visits = user.visits {
            visitsCount = visits.count
            lblVisits.isHidden = false
            lblVisits.text = "Visits: \(visitsCount) | Total: \(total ?? "0") rsd"
            lblFavorite.text = "Favorite: \(user.favorites().first?.name ?? "")"
        }
        
        // Promo looking at another Promo
        if user.type == .promo,
           UserService.shared.currentUserIsPromo(),
           !UserService.shared.isCurrentUser(thisUser: user) {
            lblVisits.isHidden = true
            lblFavorite.isHidden = true
        }

        // Users looking at their Profile
        if UserService.shared.isCurrentUser(thisUser: user) {
            lblName.text = "\(user.name) (You)"
        }
        
        // Hide favorite for Master
        if user.type == .master {
            lblFavorite.isHidden = true
        }
    }
}
