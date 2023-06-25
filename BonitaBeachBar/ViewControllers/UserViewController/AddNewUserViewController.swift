//
//  AddNewUserViewController.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 5/29/23.
//

import UIKit

class AddNewUserViewController: UIViewController {
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
    @IBOutlet weak var lblAverage: UILabel!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var btnFavorites: UIButton!
    @IBOutlet weak var btnBookings: UIButton!
    @IBOutlet weak var viewFavoritesLegend: UIView!
    @IBOutlet weak var tapGestureView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblPin: UILabel!
    @IBOutlet weak var viewAddUser: UIView!
    @IBOutlet weak var viewViewUser: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var segmentControlBackground: UIView!
    @IBOutlet weak var segmentedControlView: UIView!
    var unwindDestinationVC: UIViewController?
    var userStatisticsType: UserStatisticsType = .favorites
    
    let firebaseService = FirebaseService()
    var type: UserType = .guest
    var readOnly: Bool = false
    var user: User?
    var backToHomeScreen: Bool = true
    var action: AddNewUserAction = .add
    var tableViewDataSource: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = type.getHeaderName()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGestureView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        readOnly ? setupViewReadOnly() : showAddUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !readOnly { txtName.becomeFirstResponder() }
    }
    
    func setupView() {
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
        btnFavorites.cornerRadius()
        btnBookings.cornerRadius()
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
        btnAddUser.isHidden = true
        viewViewUser.isHidden = false
        viewAddUser.isHidden = true
        UserService.shared.currentUserIsPromo() ? setupViewForPromoViewer() : setupViewForMasterViewer()
        reloadTableViewData(type: .favorites)
    }
    
    private func setupViewForMasterViewer() {
        guard let user = user else { return }
        if UserService.shared.isCurrentUser(thisUser: user) {
            // Master is looking at it's own account
            lblName.text = "\(user.name) (You)"
            btnEditUser.isHidden = false
            btnLogOut.isHidden = false
            btnDeleteUser.isHidden = true
        } else {
            // Master is looking other accounts
            lblName.text = "\(user.name)"
            btnEditUser.isHidden = false
            viewBottom.isHidden = false
            setupStatistics()
        }
    }
    
    private func setupViewForPromoViewer() {
        guard let user = user else { return }
        if UserService.shared.isCurrentUser(thisUser: user) {
            // Promo is looking at it's own profile
            lblName.text = "\(user.name) (You)"
            lblPin.isHidden = false
            viewBottom.isHidden = false
            btnEditUser.isHidden = false
            btnLogOut.isHidden = false
            setupStatistics()
        }
        else if user.type == .promo, !UserService.shared.isCurrentUser(thisUser: user) {
            // Promo is looking at another Promo profile
            lblName.text = user.name
            lblPin.isHidden = true
            viewBottom.isHidden = true
        }
        else {
            // Promo is looking at a Guest profile
            lblName.text = user.name
            lblPin.isHidden = true
            viewBottom.isHidden = false
            btnEditUser.isHidden = false
            setupStatistics()
            if let visitCount = user.visits?.count, visitCount > 0 {
                btnDeleteUser.isHidden = true
            }
        }
    }
    
    private func setupStatistics() {
        guard
            let visitCount = user?.visits?.count,
            let total = user?.getTotalSum(),
            visitCount > 0
        else {
            viewBottom.isHidden = true
            btnDeleteUser.isHidden = false
            return
        }
        btnDeleteUser.isHidden = true
        let average = total / Double(visitCount)
        lblTotal.text = "Total: \(total.formatDigits() ?? "0") rsd"
        lblVisits.text = "Number of visits: \(visitCount)"
        lblAverage.text = "Average: \(average.formatDigits() ?? "0") rsd"
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
                self.action == .add ? LocalData.shared.addUser(user: newUser) : LocalData.shared.updateUser(user: newUser)
                if let unwindVC = self.unwindDestinationVC as? HomeViewController {
                    self.performSegue(withIdentifier: "addNewUserToHome", sender: self)
                    return
                }
                else if let unwindVC = self.unwindDestinationVC as? AddNewVisitViewController {
                    self.performSegue(withIdentifier: "unwindToVisit", sender: self)
                }
                else if let unwindVC = self.unwindDestinationVC as? ReservationViewController {
                    self.performSegue(withIdentifier: "unwindToReservation", sender: self)
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
        setActive(button: sender)
        reloadTableViewData(type: .favorites)
        viewFavoritesLegend.isHidden = false
    }
    
    @IBAction func showVisits(_ sender: UIButton) {
        setActive(button: sender)
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
}

enum AddNewUserAction {
    case add
    case edit
}

enum UserStatisticsType {
    case favorites
    case bookings
}

