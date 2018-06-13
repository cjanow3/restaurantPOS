//
//  Cell_ViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 5/20/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CellViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if orderInQuestion.getPickup() {
            return pickupvendorslist.count
        } else {
            return deliveryvendorslist.count
        }
    }
    
    //
    // Returns value that will be displayed in the picker view
    //
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if orderInQuestion.getPickup() {
            return pickupvendorslist[row].getName()
        } else{
            return deliveryvendorslist[row].getName()
        }
        
    }
    
    
    //
    // Tableview functions and variables
    //
    
    var editWhat = 0
    var editTF: UITextField?

    
    //
    // Return 9 for delivery orders and 7 for pickup
    //
    
    
    @IBOutlet weak var returnButton: UIButton!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if orderInQuestion.getPickup() {
            return 6
        } else {
            return 8
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryFieldCell", for: indexPath) as! entryFieldTableViewCell
        
        //
        // Delivery = address,vendor,notes,price,df,tip,refund,cash
        // Pickup   = vendor,notes,price,tip,refund,cash
        //
        
        if orderInQuestion.getPickup() {
            switch indexPath.row {
                
                case 0:
                    cell.entryLabel.text = orderInQuestion.getVendor()
                    cell.fieldLabel.text = "Vendor"

                case 1:
                    cell.entryLabel.text = String(format: "%.2f", orderInQuestion.getPrice())
                    cell.fieldLabel.text = "Price"

                case 2:
                    cell.entryLabel.text = String(format: "%.2f", orderInQuestion.getTip())
                    cell.fieldLabel.text = "Tip"

                case 3:
                    cell.entryLabel.text = String(format: "%.2f", orderInQuestion.getRefund())
                    cell.fieldLabel.text = "Refund"

                case 4:
                    cell.entryLabel.text = orderInQuestion.getCashCreditString()
                    cell.fieldLabel.text = "Cash/Credit"

                case 5:
                    let tempNotes = orderInQuestion.getNotes().prefix(18) + "..."
                    cell.entryLabel.text = String(tempNotes)
                    cell.fieldLabel.text = "Notes"

                default:
                    cell.entryLabel.text = "nil"
                    cell.fieldLabel.text = "nil"

                }
            
        } else {
            
            switch indexPath.row {
                
                case 0:
                    cell.entryLabel.text = orderInQuestion.getAddress()
                    cell.fieldLabel.text = "Address"

                case 1:
                    cell.entryLabel.text = orderInQuestion.getVendor()
                    cell.fieldLabel.text = "Vendor"

                case 2:
                    cell.entryLabel.text = String(format: "%.2f", orderInQuestion.getPrice())
                    cell.fieldLabel.text = "Price"

                case 3:
                    cell.entryLabel.text = String(format: "%.2f", orderInQuestion.getTip())
                    cell.fieldLabel.text = "Tip"

                case 4:
                    cell.entryLabel.text = String(format: "%.2f", orderInQuestion.getDeliveryFee())
                    cell.fieldLabel.text = "Delivery Fee"

                case 5:
                    cell.entryLabel.text = String(format: "%.2f", orderInQuestion.getRefund())
                    cell.fieldLabel.text = "Refund"

                case 6:
                    cell.entryLabel.text = orderInQuestion.getCashCreditString()
                    cell.fieldLabel.text = "Cash/Credit"

                case 7:
                    let tempNotes = orderInQuestion.getNotes().prefix(18) + "..."
                    cell.entryLabel.text = String(tempNotes)
                    cell.fieldLabel.text = "Notes"
                default:
                    cell.entryLabel.text = "nil"
                    cell.fieldLabel.text = "nil"

                }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        //
        // Creates a UIAlert with detailed view of field
        //
        
        if self.orderInQuestion.getPickup() {
            switch indexPath.row {
            case 0:
                self.createSimpleAlert(title: "Vendor", message: self.orderInQuestion.getVendor())
                
            case 1:
                self.createSimpleAlert(title: "Price", message: String(format: "%.2f", orderInQuestion.getPrice()))
                
            case 2:
                self.createSimpleAlert(title: "Tip", message: String(format: "%.2f", orderInQuestion.getTip()))
                
            case 3:
                self.createSimpleAlert(title: "Refund", message: String(format: "%.2f", orderInQuestion.getRefund()))
                
            case 4:
                self.createSimpleAlert(title: "Cash/Credit", message: self.orderInQuestion.getCashCreditString())
                
            case 5:
                self.createSimpleAlert(title: "Notes", message: self.orderInQuestion.getNotes())
                
            default:
                break
                
                
            }
        } else {
            switch indexPath.row {
            case 0:
                self.createSimpleAlert(title: "Address", message: self.orderInQuestion.getAddress())
                
            case 1:
                self.createSimpleAlert(title: "Vendor", message: self.orderInQuestion.getVendor())
                
            case 2:
                self.createSimpleAlert(title: "Price", message: String(format: "%.2f", orderInQuestion.getPrice()))
                
            case 3:
                self.createSimpleAlert(title: "Tip", message: String(format: "%.2f", orderInQuestion.getTip()))
                
            case 4:
                self.createSimpleAlert(title: "Delivery Fee", message: String(format: "%.2f", orderInQuestion.getDeliveryFee()))
                
            case 5:
                self.createSimpleAlert(title: "Refund", message: String(format: "%.2f", orderInQuestion.getRefund()))
                
            case 6:
                self.createSimpleAlert(title: "Cash/Credit", message: self.orderInQuestion.getCashCreditString())
                
            case 7:
                self.createSimpleAlert(title: "Notes", message: self.orderInQuestion.getNotes())
                
            default:
                break
            }
        }
    }

    

    @IBOutlet weak var name: UILabel!

    var cPickup:Bool?
    var cCash:Bool?
    
    var cTip:Double?
    var cDeliveryFee:Double?
    var cPrice:Double?
    var cRefund:Double?
    
    var pickupvendorslist = [newVendor]()
    var deliveryvendorslist = [newVendor]()
    var orderslist = [newOrder]()
    var orderInQuestion = newOrder()
    var orderIndex = 0
    
    var ref:DatabaseReference!
    var uid:String = ""

    @IBAction func backtomainmenu(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //
    // Alert function
    //
    
    func createSimpleAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    //
    //used to dismiss keyboards
    //
    
    @objc func doneClicked() {
        view.endEditing(true)
    }

    
    //
    // Grabs all pickup vendors from FirebaseDatabase
    //

    func getPickupVendors() {
        
        self.pickupvendorslist.removeAll()
        
        ref.child("vendors").child("pickup vendors").observe(.childAdded, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                let isAPickupVendor = dictionary["pickup"] as! Bool
                
                //
                // Determine if vendor is a pickup vendor
                //
                
                if (isAPickupVendor) {
                    let vendor = newVendor()
                    
                    vendor.name = dictionary["name"] as? String
                    vendor.cash = dictionary["cash"] as? Double
                    vendor.credit = dictionary["credit"] as? Double
                    vendor.total = dictionary["total"] as? Double
                    vendor.num = dictionary["num"] as? Int
                    vendor.refund = dictionary["refund"] as? Double
                    vendor.pickup = dictionary["pickup"] as! Bool
                    
                    var beenAdded = false
                    
                    for v in self.pickupvendorslist {
                        if v.getName() == vendor.getName() {
                            beenAdded = true
                        }
                    }
                    
                    if (!beenAdded) {
                        self.pickupvendorslist.append(vendor)
                    }
                }
            }
        })
    } //end getPickupVendors
    
    //
    // Grabs all delivery vendors from FirebaseDatabase
    //
    
    func getDeliveryVendors(){
        
        self.deliveryvendorslist.removeAll()
        
        ref.child("vendors").child("delivery vendors").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                let isAPickupVendor = dictionary["pickup"] as! Bool
                
                //
                // Determine if vendor is a delivery vendor
                //
                
                if (!isAPickupVendor) {
                    let vendor = newVendor()
                    
                    vendor.name = dictionary["name"] as? String
                    vendor.cash = dictionary["cash"] as? Double
                    vendor.credit = dictionary["credit"] as? Double
                    vendor.total = dictionary["total"] as? Double
                    vendor.num = dictionary["num"] as? Int
                    vendor.refund = dictionary["refund"] as? Double
                    vendor.pickup = dictionary["pickup"] as! Bool
                    
                    //
                    // Determines if item has already been added to the array
                    //

                    var beenAdded = false
                    for v in self.deliveryvendorslist {
                        if v.getName() == vendor.getName() {
                            beenAdded = true
                        }
                    }
                    
                    if (!beenAdded) {
                        self.deliveryvendorslist.append(vendor)
                    } else {
                        
                    }
                }
                
            }
            
        })
        
        
    } //end getDeliveryVendors
    
    //
    // Set up design for VC
    //
    
    func initView() {
        returnButton.layer.cornerRadius = 10
        returnButton.layer.masksToBounds = true
        returnButton.layer.borderColor = UIColor.black.cgColor
        returnButton.layer.borderWidth = 0.5
        returnButton.layer.shadowColor = UIColor.black.cgColor
        returnButton.layer.shadowOffset = CGSize.zero
        returnButton.layer.shadowRadius = 5.0
        returnButton.layer.shadowOpacity = 0.5
        returnButton.clipsToBounds = false
        
        let strokeTextAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.strokeColor : UIColor.black,
            NSAttributedStringKey.foregroundColor : UIColor.white,
            NSAttributedStringKey.strokeWidth : -2.0,
            ]
        
        name.attributedText = NSAttributedString(string: orderInQuestion.getName(), attributes: strokeTextAttributes)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //
        // Database reference
        //
        
        ref = Database.database().reference().child("users").child(uid)

        
        orderInQuestion = orderslist[orderIndex]
        
        //
        // Prepare vendor for edit view
        //
        
        if (orderInQuestion.getPickup()) {
            getPickupVendors()
        } else {
            getDeliveryVendors()
        }

        initView()

        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        //
        // Set editWhat to row that was swiped
        //
        
        editWhat = editActionsForRowAt.row
 
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            
            //
            // Creates a UIAlert with detailed view of field
            //
            
            if self.orderInQuestion.getPickup() {
                switch editActionsForRowAt.row {
                case 0:
                    self.createAlertEditSomething(Title: "Edit Vendor")
                    
                case 1:
                    self.createAlertEditSomething(Title: "Edit Price")
                    
                case 2:
                    self.createAlertEditSomething(Title: "Edit Tip")

                case 3:
                    self.createAlertEditSomething(Title: "Edit Refund")

                case 4:
                    self.createAlertEditSomething(Title: "Edit Cash/Credit")

                case 5:
                    self.createAlertEditSomething(Title: "Edit Notes")

                default:
                    break
                    
                    
                }
            } else {
                switch editActionsForRowAt.row {
                case 0:
                    self.createAlertEditSomething(Title: "Edit Address")

                case 1:
                    self.createAlertEditSomething(Title: "Edit Vendor")

                case 2:
                    self.createAlertEditSomething(Title: "Edit Price")

                case 3:
                    self.createAlertEditSomething(Title: "Edit Tip")

                case 4:
                    self.createAlertEditSomething(Title: "Edit Delivery Fee")

                case 5:
                    self.createAlertEditSomething(Title: "Edit Refund")

                case 6:
                    self.createAlertEditSomething(Title: "Edit Cash/Credit")

                case 7:
                    self.createAlertEditSomething(Title: "Edit Notes")

                default:
                    break
                }
            }

            
        }
        
        edit.backgroundColor = .orange
    
        return [edit]
    }
    
    func editFieldSetup(textfield: UITextField!) {
        editTF = textfield
        
        if orderInQuestion.getPickup() {
            switch editWhat{
            case 0:
                editTF?.text! = orderInQuestion.getVendor()

            case 1:
                editTF?.text! = String(format: "%.2f", orderInQuestion.getPrice())
                editTF?.keyboardType = .decimalPad
                
            case 2:
                editTF?.text! = String(format: "%.2f", orderInQuestion.getTip())
                editTF?.keyboardType = .decimalPad

                
            case 3:
                editTF?.text! = String(format: "%.2f", orderInQuestion.getRefund())
                editTF?.keyboardType = .decimalPad

                
            case 4:
                editTF?.text! = orderInQuestion.getCashCreditString()

                
            case 5:
                editTF?.text! = orderInQuestion.getNotes()

                
            default:
                editTF?.text! = "nil"
                
            }
        } else {
            switch editWhat {
            case 0:
                editTF?.text! = orderInQuestion.getAddress()

                
            case 1:
                editTF?.text! = orderInQuestion.getVendor()

                
            case 2:
                editTF?.text! = String(format: "%.2f", orderInQuestion.getPrice())
                editTF?.keyboardType = .decimalPad

                
            case 3:
                editTF?.text! = String(format: "%.2f", orderInQuestion.getTip())
                editTF?.keyboardType = .decimalPad

                
            case 4:
                editTF?.text! = String(format: "%.2f", orderInQuestion.getDeliveryFee())
                editTF?.keyboardType = .decimalPad

                
            case 5:
                editTF?.text! = String(format: "%.2f", orderInQuestion.getRefund())
                editTF?.keyboardType = .decimalPad

                
            case 6:
                editTF?.text! = orderInQuestion.getCashCreditString()

                
            case 7:
                editTF?.text! = orderInQuestion.getNotes()

            default:
                editTF?.text! = "nil"
                
            }
        }
        
    }

    //
    // Functions used to update Firebase
    //
    
    func updateCashCreditInDatabase(isCash: Bool) {
        
        let id = orderInQuestion.getID()
        
        ref.child("orders").child(id).child("cash").setValue(isCash)
        
        self.createSimpleAlert(title: "Change Made", message: "Cash/Credit saved to '" + self.orderInQuestion.getCashCreditString() + "'")
        
    }
    
    func updateAddressInDatabase(newAddress: String) {
        
        let id = orderInQuestion.getID()
        
        ref.child("orders").child(id).child("address").setValue(newAddress)
        
        self.createSimpleAlert(title: "Change Made", message: "Address saved to '" + newAddress + "'")
    }
    
    func updateVendorInDatabase(newVendor: String) {
        
        let id = orderInQuestion.getID()
        
        ref.child("orders").child(id).child("vendor").setValue(newVendor)
        
        self.createSimpleAlert(title: "Change Made", message: "Vendor saved to '" + newVendor + "'")
    }
    
    func updateDeliveryFeeInDatabase(newDF: Double) {
        
        let id = orderInQuestion.getID()
        
        ref.child("orders").child(id).child("delivery fee").setValue(newDF)
        
        self.createSimpleAlert(title: "Change Made", message: "Delivery Fee saved to '" + newDF.description + "'")
    }
    
    func updateNameInDatabase(newName: String) {
        
        let id = orderInQuestion.getID()
        
        ref.child("orders").child(id).child("name").setValue(newName)
        
        self.createSimpleAlert(title: "Change Made", message: "Name saved to '" + newName + "'")
    }
    
    func updateNotesInDatabase(newNotes: String) {
        
        let id = orderInQuestion.getID()
        
        ref.child("orders").child(id).child("notes").setValue(newNotes)
        
        self.createSimpleAlert(title: "Change Made", message: "Notes saved to '" + newNotes + "'")
    }
    
    func updateRefundInDatabase(newRefund: Double) {
        
        let id = orderInQuestion.getID()
        
        ref.child("orders").child(id).child("refund").setValue(newRefund)
        
        self.createSimpleAlert(title: "Change Made", message: "Refund saved to '" + newRefund.description + "'")
    }
    
    func updateTipInDatabase(newTip: Double) {
        
        let id = orderInQuestion.getID()
        
        ref.child("orders").child(id).child("tip").setValue(newTip)
        
        self.createSimpleAlert(title: "Change Made", message: "Tip saved to '" + newTip.description + "'")
    }
    
    func updatePriceInDatabase(newPrice: Double) {
        
        let id = orderInQuestion.getID()
        
        ref.child("orders").child(id).child("price").setValue(newPrice)
        
        self.createSimpleAlert(title: "Change Made", message: "Price saved to '" + newPrice.description + "'")
    }
    
    //
    // Creates a UIAlert that has text fields to add a new item
    //
    
    func createAlertEditSomething(Title:String) {
        
        let alert = UIAlertController(title: Title, message: "", preferredStyle: .alert)
        
        if orderInQuestion.getPickup() {
            switch editWhat {
                
            case 0:
                let vc = UIViewController()
                vc.preferredContentSize = CGSize(width: 250,height: 90)
                let vendorPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 90))
                
                vendorPicker.delegate = self
                vendorPicker.dataSource = self
                
                vc.view.addSubview(vendorPicker)
                
                alert.setValue(vc, forKey: "contentViewController")

                let ok = UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction) -> Void in
                    
                    
                    let input = self.pickupvendorslist[vendorPicker.selectedRow(inComponent: 0)].getName().capitalizeFirstLetter()
                    
                    self.updateVendorInDatabase(newVendor: input)
                })
                
                alert.addAction(ok)
                
                
            case 1:
                alert.addTextField(configurationHandler: editFieldSetup)
                let ok = UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction) -> Void in
                    
                    guard let input = Double(self.editTF!.text!) else {
                        self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                        return
                    }
                    
                  
                    self.updatePriceInDatabase(newPrice: input)
                })
                
                alert.addAction(ok)
                
            case 2:
                alert.addTextField(configurationHandler: editFieldSetup)
                let ok = UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction) -> Void in
                    
                    guard let input = Double(self.editTF!.text!) else {
                        self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                        return
                    }
                    
                    self.updateTipInDatabase(newTip: input)
                })
                
                alert.addAction(ok)
                
                
            case 3:
                alert.addTextField(configurationHandler: editFieldSetup)
                let ok = UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction) -> Void in
                    
                    guard let input = Double(self.editTF!.text!) else {
                        self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                        return
                    }
                    
                    self.updateRefundInDatabase(newRefund: input)
                })
                
                alert.addAction(ok)
                
                
            case 4:
                let cashButton = UIAlertAction(title: "Cash", style: .default, handler: { (action: UIAlertAction) -> Void in
                    self.orderInQuestion.setCash(CASH: true)
                    self.updateCashCreditInDatabase(isCash: true)
                })
                
                let creditButton = UIAlertAction(title: "Credit", style: .default, handler: { (action: UIAlertAction) -> Void in
                    self.orderInQuestion.setCash(CASH: false)
                    self.updateCashCreditInDatabase(isCash: false)

                })
                
                alert.addAction(cashButton)
                alert.addAction(creditButton)
                
            case 5:
                alert.addTextField(configurationHandler: editFieldSetup)
                let ok = UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction) -> Void in
                    
                    guard let input = (self.editTF?.text!)?.capitalizeFirstLetter() else {
                        self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                        return
                    }
                    
                    self.updateNotesInDatabase(newNotes: input)
                })
                
                alert.addAction(ok)
                
            default:
                break

            }
        } else {
            switch editWhat {
            case 0:
                alert.addTextField(configurationHandler: editFieldSetup)
                let ok = UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction) -> Void in
                    
                    guard let input = self.editTF?.text! else {
                        self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                        return
                    }
                    
                    self.updateAddressInDatabase(newAddress: input)
                })
                
                alert.addAction(ok)
                
            case 1:
                let vc = UIViewController()
                vc.preferredContentSize = CGSize(width: 250,height: 90)
                let vendorPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 90))
                
                vendorPicker.delegate = self
                vendorPicker.dataSource = self
                
                vc.view.addSubview(vendorPicker)
                
                alert.setValue(vc, forKey: "contentViewController")
                
                let ok = UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction) -> Void in
                    
                    
                    let input = self.deliveryvendorslist[vendorPicker.selectedRow(inComponent: 0)].getName().capitalizeFirstLetter()
                    
                    self.updateVendorInDatabase(newVendor: input)
                })
                
                alert.addAction(ok)

            case 2:
                alert.addTextField(configurationHandler: editFieldSetup)
                let ok = UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction) -> Void in
                    
                    guard let input = Double(self.editTF!.text!) else {
                        self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                        return
                    }
                    
                    self.updatePriceInDatabase(newPrice: input)
                })
                
                alert.addAction(ok)
                
                
            case 3:
                alert.addTextField(configurationHandler: editFieldSetup)
                let ok = UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction) -> Void in
                    
                    guard let input = Double(self.editTF!.text!) else {
                        self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                        return
                    }
                    
                    self.updateTipInDatabase(newTip: input)
                })
                
                alert.addAction(ok)
                
                
            case 4:
                alert.addTextField(configurationHandler: editFieldSetup)
                let ok = UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction) -> Void in
                    
                    guard let input = Double(self.editTF!.text!) else {
                        self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                        return
                    }
                    
                    self.updateDeliveryFeeInDatabase(newDF: input)
                })
                
                alert.addAction(ok)
                
                
            case 5:
                alert.addTextField(configurationHandler: editFieldSetup)
                let ok = UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction) -> Void in
                    
                    guard let input = Double(self.editTF!.text!) else {
                        self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                        return
                    }
                    
                    self.updateRefundInDatabase(newRefund: input)
                })
                
                alert.addAction(ok)
                
                
            case 6:
                let cashButton = UIAlertAction(title: "Cash", style: .default, handler: { (action: UIAlertAction) -> Void in
                    self.orderInQuestion.setCash(CASH: true)
                    self.updateCashCreditInDatabase(isCash: true)
                })
                
                let creditButton = UIAlertAction(title: "Credit", style: .default, handler: { (action: UIAlertAction) -> Void in
                    self.orderInQuestion.setCash(CASH: false)
                    self.updateCashCreditInDatabase(isCash: false)
                })
                
                alert.addAction(cashButton)
                alert.addAction(creditButton)
                
            case 7:
                alert.addTextField(configurationHandler: editFieldSetup)
                let ok = UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction) -> Void in
                    
                    guard let input = (self.editTF?.text!)?.capitalizeFirstLetter() else {
                        self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                        return
                    }
                    
                    self.updateNotesInDatabase(newNotes: input)
                })
                
                alert.addAction(ok)
            default:
                break

            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
