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
    @IBOutlet weak var txtTotal: UITextField!
    
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
    var datePickerVisible: Bool = false
    var readOnly: Bool = false
    var tableViewSuggestions: UITableView?
    var tableViewSuggestionsType: TableViewSuggestionsType?
    var tableViewSuggestionsDataSource: [Any] = []
    var tableViewSuggestionsDataSourceFiltered: [Any] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "BillTableViewCell", bundle: nil), forCellReuseIdentifier: "BillTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        if billItems != nil {
            setBill()
        }
        readOnly ? setupViewForReadOnly() : setupTextViewTapRecognisers()
    }
    
    func setupTextViewTapRecognisers() {
        txtGuest.delegate = self
        txtPromo.delegate = self
        txtTable.delegate = self
        txtGuest.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtPromo.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtTable.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func setupViewForReadOnly() {
        guard let visit = visit else { return }
        btnAddBill.isHidden = true
        btnAddPromo.isHidden = true
        viewFooter.isHidden = true
        datePicker.minimumDate = Date()
        if let guestName = visit.guest?.name {
            txtGuest.text = guestName
        }
        if let promoName = visit.promo?.name {
            txtPromo.text = promoName
        }
        datePicker.isHidden = true
        if let total = visit.bill?.total.formatDigits() {
            txtTotal.text = "Total: \(total)"
        }
        if let billItems = visit.bill?.billItems {
            self.billItems = billItems
        }
        tableView.reloadData()
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
        txtTotal.isEnabled = false
        datePicker.backgroundColor = Constants.yellowLight
        tableView.reloadData()
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
    
    @IBAction func addVisit(_ sender: UIButton) {
        loader.isHidden = false
        btnAddVisit.isEnabled = false
        guard
            let billItems = self.billItems,
            let promo = self.promo,
            let guest = self.guest
        else { return }
        let bill = Bill(id: UUID().uuidString.lowercased(),
                        date: datePicker.stringDate(),
                        billItems: billItems,
                        total: getBillTotal())
        let visit = Visit(id: UUID().uuidString.lowercased(),
                      date: datePicker.stringDate(),
                      guest: guest,
                      promo: promo,
                      bill: bill)
        FirebaseService().addVisit(visit: visit) { success in
            if success {
                LocalData.shared.allBills?.append(bill)
                LocalData.shared.allVisits?.append(visit)
                self.performSegue(withIdentifier: "unwindHomeFromVisit", sender: self)
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
        txtPromo.text = "Promoter: \(promo.name)"
        txtPromo.resignFirstResponder()
    }
    
    func setTable(table: Table) {
        self.table = table
        txtTable.text = "Table: \(table.number)"
        txtTable.resignFirstResponder()
    }
    
    func setBill() {
        txtTotal.text = "Total: \(getBillTotal().formatted())"
        btnAddBill.setTitle("Edit Bill", for: .normal)
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
            destinationVC.showAllHistoryInTableView()
        }
    }
}
