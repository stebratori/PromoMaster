//
//  UserViewController+UI.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/27/23.
//

import UIKit

extension UserViewController {
    func setupView() {
        if UserService.shared.currentUserIsPromo() {
            segmentControl.isHidden = true
        }
        navigationItem.backButtonTitle = "Back"
        btnAddUser.setTitle("Add \(type.getButtonName())", for: .normal)
        btnAddUser.cornerRadius()
        btnEditUser.setTitle("Edit \(type.getButtonName())", for: .normal)
        btnEditUser.cornerRadius()
        btnDeleteUser.setTitle("Delete \(type.getButtonName())", for: .normal)
        btnDeleteUser.cornerRadius()
        lblName.cornerRadius()
        lblPhone.cornerRadius()
        lblEmail.cornerRadius()
        lblPin.cornerRadius()
        btnLogOut.cornerRadius()
        viewPromoMonthly.isHidden = true
        btnAddUser.isHidden = false
        txtName.attributedPlaceholder = NSAttributedString(
            string: "Name",
            attributes: [NSAttributedString.Key.foregroundColor: Constants.yellowMid])
        txtEmail.attributedPlaceholder = NSAttributedString(
            string: "Email (Optional)",
            attributes: [NSAttributedString.Key.foregroundColor: Constants.yellowMid])
        txtPhone.attributedPlaceholder = NSAttributedString(
            string: "Phone (Optional)",
            attributes: [NSAttributedString.Key.foregroundColor: Constants.yellowMid])
        tableView.register(UINib.init(nibName: "VisitsTableViewCell", bundle: nil), forCellReuseIdentifier: "VisitsTableViewCell")
        tableView.register(UINib.init(nibName: "BillTableViewCell", bundle: nil), forCellReuseIdentifier: "BillTableViewCell")
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        segmentControlBackground.layer.cornerRadius = 8
        if type == .promo {
            btnFavorites.isHidden = true
            btnBookings.isUserInteractionEnabled = false
            viewPromoMonthly.isHidden = false
            txtPromoMin.isHidden = true
        }
        if type == .master {
            viewBottom.isHidden = true
            btnBookings.isUserInteractionEnabled = true
            btnBookings.backgroundColor = .black
            txtPromoMin.isHidden = false
            txtPromoMin.text = "\(Int(LocalData.shared.promoMin))"
        }
        if type == .guest {
            viewPromoMonthly.isHidden = true
            txtPromoMin.isHidden = true
        }
    }
    
    func setupViewReadOnly() {
        guard let user = user else { return }
        txtName.text = user.name
        if let email = user.email, email.count > 0 {
            txtEmail.text = email
            lblEmail.text = email
        } else {
            lblEmail.text = "No Email"
        }
        if let phone = user.phone, phone.count > 0 {
            txtPhone.text = phone
            lblPhone.text = phone
        } else {
            lblPhone.text = "No Phone"
        }
        if let pin = user.pinFormatted(), user.type != .guest {
            lblPin.text = "Pin: \(pin)"
            lblPin.isHidden = false
        }
        if let promoMin = LocalData.shared.promoMin.formatDigits() {
            lblPromoMin.text = "Promo min: \(promoMin)"
        }
        btnAddUser.isHidden = true
        viewViewUser.isHidden = false
        viewAddUser.isHidden = true
        UserService.shared.currentUserIsPromo() ?
        setupViewForPromoViewer() :
        setupViewForMasterViewer()
    }
    
    private func setupViewForMasterViewer() {
        guard let user = user else { return }
        if UserService.shared.isCurrentUser(thisUser: user) {
            // Master is looking at it's own account
            lblName.text = "\(user.name) (You)"
            btnEditUser.isHidden = false
            btnLogOut.isHidden = false
            btnDeleteUser.isHidden = true
            lblPromoMin.isHidden = false
            txtPromoMin.isHidden = false
            viewBottom.isHidden = true
        } else {
            // Master is looking other accounts
            lblName.text = "\(user.name)"
            btnEditUser.isHidden = false
            viewBottom.isHidden = false
            if user.type == .promo {
                showVisitsSection()
                lblPromoMin.isHidden = false
            } else if user.type == .guest {
                showFavoritesSection()
                lblPromoMin.isHidden = true
                lblPin.isHidden = true
                viewPromoMonthly.isHidden = true
            }
            setupStatistics()
            showAllVisitsAboveMinimumForSelectedMonth()
        }
    }
    
