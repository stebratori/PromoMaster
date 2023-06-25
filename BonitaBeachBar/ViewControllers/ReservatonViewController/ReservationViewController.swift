//
//  ReservationViewController.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/21/23.
//

import UIKit

class ReservationViewController: UIViewController {
    @IBOutlet weak var txtGuest: UITextField!
    @IBOutlet weak var txtPromo: UITextField!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnGuest: UIButton!
    @IBOutlet weak var btnPromo: UIButton!
    @IBOutlet weak var txtTableNumber: UITextField!
    @IBOutlet weak var txtComment: UITextView!
    @IBOutlet weak var viewComment: UIView!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var btnBookTable: UIButton!
    @IBOutlet weak var viewTap: UIView!
    var reservation: Reservation?
    var editReservation: Bool = false
    private let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var guest: User?
    var promo: User?
    var table: Table?
    var tableViewSuggestions: UITableView?
    var tableViewSuggestionsType: TableViewSuggestionsType?
    var tableViewSuggestionsDataSource: [Any] = []
    var tableViewSuggestionsDataSourceFiltered: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = reservation == nil ? "New Reservation" : "Edit Reservation"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    func setupView() {
        if let reservation = reservation {
            editReservation(reservation: reservation)
        }
        lblDate.cornerRadius()
        viewDate.cornerRadius()
        viewComment.cornerRadius()
        txtComment.cornerRadius()
        btnGuest.cornerRadius()
        btnPromo.cornerRadius()
        txtComment.cornerRadius()
        btnBookTable.cornerRadius()
        txtTableNumber.cornerRadius()
        datePicker.minimumDate = Date()
        
        txtGuest.delegate = self
        txtPromo.delegate = self
        txtTableNumber.delegate = self
        txtGuest.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtPromo.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtTableNumber.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        viewTap.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        viewDate.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        viewComment.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    @objc
    func hideKeyboard() {
        txtGuest.resignFirstResponder()
        txtPromo.resignFirstResponder()
        txtComment.resignFirstResponder()
        txtTableNumber.resignFirstResponder()
        removeSuggestionsTableView()
    }
    
    private func editReservation(reservation: Reservation) {
        if let date = reservation.date.toDate() {
            datePicker.date = date
        }
        if let promo = reservation.promo {
            txtPromo.text = promo.name
            txtPromo.isEnabled = false
            self.promo = reservation.promo
        }
        if let table = reservation.table {
            txtTableNumber.text = table
            self.table = Table(number: table)
        }
        if let comment = reservation.comment {
            txtComment.text = comment
        }
        btnBookTable.setTitle("Edit Booking", for: .normal)
        txtGuest.text = reservation.guest.name
        editReservation = true
        guest = reservation.guest
    }

    @IBAction func actionGuest(_ sender: UIButton) {
        if let vc = storyBoard.instantiateViewController(withIdentifier: "AddUserToVisitViewController") as? AddUserToVisitViewController {
            vc.userType = .guest
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func actionPromo(_ sender: UIButton) {
        if let vc = storyBoard.instantiateViewController(withIdentifier: "AddUserToVisitViewController") as? AddUserToVisitViewController {
            vc.userType = .promo
            self.navigationController?.pushViewController(vc, animated: true)
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
    }
    
    func setTable(table: Table) {
        self.table = table
        txtTableNumber.text = "Table: \(table.number)"
        txtTableNumber.resignFirstResponder()
    }
    
    @IBAction func actionBookTable(_ sender: UIButton) {
        guard let guest = guest else {
            txtGuest.layer.borderColor = UIColor.red.cgColor
            txtGuest.layer.borderWidth = 1
            txtGuest.becomeFirstResponder()
            return
        }
        btnBookTable.isEnabled = false
        loader.isHidden = false
        var reservationID = UUID().uuidString.lowercased()
        var date = datePicker.stringDate()
        if let reservation = reservation {
            reservationID = reservation.id
            date = reservation.date
        }
        let reservation = Reservation(id: reservationID,
                                      date: date,
                                      guest: guest,
                                      promo: promo,
                                      table: txtTableNumber.text,
                                      comment: txtComment.text)
        FirebaseService().addReservation(reservation: reservation) { success in
            if !success {
                self.btnBookTable.isEnabled = true
                self.loader.isHidden = true
            } else {
                self.performSegue(withIdentifier: "unwindHome", sender: self)
            }
        }
    }
    
    @IBAction func unwindToCreateReservation(segue: UIStoryboardSegue) { }
}
