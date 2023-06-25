//
//  HomeViewController+UI.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 5/30/23.
//

import UIKit

extension HomeViewController {
    func setActive(button: UIButton) {
        resetButtonsUI()
        button.backgroundColor = .black
        button.tintColor = Constants.yellowLight
    }
    
    private func resetButtonsUI() {
        btnStaff.backgroundColor = Constants.darkGrey
        btnGuests.backgroundColor = Constants.darkGrey
        btnHistory.backgroundColor = Constants.darkGrey
        btnReservations.backgroundColor = Constants.darkGrey
        btnStaff.tintColor = Constants.yellowDark
        btnGuests.tintColor = Constants.yellowDark
        btnHistory.tintColor = Constants.yellowDark
        btnReservations.tintColor = Constants.yellowDark
    }
    
    func setupView() {
        tableView.register(UINib.init(nibName: "UsersTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "UsersTableViewCell")
        tableView.register(UINib.init(nibName: "VisitsTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "VisitsTableViewCell")
        tableView.register(UINib.init(nibName: "ReservationsTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "ReservationsTableViewCell")
        btnStaff.cornerRadius()
        btnGuests.cornerRadius()
        btnHistory.cornerRadius()
        btnReservations.cornerRadius()
        btnAddNewGuest.cornerRadius()
        btnAddNewReservation.cornerRadius()
        btnAddNewVisit.cornerRadius()
        
        btnAddNewGuest.layer.borderColor = Constants.yellowMid.cgColor
        btnAddNewGuest.layer.borderWidth = 1
        btnAddNewReservation.layer.borderColor = Constants.yellowMid.cgColor
        btnAddNewReservation.layer.borderWidth = 1
        btnAddNewVisit.layer.borderColor = Constants.yellowMid.cgColor
        btnAddNewVisit.layer.borderWidth = 1
        
        btnAddNewGuest.titleLabel?.textAlignment = .center
        btnAddNewReservation.titleLabel?.textAlignment = .center
        btnAddNewVisit.titleLabel?.textAlignment = .center
        
        lblPreviousBookingsNotification.layer.cornerRadius = lblPreviousBookingsNotification.frame.size.width / 2
        
        if let currentuser = UserService.shared.currentUser, currentuser.type == .promo {
            btnAddNewReservation.isHidden = true
            btnReservations.isHidden = true
        }
    }
    
    func setupReservationsDayAndDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "EEEE"
        let dayOfTheWeek = dateFormatter.string(from: currentReservationsDate)
        lblDayResDayPicker.text = "- \(dayOfTheWeek) -"
        var dateString = currentReservationsDate.stringDate()
        if currentReservationsDate.stringDate() == Date().stringDate() {
            dateString += " (Today)"
        }
        else if let nextDay = Date().nextDay(), currentReservationsDate.stringDate() == nextDay.stringDate() {
            dateString += " (Tomorrow)"
        }
        lblDateResDayPicker.text = dateString
    }
    
    
    func checkPreviousAndNextDayReservations() {
        var previousDayReservationsExist: Bool = false
        var nextDayReservationsExist: Bool = false
        if let reservations = LocalData.shared.reservations,
           let previousDay = currentReservationsDate.previousDay()?.stringDate(),
           let nextDay = currentReservationsDate.nextDay()?.stringDate() {
            for reservation in reservations {
                if reservation.date == previousDay {
                    previousDayReservationsExist = true
                }
                if reservation.date == nextDay {
                    nextDayReservationsExist = true
                }
            }
        }
        btnLeftResDayPicker.isEnabled = previousDayReservationsExist
        btnRightResDayPicker.isEnabled = nextDayReservationsExist
    }
    
    func setPreviousBookingsNotificationIfNeeded() {
        var notificationCount: Int = 0
        guard let reservations = LocalData.shared.reservations else { return }
        for reservation in reservations where reservation.inThePast() {
            notificationCount += 1
        }
        if notificationCount > 0 {
            lblPreviousBookingsNotification.isHidden = false
            lblPreviousBookingsNotification.text = "\(notificationCount)"
        }
    }
}
