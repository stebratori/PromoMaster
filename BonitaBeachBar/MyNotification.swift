//
//  MyNotification.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 5/28/23.
//

import Foundation

class MyNotification {
    static func postNotification(name: MyNotificationType) {
        NotificationCenter.default.post(Notification(name: Notification.Name(name.rawValue)))
    }
}

enum MyNotificationType: String {
    // -*- -*- FIREBASE -*- -*- //
    
    // Firebase data fetching
    case firebaseAllUsersFetched
    case firebaseAllVisitsFetched
    case firebaseAllPromosFetched
    case firebaseAllGuestsFetched
    case firebaseAllBillsFetched
    case firebaseAllBillsAndVisitsFetched
    case firebaseAllMastersFetched
    case firebaseAllUsersBillsAndVisitsFetch
    
    // Firebase Data Entry
    case firebaseAddedUser_guest
    case firebaseAddedUser_promo
    case firebaseAddedUser_admin
    case firebaseAddedUser_service
    case firebaseUserAdded
    
    // Firebase Error
    case firebaseFetchingError
    case firebaseAddUserError
    case firebaseAddVisitError
    case firebaseAddBillError
    case firebaseAddMenuItemError
    case firebaseAddReservationError
    case firebaseTablesFetchingError
}
