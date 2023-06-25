//
//  GenerateBillViewController.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 6/6/23.
//

import UIKit

class GenerateBillViewController: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtCount: UITextField!
    @IBOutlet weak var btnAddBillItem: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuItemTableView: UITableView!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var btnGenerateBill: UIButton!
    var billItems: [StavkaRacuna] = []
    var menuItems: [MenuItem] = []
    var filteredMenuItems: [MenuItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToMyNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    private func setupView() {
        if let menu = LocalData.shared.menu {
            menuItems = menu
            filteredMenuItems = menu
        }
        txtName.delegate = self
        txtPrice.delegate = self
        txtCount.delegate = self
        btnAddBillItem.cornerRadius()
        btnGenerateBill.cornerRadius()
        txtName.attributedPlaceholder = NSAttributedString(
            string: "Name",
            attributes: [NSAttributedString.Key.foregroundColor: Constants.yellowMid])
        txtPrice.attributedPlaceholder = NSAttributedString(
            string: "Price",
            attributes: [NSAttributedString.Key.foregroundColor: Constants.yellowMid])
        txtCount.attributedPlaceholder = NSAttributedString(
            string: "Amount",
            attributes: [NSAttributedString.Key.foregroundColor: Constants.yellowMid])
        tableView.reloadData()
        menuItemTableView.reloadData()
        menuItemTableView.isHidden = true
        txtName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }


    @IBAction func addBillItem() {
        if billItemDataComplete() {
            addnewBillItem()
        }
    }
    
    @IBAction func generateBill() {
        performSegue(withIdentifier: "unwindFromGenerateBill", sender: self)
    }

    
    func subscribeToMyNotifications() {
        tableView.register(UINib.init(nibName: "BillTableViewCell", bundle: nil), forCellReuseIdentifier: "BillTableViewCell")
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = .zero
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? AddNewVisitViewController {
            destinationVC.billItems = billItems
        }
    }
}


