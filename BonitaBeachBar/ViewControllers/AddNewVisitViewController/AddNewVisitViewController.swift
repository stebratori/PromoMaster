//
//  AddNewVisitViewController.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 5/30/23.
//

import UIKit

class AddNewVisitViewController: UIViewController {
    @IBOutlet weak var btnAddBill: UIButton!
    @IBOutlet weak var btnAddPromo: UIButton!
    @IBOutlet weak var btnAddGuest: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtGuest: UITextField!
    @IBOutlet weak var txtPromo: UITextField!
    @IBOutlet weak var txtTable: UITextField!
    @IBOutlet weak var txtComment: UITextView!
    @IBOutlet weak var txtTotal: UITextField!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var viewComment: UIView!
    @IBOutlet weak var viewTap: UIView!
    
    @IBOutlet weak var btnAddVisit: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var viewFooter: UIView!
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var guest: User?
    var promo: User?
    var service: User?
    var bill: Bill?
    var table: Table?
    var billItems: [StavkaRacuna]?
    var visit: Visit?
    var reservation: Reservation?
    var datePickerVisible: Bool = false
    var readOnly: Bool = false
    var tableViewSuggestions: UITableView?
    var tableViewSuggestionsType: TableViewSuggestionsType?
    var tableViewSuggestionsDataSource: [Any] = []
    var tableViewSuggestionsDataSourceFiltered: [Any] = []
    let firebase: FirebaseService = FirebaseService()
    @IBOutlet weak var btnDelete: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTap.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        tableView.register(UINib.init(nibName: "BillTableViewCell", bundle: nil), forCellReuseIdentifier: "BillTableViewCell")
        if let reservation = reservation {
            setupViewForReservation(reservation: reservation)
        } else if readOnly {
             setupViewForReadOnly()
        }
        setupTextViewTapRecognisers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        if billItems != nil {
            setBill()
        }
    }
    
    @objc
    func hideKeyboard() {
        txtGuest.resignFirstResponder()
        txtPromo.resignFirstResponder()
        txtComment.resignFirstResponder()
        txtTable.resignFirstResponder()
        removeSuggestionsTableView()
    }
    
    func setupTextViewTapRecognisers() {
        txtGuest.delegate = self
        txtPromo.delegate = self
        txtTable.delegate = self
        txtComment.delegate = self
        txtGuest.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtPromo.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtTable.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setupView() {
        if let currentUser = UserService.shared.currentUser,
           currentUser.type == .promo {
            setPromo(promo: currentUser)
        }
        btnAddBill.cornerRadius()
        btnAddPromo.cornerRadius()
        btnAddGuest.cornerRadius()
        btnAddVisit.cornerRadius()
        btnAddBill.cornerRadius()
        datePicker.cornerRadius()
        btnDelete.cornerRadius()
        viewComment.cornerRadius()
        txtComment.cornerRadius()
        txtTotal.isEnabled = false
        tableView.reloadData()
    }
    
    func setupViewForReadOnly() {
        guard let visit = visit else { return }
        btnAddBill.isHidden = true
        btnAddPromo.isHidden = true
        btnAddGuest.isHidden = true
        viewFooter.isHidden = true
        txtGuest.isEnabled = false
        txtPromo.isEnabled = false
        txtTable.isEnabled = false
        txtTotal.isEnabled = false
        datePicker.minimumDate = Date()
        
        lblDate.text = "Date: \(visit.date)"
        
        if let guestName = visit.guest?.name {
            txtGuest.text = "Guest: \(guestName)"
        }
        if let promoName = visit.promo?.name {
            txtPromo.text = "Promo: \(promoName)"
        }
        if let table = visit.table?.number {
            txtTable.text = "Table: \(table)"
        }
        datePicker.isHidden = true
        if let total = visit.bill?.total.formatDigits() {
            txtTotal.text = "Total: \(total) rsd"
        }
        if let billItems = visit.bill?.billItems {
            self.billItems = billItems
        }
        tableView.reloadData()
    }
    
    func setupViewForReservation(reservation: Reservation) {
        datePicker.isHidden = true
        lblDate.text = "Date: \(reservation.date)"
        lblDate.textAlignment = .left
        btnDelete.isHidden = false
        if let promo = reservation.promo {
            self.promo = promo
            txtPromo.text = "Promo: \(promo.name)"
            txtPromo.isEnabled = false
            btnAddPromo.isHidden = true
        }
        if let table = reservation.table {
            txtTable.text = "Table: \(table)"
            txtTable.isEnabled = false
        }
        if let comment = reservation.comment {
            txtComment.text = comment
        }
        self.guest = reservation.guest
        txtGuest.text = "Guest: \(reservation.guest.name)"
        txtGuest.isEnabled = false
        btnAddGuest.isHidden = true
    }

    @IBAction func addGuest(_ sender: UIButton) {
        if let vc = storyBoard.instantiateViewController(withIdentifier: "AddUserToVisitViewController") as? AddUserToVisitViewController {
            vc.userType = .guest
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func addPromo(_ sender: UIButton) {
        if let vc = storyBoard.instantiateViewController(withIdentifier: "AddUserToVisitViewController") as? AddUserToVisitViewController {
            vc.userType = .promo
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func addBill(_ sender: UIButton) {
        if let vc = storyBoard.instantiateViewController(withIdentifier: "GenerateBillViewController") as? GenerateBillViewController {
            if let billItems = billItems {
                vc.billItems = billItems
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func actionDelete(_ sender: UIButton) {
        guard let reservation = reservation else { return }
        btnDelete.isEnabled = false
        btnAddVisit.isEnabled = false
        loader.isHidden = false
        firebase.deleteReservation(reservation: reservation) { success in
            self.firebase.realtimeReservationChange()
            self.performSegue(withIdentifier: "unwindHomeFromVisit", sender: self)
        }
    }
    
    @IBAction func addVisit(_ sender: UIButton) {
        loader.isHidden = false
        btnAddVisit.isEnabled = false
        // Check if Guest is added
        guard let guest = guest else {
            txtGuest.layer.borderColor = UIColor.red.cgColor
            txtGuest.layer.borderWidth = 1
            txtGuest.becomeFirstResponder()
            self.loader.isHidden = true
            self.btnAddVisit.isEnabled = true
            return
        }
        
        // Check if Bill Items are added
        guard let billItems = self.billItems else {
            btnAddBill.layer.borderColor = UIColor.red.cgColor
            btnAddBill.layer.borderWidth = 1
            self.loader.isHidden = true
            self.btnAddVisit.isEnabled = true
            return
        }
        
        var tableNumber: String = "-"
        if let table = reservation?.table {
            tableNumber = table
        }
        else if let table = self.table?.number {
            tableNumber = table
        } else {
            txtTable.layer.borderColor = UIColor.red.cgColor
            txtTable.layer.borderWidth = 1
            txtTable.becomeFirstResponder()
            self.loader.isHidden = true
            self.btnAddVisit.isEnabled = true
            return
        }
        let date = reservation?.date ?? datePicker.stringDate()
        let bill = Bill(id: UUID().uuidString.lowercased(),
                        date: date,
                        billItems: billItems,
                        total: getBillTotal())
        var visit = Visit(id: UUID().uuidString.lowercased(),
                      date: date,
                      guest: guest,
                      promo: promo,
                      bill: bill,
                      table: Table(number: tableNumber))
        visit.comment = txtComment.text
        firebase.addVisit(visit: visit) { success in
            if success {
                self.firebase.realtimeVisitIncrease()
                LocalData.shared.allBills?.append(bill)
                LocalData.shared.allVisits?.append(visit)
                if let reservation = self.reservation {
                    self.firebase.deleteReservation(reservation: reservation) { success in
                        self.firebase.realtimeReservationChange()
                        self.performSegue(withIdentifier: "unwindHomeFromVisit", sender: self)
                    }
                } else {
                    self.performSegue(withIdentifier: "unwindHomeFromVisit", sender: self)
                }
            } else {
                self.loader.isHidden = true
                self.btnAddVisit.isEnabled = true
            }
        }
    }
    
    func setGuest(guest: User) {
        self.guest = guest
        txtGuest.text = "Guest: \(guest.name)"
        txtGuest.layer.borderWidth = 0
        txtGuest.resignFirstResponder()
    }
    
    func setPromo(promo: User) {
        self.promo = promo
        txtPromo.text = "Promo: \(promo.name)"
        txtPromo.resignFirstResponder()
        txtPromo.layer.borderWidth = 0
    }
    
    func setTable(table: Table) {
        self.table = table
        txtTable.text = "Table: \(table.number)"
        txtTable.resignFirstResponder()
        txtTable.layer.borderWidth = 0
    }
    
    func setBill() {
        txtTotal.text = "Total: \(getBillTotal().formatted()) rsd"
        btnAddBill.setTitle("Edit Bill", for: .normal)
        btnAddBill.layer.borderWidth = 0
        viewBottom.isHidden = false
    }
    
    func getBillTotal() -> Double {
        if let billItems = self.billItems {
            var total: Double = 0
            for billItem in billItems {
                total += billItem.price * Double(billItem.count)
            }
            return total
        }
        return 0
    }
    
    @IBAction func unwindToAddVisit(segue: UIStoryboardSegue) { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? HomeViewController {
            destinationVC.refreshTableViewData()
        }
    }
}
