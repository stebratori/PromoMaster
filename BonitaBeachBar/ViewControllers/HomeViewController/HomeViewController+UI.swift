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
        button.backgroundColor = Constants.activeButtonBackground
        button.tintColor = Constants.activeButtonTextColor
        button.titleLabel?.textColor = Constants.activeButtonTextColor
    }
    
    private func resetButtonsUI() {
        btnStaff.backgroundColor = Constants.inactiveButtonBackground
        btnGuests.backgroundColor = Constants.inactiveButtonBackground
        btnHistory.backgroundColor = Constants.inactiveButtonBackground
        btnReservations.backgroundColor = Constants.inactiveButtonBackground
        
        btnStaff.tintColor = Constants.inactiveButtonTextColor
        btnGuests.tintColor = Constants.inactiveButtonTextColor
        btnHistory.tintColor = Constants.inactiveButtonTextColor
        btnReservations.tintColor = Constants.inactiveButtonTextColor
        
        btnStaff.titleLabel?.textColor = Constants.inactiveButtonTextColor
        btnGuests.titleLabel?.textColor = Constants.inactiveButtonTextColor
        btnHistory.titleLabel?.textColor = Constants.inactiveButtonTextColor
        btnReservations.titleLabel?.textColor = Constants.inactiveButtonTextColor
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
            btnAddNewVisit.isHidden = true
            btnAddNewGuest.setTitle("Add Guest", for: .normal)
        }
        setActive(button: btnReservations)
        selectMasterOrPromoTab(sender: btnPromoStaff)
    }
    
    private func setupReservationsDayAndDate() {
        guard let currentReservationsDate = currentReservationsDate else {
            showNoReservations()
            return
        }
        if bonitaDataSource.count > 0, dataType == .reservations {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat  = "EEEE"
            lblDayResDayPicker.isHidden = false
            let dayOfTheWeek = dateFormatter.string(from: currentReservationsDate)
            lblDayResDayPicker.text = "- \(dayOfTheWeek) -"
            var dateString = currentReservationsDate.stringDate()
            if currentReservationsDate.stringDate() == Date().stringDate() {
                dateString += " (Today)"
            }
            else if let nextDay = Date().nextDay(), currentReservationsDate.stringDate() == nextDay.stringDate() {
                dateString += " (Tomorrow)"
            }
            else if let prevtDay = Date().previousDay(), currentReservationsDate.stringDate() == prevtDay.stringDate() {
                dateString += " (Yesterday)"
            }
            lblDateResDayPicker.text = dateString
        }
    }
    
    
    
    func showPreviousDayReservations() {
        guard let allReservationDates = allReservationDates else { return }
        for (index, reservationDate) in allReservationDates.enumerated() {
            if reservationDate.isEqual(toDate: currentReservationsDate), index - 1 >= 0 {
                currentReservationsDate = allReservationDates[index - 1]
                showReservationsForSelectedDate()
                return
            }
        }
        if let reservationDate = allReservationDates.last {
            currentReservationsDate = reservationDate
            showReservationsForSelectedDate()
        }
    }
    
    func showNextDayReservations() {
        guard let allReservationDates = allReservationDates else { return }
        for (index, reservationDate) in allReservationDates.enumerated() {
            if reservationDate.isEqual(toDate: currentReservationsDate), index + 1 < allReservationDates.count {
                currentReservationsDate = allReservationDates[index + 1]
                showReservationsForSelectedDate()
                return
            }
        }
    }
    
    func refreshDataAndShowReservations() {
        guard let allReservations = LocalData.shared.reservations, allReservations.count > 0 else {
            showNoReservations()
            return
        }
        allReservationDates = LocalData.shared.getAllReservationDates()
        if showTodaysReservations {
            currentReservationsDate = Date()
            showReservationsForSelectedDate()
        } else if let currentReservationsDate = currentReservationsDate,
           let reservationDates = allReservationDates,
            reservationDates.contains(currentReservationsDate) {
            showReservationsForSelectedDate()
        } else if let lastReservationDate = allReservationDates?.last {
            currentReservationsDate = lastReservationDate
            showReservationsForSelectedDate()
        }
    }
    
    private func enableOrDisableNextAndPreviousMonthButtons() {
        guard let allReservationDates = allReservationDates else { return }
        var leftBtnEnabled: Bool = false
        var rightBtnEnabled: Bool = false
        for reservationDate in allReservationDates {
            if reservationDate.isEearlier(thanDate: currentReservationsDate) {
                leftBtnEnabled = true
            } else if reservationDate.isLater(thanDate: currentReservationsDate) {
                rightBtnEnabled = true
            }
        }
        btnLeftResDayPicker.isEnabled = leftBtnEnabled
        btnRightResDayPicker.isEnabled = rightBtnEnabled
    }
    
    private func setPreviousBookingsNotificationIfNeeded() {
        guard let reservations = LocalData.shared.reservations else {
            lblPreviousBookingsNotification.isHidden = true
            return
        }
        var notificationCount: Int = 0
        for reservation in reservations where reservation.inThePast() {
            notificationCount += 1
        }
        if notificationCount > 0 {
            lblPreviousBookingsNotification.isHidden = false
            lblPreviousBookingsNotification.text = "\(notificationCount)"
        } else {
            lblPreviousBookingsNotification.isHidden = true
        }
    }
    
    private func showNoReservations() {
        currentReservationsDate = Date()
        bonitaDataSource = []
        preFilteredDataSource = []
        tableView.reloadData()
        currentReservationsDate = nil
        lblDateResDayPicker.text = "No Reservations"
        lblDayResDayPicker.text = "for Today"
        btnLeftResDayPicker.isEnabled = false
        btnRightResDayPicker.isEnabled = false
        lblPreviousBookingsNotification.isHidden = true
    }
    
    private func showReservationsForSelectedDate() {
        var reservations: [Reservation] = []
        if let getReservationsForDate = LocalData.shared.getReservationsForDate(date: currentReservationsDate) {
            reservations = getReservationsForDate
        }
        bonitaDataSource = reservations
        preFilteredDataSource = reservations
        setupReservationsDayAndDate()
        setPreviousBookingsNotificationIfNeeded()
        enableOrDisableNextAndPreviousMonthButtons()
        tableView.reloadData()
    }
}