    private func setupViewForPromoViewer() {
        guard let user = user else { return }
        lblName.text = user.name
        txtPromoMin.isHidden = true
        lblPromoMin.isHidden = false
        if UserService.shared.isCurrentUser(thisUser: user) {
            // Promo is looking at it's own profile
            userStatisticsType = .bookings
            lblName.text = "\(user.name) (You)"
            lblPin.isHidden = false
            viewBottom.isHidden = false
            btnEditUser.isHidden = false
            btnLogOut.isHidden = false
            viewFavoritesLegend.isHidden = true
            lblPromoMin.isHidden = false
            showAllVisitsAboveMinimumForSelectedMonth()
            setupStatistics()
        }
        else if user.type == .promo, !UserService.shared.isCurrentUser(thisUser: user) {
            // Promo is looking at another Promo profile
            lblPin.isHidden = true
            viewBottom.isHidden = true
            lblPromoMin.isHidden = true
            lblPin.isHidden = true
            btnDeleteUser.isHidden = true
        }
        // Promo looking at Master
        else if user.type == .master {
            btnBookings.isHidden = true
            btnFavorites.isHidden = true
            btnLogOut.isHidden = true
            btnAddUser.isHidden = true
            btnEditUser.isHidden = true
            btnDeleteUser.isHidden = true
            lblPin.isHidden = true
            lblPromoMin.isHidden = true
        }
        else {
            // Promo is looking at a Guest profile
            lblPin.isHidden = true
            viewBottom.isHidden = false
            btnEditUser.isHidden = false
            viewPromoMonthly.isHidden = true
            lblPromoMin.isHidden = true
            lblPin.isHidden = true
            setupStatistics()
            if let visitCount = user.visits?.count, visitCount > 0 {
                btnDeleteUser.isHidden = true
            }
        }
    }
    
    func showFavoritesSection() {
        setActive(button: btnFavorites)
        reloadTableViewData(type: .favorites)
        viewPromoMonthly.isHidden = true
        viewFavoritesLegend.isHidden = false
    }
    
    func showVisitsSection() {
        setActive(button: btnBookings)
        reloadTableViewData(type: .bookings)
        viewFavoritesLegend.isHidden = true
    }
    private func setActive(button: UIButton) {
        resetButtonsUI()
        button.backgroundColor = .black
        button.tintColor = Constants.yellowLight
    }
    
    private func resetButtonsUI() {
        btnFavorites.backgroundColor = .darkGray
        btnBookings.backgroundColor = .darkGray
        btnFavorites.tintColor = .darkGray
        btnBookings.tintColor = .darkGray
    }
    
    private func setupStatistics() {
        guard
            let visitCount = user?.getTotalVisitAboveMinCount(),
            let total = user?.getTotalSum(),
            visitCount > 0
        else {
            viewBottom.isHidden = true
            btnDeleteUser.isHidden = false
            return
        }
        btnDeleteUser.isHidden = true
        let average = total / Double(visitCount)
        lblTotal.text = "Total:\n \(total.formatDigits() ?? "0") rsd"
        lblVisits.text = "Visits:\n \(visitCount)"
        lblAverage.text = "Average:\n \(average.formatDigits() ?? "0") rsd"
    }
    
    func showAllVisitsAboveMinimumForSelectedMonth() {
        guard
            let currentVisitMonth = currentVisitMonth,
            let user = user
        else { return }
        let selectedMonthVisits = user.getAllVisitsForMonthAboveMin(month: currentVisitMonth.month,
                                                                    year: currentVisitMonth.year)
        let monthTotal = user.getMonthlySum(month: currentVisitMonth.month, year: currentVisitMonth.year)
        lblMonth.text = "- \(currentVisitMonth.month.getMonthName()) \(currentVisitMonth.year) -"
        lblMonthTotal.text = "Month Total: \(monthTotal.formatDigits() ?? "0") rsd"
        tableViewDataSource.removeAll()
        tableViewDataSource = selectedMonthVisits
        tableView.reloadData()
        if user.type != .promo {
            viewPromoMonthly.isHidden = true
        }
        enableOrDisableNextAndPreviousMonthButtons()
    }
    
    func showPreviousMonthVisits() {
        guard
            let visitMonths = user?.getVisitMonths(),
            let currentVisitMonth = currentVisitMonth
        else { return }
        for (index, month) in visitMonths.enumerated() {
            if month.month == currentVisitMonth.month && month.year == currentVisitMonth.year {
                if index != 0 {
                    self.currentVisitMonth = visitMonths[index-1]
                    showAllVisitsAboveMinimumForSelectedMonth()
                }
            }
        }
    }
    
    func showNextMonthVisits() {
        guard
            let visitMonths = user?.getVisitMonths(),
            let currentVisitMonth = currentVisitMonth
        else { return }
        for (index, month) in visitMonths.enumerated() {
            if month.month == currentVisitMonth.month && month.year == currentVisitMonth.year {
                if index + 1 < visitMonths.count {
                    self.currentVisitMonth = visitMonths[index+1]
                    showAllVisitsAboveMinimumForSelectedMonth()
                }
            }
        }
    }
    
    private func enableOrDisableNextAndPreviousMonthButtons() {
        guard
            let visitMonths = user?.getVisitMonths(),
            let currentVisitMonth = currentVisitMonth
        else { return }
        for (index, month) in visitMonths.enumerated() {
            if month.month == currentVisitMonth.month && month.year == currentVisitMonth.year {
                if index + 1 < visitMonths.count {
                    btnMonthRight.isEnabled = true
                } else {
                    btnMonthRight.isEnabled = false
                }
                if index != 0 {
                    btnMonthLeft.isEnabled = true
                } else {
                    btnMonthLeft.isEnabled = false
                }
            }
        }
    }
}
