//
//  AddNewUserViewController.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 5/29/23.
//

import UIKit

class UserViewController: UIViewController {
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var btnAddUser: UIButton!
    @IBOutlet weak var btnDeleteUser: UIButton!
    @IBOutlet weak var btnEditUser: UIButton!
    @IBOutlet weak var btnLogOut: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblVisits: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblAverage: UILabel!
    @IBOutlet weak var btnMonthRight: UIButton!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var lblMonthTotal: UILabel!
    @IBOutlet weak var btnFavorites: UIButton!
    @IBOutlet weak var btnMonthLeft: UIButton!
    @IBOutlet weak var btnBookings: UIButton!
    @IBOutlet weak var viewFavoritesLegend: UIView!
    @IBOutlet weak var tapGestureView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblPromoMin: UILabel!
    @IBOutlet weak var lblPin: UILabel!
    @IBOutlet weak var viewAddUser: UIView!
    @IBOutlet weak var viewViewUser: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var segmentControlBackground: UIView!
    @IBOutlet weak var segmentedControlView: UIView!
    @IBOutlet weak var viewPromoMonthly: UIView!
    @IBOutlet weak var txtPromoMin: UITextField!
    var unwindDestinationVC: UIViewController?
    var userStatisticsType: UserStatisticsType = .favorites
    let firebaseService = FirebaseService()
    var type: UserType = .guest
    var readOnly: Bool = false
    var user: User?
    var backToHomeScreen: Bool = true
    var action: AddNewUserAction = .add
    var tableViewDataSource: [Any] = []
    var monthlyVisitDates: [(month: Int, year: Int)] = []
    var currentVisitMonth: (month: Int, year: Int)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = type.getHeaderName()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGestureView.addGestureRecognizer(tapGesture)
        if let user = user, user.type == .promo {
            monthlyVisitDates = user.getVisitMonths()
            currentVisitMonth = monthlyVisitDates.last
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        readOnly ? setupViewReadOnly() : showAddUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !readOnly {
            txtName.becomeFirstResponder()
        }
    }
    
    @IBAction func addUser(_ sender: UIButton) {
        guard let name = txtName.text else { return }
        loader.isHidden = false
        btnAddUser.isEnabled = false
        var userID = UUID().uuidString.lowercased()
        if let existingUserID = user?.id {
            userID = existingUserID
        }
        let newUser = User(id: userID, name: name, type: type)
        var pin: String?
        if type == .promo || type == .master {
            pin = String(Int.random(in: 100000...999999))
            if let existingUserPin = user?.pin {
                pin = String(existingUserPin)
            }
        }
        newUser.pin = pin
        if let email = txtEmail.text {
            newUser.email = email
        }
        if let phone = txtPhone.text {
            newUser.phone = phone
        }
        firebaseService.addUser(user: newUser) { success in
            if success {
                self.firebaseService.realtimeAddUser(user: newUser)
                self.action == .add ?
                LocalData.shared.addUser(user: newUser) :
                LocalData.shared.updateUser(user: newUser)
                if self.unwindDestinationVC is AddNewVisitViewController {
                    self.performSegue(withIdentifier: "unwindToVisit", sender: self)
                    return
                }
                else if self.unwindDestinationVC is ReservationViewController {
                    self.performSegue(withIdentifier: "unwindToReservation", sender: self)
                    return
                } else {
                    self.performSegue(withIdentifier: "addNewUserToHome", sender: self)
                    return
                }
            } else {
                self.loader.isHidden = true
                self.btnAddUser.isEnabled = true
            }
        }
    }
    
    @IBAction func editUser(_ sender: UIButton) {
        showEditUser()
    }
    
    @IBAction func deleteUser(_ sender: UIButton) {
        showPopup(type: .deleteUser)
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        showPopup(type: .logout)
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            type = .guest
            btnAddUser.setTitle("Add Guest", for: .normal)
        case 1:
            type = .promo
            btnAddUser.setTitle("Add Promo", for: .normal)
        case 2:
            type = .master
            btnAddUser.setTitle("Add Master", for: .normal)
        default: break
        }
        self.navigationItem.title = type.getHeaderName()
    }
    
    @IBAction func showFavorites(_ sender: UIButton) {
        showFavoritesSection()
    }
    
    @IBAction func showVisits(_ sender: UIButton) {
        showVisitsSection()
    }
    
    @IBAction func showPrevousoMonthVisits(_ sender: UIButton) {
        showPreviousMonthVisits()
    }
    
    @IBAction func showNextMonthVisits(_ sender: UIButton) {
        showNextMonthVisits()
    }
    
    private func showAddUser() {
        btnDeleteUser.isHidden = true
        btnEditUser.isHidden = true
        viewAddUser.isHidden = false
        viewViewUser.isHidden = true
        btnLogOut.isHidden = true
        viewBottom.isHidden = true
    }
    
    private func showEditUser() {
        btnAddUser.setTitle("Save", for: .normal)
        segmentedControlView.isHidden = true
        btnEditUser.isHidden = true
        btnAddUser.isHidden = false
        viewAddUser.isHidden = false
        viewViewUser.isHidden = true
        action = .edit
    }
}

enum AddNewUserAction {
    case add
    case edit
}

enum UserStatisticsType {
    case favorites
    case bookings
}

