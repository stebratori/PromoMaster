//
//  LocalData+Reservations.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/27/23.
//

import Foundation

extension LocalData {
    func removeReservation(reservation: Reservation) {
        guard var reservations = reservations else { return }
        for (index, oldReservation) in reservations.enumerated() {
            if oldReservation.id == reservation.id {
                reservations.remove(at: index)
            }
        }
        LocalData.shared.reservations = reservations
    }
    
    func getAllReservationDates() -> [Date]? {
        guard let reservations = LocalData.shared.reservations else { return nil }
        var dates: [Date] = []
        for reservation in reservations {
            if let date = reservation.date.toDate(), !dates.contains(date) {
                dates.append(date)
            }
        }
        return dates.sorted(by: { $0 < $1 })
    }
    
    func getReservationsForDate(date: Date?) -> [Reservation]? {
        guard
            let reservations = LocalData.shared.reservations,
            let date = date
        else { return nil }
        var reservationsForDate: [Reservation] = []
        for reservation in reservations where date.stringDate() == reservation.date {
            reservationsForDate.append(reservation)
        }
        return reservationsForDate
    }
    
    func getReservation(forTable table: String, date: String) -> Reservation? {
        guard let reservations = reservations else { return nil }
        for reservation in reservations {
            if let reservationTable = reservation.table,
               reservationTable == table,
               reservation.date == date {
                return reservation
            }
        }
        return nil
    }
}
