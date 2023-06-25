//
//  HomeViewController.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 5/28/23.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var btnGuests: UIButton!
    @IBOutlet weak var btnStaff: UIButton!
    @IBOutlet weak var btnReservations: UIButton!
    @IBOutlet weak var btnHistory: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddNewGuest: UIButton!
    @IBOutlet weak var btnAddNewReservation: UIButton!
    @IBOutlet weak var btnAddNewVisit: UIButton!
    @IBOutlet weak var viewReservationDayPicker: UIView!
    @IBOutlet weak var btnLeftResDayPicker: UIButton!
    @IBOutlet weak var viewStaffTypePicker: UIView!
    @IBOutlet weak var btnRightResDayPicker: UIButton!
    @IBOutlet weak var lblDateResDayPicker: UILabel!
    @IBOutlet weak var lblDayResDayPicker: UILabel!
    @IBOutlet weak var btnPromoStaff: UIButton!
    @IBOutlet weak var btnMasterStaff: UIButton!
    @IBOutlet weak var lblPreviousBookingsNotification: UILabel!
    
    
    var currentReservationsDate: Date = Date()
    var dataType: BonitaDataType = .reservations
    var bonitaDataSource: [Any] = []
    var preFilteredDataSource: [Any] = []
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        searchBar.delegate = self
        subscribeToMyNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        refreshTableViewData()
        setPreviousBookingsNotificationIfNeeded()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // ADD
    @IBAction func addNewUser(_ sender: UIButton) {
        pushViewController(vc: .addUser)
    }
    
    @IBAction func addNewReservation(_ sender: UIButton) {
        pushViewController(vc: .addReservation)
    }
    
    @IBAction func addNewVisit(_ sender: UIButton) {
        pushViewController(vc: .addVisit)
    }
    
    // SHOW
    @IBAction func showReservations(_ sender: UIButton) {
        viewReservationDayPicker.isHidden = false
        viewStaffTypePicker.isHidden = true
        dataType = .reservations
        refreshTableViewData()
        setActive(button: sender)
    }
    
    @IBAction func showGuests(_ sender: UIButton) {
        viewReservationDayPicker.isHidden = true
        viewStaffTypePicker.isHidden = true
        dataType = .guests
        refreshTableViewData()
        setActive(button: sender)
    }
    
    @IBAction func showStaff(_ sender: UIButton) {
        viewReservationDayPicker.isHidden = true
        viewStaffTypePicker.isHidden = false
        dataType = .promo
        refreshTableViewData()
        setActive(button: sender)
    }

    
    @IBAction func showHistory(_ sender: UIButton) {
        viewReservationDayPicker.isHidden = true
        viewStaffTypePicker.isHidden = true
        dataType = .history
        refreshTableViewData()
        setActive(button: sender)
    }
    
    @IBAction func showPreviousDayReservations(_ sender: UIButton) {
        if let previousDay = currentReservationsDate.previousDay() {
            currentReservationsDate = previousDay
            showAllReservationsInTableView()
        }
    }
    
    @IBAction func showNextDayReservations(_ sender: UIButton) {
        if let nextDay = currentReservationsDate.nextDay() {
            currentReservationsDate = nextDay
            showAllReservationsInTableView()
        }
    }
    
    @IBAction func showMasterStaff(_ sender: UIButton) {
        dataType = .master
        refreshTableViewData()
        
        btnMasterStaff.backgroundColor = .black
        btnPromoStaff.backgroundColor = Constants.darkGrey
        
        btnMasterStaff.titleLabel?.textColor = Constants.yellowDark
        btnPromoStaff.titleLabel?.textColor = Constants.yellowLight
    }
    
    @IBAction func showPromoStaff(_ sender: UIButton) {
        dataType = .promo
        refreshTableViewData()
        
        btnPromoStaff.backgroundColor = .black
        btnMasterStaff.backgroundColor = Constants.darkGrey
        
        btnPromoStaff.titleLabel?.textColor = Constants.yellowDark
        btnMasterStaff.titleLabel?.textColor = Constants.yellowLight
    }
}

enum BonitaDataType {
    case guests
    case promo
    case master
    case reservations
    case history
}
