//
//  HomeViewController+TableView.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 5/30/23.
//

import UIKit

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bonitaDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch dataType {
        case .history: return getVisitsCell(forRowAt: indexPath)
        case .reservations: return getReservationsCell(forRowAt: indexPath)
        default: return getUsersCell(forRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch dataType {
        case .history: return 107
        case .reservations: return 110
        default: return 81
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch dataType {
        case .guests,  .promo, .master: showUser(indexPath: indexPath)
        case .history: showVisit(indexPath: indexPath)
        case .reservations: showReservation(indexPath: indexPath)
        }
    }
    
    private func getUsersCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersTableViewCell", for: indexPath) as! UsersTableViewCell
        if let user = bonitaDataSource[indexPath.row] as? User {
            cell.setupView(user: user)
        }
        return cell
    }
    
    private func getVisitsCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VisitsTableViewCell", for: indexPath) as! VisitsTableViewCell
        if let visit = bonitaDataSource[indexPath.row] as? Visit {
            cell.setupView(visit: visit)
        }
        return cell
    }
    
    
    private func getReservationsCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReservationsTableViewCell", for: indexPath) as! ReservationsTableViewCell
        if let reservation = bonitaDataSource[indexPath.row] as? Reservation {
            cell.setupView(reservation: reservation)
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        hideKeyboard()
    }
    
    @objc
    func hideKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func showAllGuestsInTableView() {
        if let guests = LocalData.shared.allGuests {
            for guest in guests { guest.populateVisits() }
            bonitaDataSource = guests.sorted(by: { $0.getTotalSum() > $1.getTotalSum() })
            preFilteredDataSource = guests.sorted(by: { $0.getTotalSum() > $1.getTotalSum() })
            tableView.reloadData()
        }
    }
    
    func showAllPromoInTableView() {
        if let guests = LocalData.shared.allPromo {
            for guest in guests { guest.populateVisits() }
            bonitaDataSource = guests.sorted(by: { $0.getTotalSum() > $1.getTotalSum() })
            preFilteredDataSource = guests.sorted(by: { $0.getTotalSum() > $1.getTotalSum() })
            tableView.reloadData()
        }
    }
    
    func showAllMasterInTableView() {
        if var guests = LocalData.shared.allMaster {
            for (index, master) in guests.enumerated() {
                if UserService.shared.isCurrentUser(thisUser: master) {
                    let currentUser = guests.remove(at: index)
                    guests.insert(currentUser, at: 0)
                }
            }
            bonitaDataSource = guests
            preFilteredDataSource = guests
            tableView.reloadData()
        }
    }
    
    func showAllHistoryInTableView() {
        guard
            let allVisits = LocalData.shared.allVisits,
            let currentUser = UserService.shared.currentUser
        else { return }
        var visits: [Visit] = []
        for visit in allVisits {
            if currentUser.type == .master {
                visits.append(visit)
            } else if let visitPromoID = visit.promo?.id, visitPromoID == currentUser.id {
                visits.append(visit)
            }
        }
        bonitaDataSource = visits.sorted(by: { $0.bill?.total ?? 0 > $1.bill?.total ?? 0 })
        preFilteredDataSource = visits.sorted(by: { $0.bill?.total ?? 0 > $1.bill?.total ?? 0 })
        tableView.reloadData()
    }
    
    func showAllReservationsInTableView() {
        guard let allReservations = LocalData.shared.reservations else { return }
        var reservations: [Reservation] = []
        for reservation in allReservations where reservation.isForDate(date: currentReservationsDate) {
            reservations.append(reservation)
        }
        bonitaDataSource = reservations
        preFilteredDataSource = reservations
        tableView.reloadData()
        checkPreviousAndNextDayReservations()
        setupReservationsDayAndDate()
    }


    func refreshTableViewData() {
        switch dataType {
        case .guests: showAllGuestsInTableView()
        case .promo: showAllPromoInTableView()
        case .master: showAllMasterInTableView()
        case .reservations: showAllReservationsInTableView()
        case .history: showAllHistoryInTableView()
        }
        if let searchText = searchBar.text, searchText.count > 0 {
            showSearchResults(searchText: searchText)
        }
        setPreviousBookingsNotificationIfNeeded()
    }
}

