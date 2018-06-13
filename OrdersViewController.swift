//
//  ViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 5/16/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit
import FirebaseDatabase

class OrdersViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //
    // Button outlets
    //
    @IBOutlet weak var ordersHeader: UILabel!
    
    @IBOutlet weak var endOfDayButton: UIButton!
    @IBOutlet weak var mainMenuButton: UIButton!
    @IBOutlet weak var newOrderButton: UIButton!
    @IBOutlet weak var statsButton: UIButton!
    
    //
    // Boolean variables to determine which picker view to use
    //
    
    var showDeliveryPickupPicker = true
    var showPickupVendorPicker = false
    var showDeliveryVendorPicker = false
    var showPricePicker = false
    var showDeliveryFeePicker = false
    var showCashCreditPicker = false


    var showPickupVendors = true
    
    //
    // Create FirebaseDatabase reference
    //
    
    var ref:DatabaseReference!
    var uid:String = ""

    //
    // - Two lists used for pickup/delivery vendors
    // - One used for orders
    // - EOD entity holds current day's values
    //
    
    let deliveryPickupOptions = ["Delivery","Pickup"]
    let cashCreditOptions = ["Cash","Credit"]
    let numbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    let deliveryFeeNumbers = ["0", "4", "6"]
    var pickupvendorslist = [newVendor]()
    var deliveryvendorslist = [newVendor]()
    var orderslist = [newOrder]()
    var eodlist = [newEOD]()
    
    //
    // Text field for new order name & address and setup functions
    //
    
    var newNameTF: UITextField?
    var newAddressTF: UITextField?

    func nameTFSetup(textfield: UITextField!) {
        newNameTF = textfield
        newNameTF?.placeholder = "Name"
    }
    
    func addressTFSetup(textfield: UITextField!) {
        newAddressTF = textfield
        newAddressTF?.placeholder = "Address"
    }

    //
    // PickerView functions
    //
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if showPricePicker {
            return 6
        } else {
            return 1
        }
    }
    
    //
    // Returns value that will be displayed in the picker view
    //
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if showDeliveryPickupPicker {
            return deliveryPickupOptions[row]
        } else if showPickupVendorPicker {
            return pickupvendorslist[row].getName()
        } else if showDeliveryVendorPicker {
            return deliveryvendorslist[row].getName()
        } else if showPricePicker {
            if component == 3 {
                return "."
            } else {
                return String(row)
            }
        } else if showDeliveryFeePicker {
            return deliveryFeeNumbers[row]
        } else if showCashCreditPicker {
            return cashCreditOptions[row]
        }
        
        return ""
    }
    
    //
    // Returns number of rows inside of picker view
    //
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if showDeliveryPickupPicker || showCashCreditPicker {
            return 2 // pickup/delivery or cash/credit
        } else if showPickupVendorPicker {
            return pickupvendorslist.count
        } else if showDeliveryVendorPicker {
            return deliveryvendorslist.count
        } else if showPricePicker {
            if component == 3 {
                return 1 // "."
            } else {
                return 10 // digits 0...9
            }
        } else if showDeliveryFeePicker {
            return 3 // 0,4,6
        }
        
        return 0
    }
    
    //
    // Table View initialization and functions
    //
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderslist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        let isIndexValid = self.orderslist.indices.contains(indexPath.row)
        
        //
        // Check if index in list is valid, then display its values
        // in the cell if it is valid, otherwise "nil"
        //
        
        if (isIndexValid) {
            cell.orderName.text = orderslist[indexPath.row].getName()
            cell.orderVendor.text = orderslist[indexPath.row].getVendor()
            let price = orderslist[indexPath.row].getPrice() + orderslist[indexPath.row].getTip() + orderslist[indexPath.row].getDeliveryFee()
            
            cell.orderPrice.text = String(format: "%.2f", price)
            
            if (orderslist[indexPath.row].getPickup()) {
                cell.orderPickupDelivery.text = "Pickup"
                
            } else {
                cell.orderPickupDelivery.text = "Delivery"
            }
            
            
            return cell
        }
        
        cell.orderName.text = "nil"
        cell.orderVendor.text = "nil"
        cell.orderPrice.text = "nil"
        cell.orderPickupDelivery.text = "nil"
        
        return cell
    }
    
    //
    // Deselects cell in table view after it is tapped
    //
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
   
    //
    // If we delete a cell, we need to update our vendors and refresh
    //
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let ordername = self.orderslist[indexPath.row].getName()
            
            let alert = UIAlertController(title: "Confirm Deletion", message: "Really delete '" + ordername + "'?", preferredStyle: .alert)
            let vc = UIViewController()
            vc.preferredContentSize = CGSize(width: 250,height: 30)
            
            alert.setValue(vc, forKey: "contentViewController")
            
            let ok = UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction) -> Void in
                self.ref.child("orders").child(self.orderslist[indexPath.row].getID()).removeValue()
                self.zeroOutVendorData()
                self.getOrders()
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
  
    //
    // Add order via UIAlert
    //
    // This function sparks a series of other UIAlert functions
    // that allow the user to populate order data fields. The fields
    // are slightly different for pickup and delivery orders.
    //
    
    func addOrderViaAlert() {
        self.showDeliveryPickupPicker = true
        self.showPickupVendorPicker = false
        self.showDeliveryVendorPicker = false
        self.showPricePicker = false

        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 30)
        
        let alert = UIAlertController(title: "Pickup or Delivery", message: "", preferredStyle: .alert)
        alert.setValue(vc, forKey: "contentViewController")
        
        let pickupButton = UIAlertAction(title: "Pickup", style: .default, handler: { (action: UIAlertAction) -> Void in
            
            // User chose pickup, so display pickup vendors in next alert
            self.showPickupVendorPicker = true
            self.showDeliveryVendorPicker = false
            self.showPickupVendors = true
            self.createAlertChooseVendor()

        })
        
        let deliveryButton = UIAlertAction(title: "Delivery", style: .default, handler: { (action: UIAlertAction) -> Void in
            
            // User chose delivery, so display delivery vendors in next alert
            self.showPickupVendorPicker = false
            self.showDeliveryVendorPicker = true
            self.showPickupVendors = false
            self.createAlertChooseVendor()
            
        })
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(pickupButton)
        alert.addAction(deliveryButton)
        self.present(alert, animated: true)
    }
    
    //
    // Creates UIAlert that allows user to fill in vendor data
    //
    
    func createAlertChooseVendor() {
        let order = newOrder()

        self.showDeliveryPickupPicker = false
        self.showPricePicker = false

        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 150)
        let vendorPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 150))
        
        vendorPicker.delegate = self
        vendorPicker.dataSource = self
        
        vc.view.addSubview(vendorPicker)
        
        let alert = UIAlertController(title: "Choose Vendor", message: "", preferredStyle: .alert)
        alert.setValue(vc, forKey: "contentViewController")
        
        var list = [newVendor]()
        
        if showPickupVendors {
            list = pickupvendorslist
            order.setPickup(PICKUP: true)
        } else {
            list = deliveryvendorslist
            order.setPickup(PICKUP: false)
        }
        
        let next = UIAlertAction(title: "Next", style: .default, handler: { (action: UIAlertAction) -> Void in
            
            //
            // Get user's choice and move to next alert (choosing vendor)
            //
            // currentRow = vendor name
            //
            
            let vendorName = list[vendorPicker.selectedRow(inComponent: 0)].getName()
            
            order.setVendor(VENDOR: vendorName)
            
            // Change price picker boolean before calling function
            
            self.showDeliveryVendorPicker = false
            self.showPickupVendorPicker = false
            self.showPricePicker = true

            self.createAlertChoosePrice(order: order)
            
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(next)
        self.present(alert, animated: true)
    }

    //
    // Creates UIAlert that allows user to fill in price data
    //
    
    func createAlertChoosePrice(order: newOrder) {
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 90)
        let pricePicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 90))
        
        pricePicker.delegate = self
        pricePicker.dataSource = self
        
        vc.view.addSubview(pricePicker)
        
        let alert = UIAlertController(title: "Choose Price", message: "", preferredStyle: .alert)
        alert.setValue(vc, forKey: "contentViewController")

        
        let next = UIAlertAction(title: "Next", style: .default, handler: { (action: UIAlertAction) -> Void in
            
            //
            // Get user's choice and move to next alert (choosing vendor)
            //
            
            let val1 = self.numbers[pricePicker.selectedRow(inComponent: 0)]
            let val2 = self.numbers[pricePicker.selectedRow(inComponent: 1)]
            let val3 = self.numbers[pricePicker.selectedRow(inComponent: 2)]
            let val4 = self.numbers[pricePicker.selectedRow(inComponent: 4)]
            let val5 = self.numbers[pricePicker.selectedRow(inComponent: 5)]

            let currentPriceString = "\(val1)\(val2)\(val3).\(val4)\(val5)"
            let currentPriceDouble = Double(currentPriceString)
            
            order.setPrice(PRICE: currentPriceDouble!)
            
            //
            // Tip alert is next
            //
            
            self.createAlertChooseTip(order: order)
            
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(next)
        self.present(alert, animated: true)
    }
    
    //
    // Creates UIAlert that allows user to fill in tip data
    //
    
    func createAlertChooseTip(order: newOrder) {
        
        if !self.showPickupVendors {
            self.showPricePicker = true
        }
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 90)
        let tipPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 90))
        
        tipPicker.delegate = self
        tipPicker.dataSource = self
        
        vc.view.addSubview(tipPicker)
        
        let alert = UIAlertController(title: "Choose Tip", message: "", preferredStyle: .alert)
        alert.setValue(vc, forKey: "contentViewController")
        
        
        let next = UIAlertAction(title: "Next", style: .default, handler: { (action: UIAlertAction) -> Void in
            
            //
            // Get user's choice and move to next alert (choosing vendor)
            //
            
            let val1 = self.numbers[tipPicker.selectedRow(inComponent: 0)]
            let val2 = self.numbers[tipPicker.selectedRow(inComponent: 1)]
            let val3 = self.numbers[tipPicker.selectedRow(inComponent: 2)]
            let val4 = self.numbers[tipPicker.selectedRow(inComponent: 4)]
            let val5 = self.numbers[tipPicker.selectedRow(inComponent: 5)]
            
            let currentTipString = "\(val1)\(val2)\(val3).\(val4)\(val5)"
            let currentTipDouble = Double(currentTipString)
            
            order.setTip(TIP: currentTipDouble!)
            
            //
            // DF or name alert is next depending
            // if adding a delivery or pickup order
            //
            
            if self.showPickupVendors {
                // Show name alert
                self.showPricePicker = false
                self.showDeliveryFeePicker = false

                self.createAlertChooseName(order: order)
                
            } else {
                // Show delivery fee alert, then name alert
                self.showPricePicker = false
                self.showDeliveryFeePicker = true
                
                self.createAlertChooseDeliveryFee(order: order)
            }
            
            
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(next)
        self.present(alert, animated: true)
    }
    
    //
    // Creates UIAlert that allows user to fill in delivery fee data
    //
    
    func createAlertChooseDeliveryFee(order: newOrder) {
        
        if !self.showPickupVendors {
            self.showDeliveryFeePicker = true
        }
        
        self.showCashCreditPicker = false

        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 75)
        let deliveryFeePicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 75))
        
        deliveryFeePicker.delegate = self
        deliveryFeePicker.dataSource = self
        
        vc.view.addSubview(deliveryFeePicker)
        
        let alert = UIAlertController(title: "Choose Delivery Fee", message: "", preferredStyle: .alert)
        alert.setValue(vc, forKey: "contentViewController")
        
        
        let next = UIAlertAction(title: "Next", style: .default, handler: { (action: UIAlertAction) -> Void in
            
            //
            // Get user's choice and move to next alert (choosing vendor)
            //
            
            let deliveryFee = Double(self.deliveryFeeNumbers[deliveryFeePicker.selectedRow(inComponent: 0)])
            
            order.setDeliveryFee(DFEE: deliveryFee!)
            
            // Address alert is next
            self.createAlertChooseAddress(order: order)
            
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(next)
        self.present(alert, animated: true)
    }
    
    //
    // Creates UIAlert that allows user to fill in address data
    //
    
    func createAlertChooseAddress(order: newOrder) {
        
        let alert = UIAlertController(title: "Choose Address", message: "", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: addressTFSetup)
        
        let ok = UIAlertAction(title: "Next", style: .default, handler: { (action: UIAlertAction) -> Void in
            
            guard let address = self.newAddressTF?.text! else {
                self.createAlert(title: "Check input", message: "")
                return
            }
            
            //
            // Checks for arbitrary amount of spaces
            //
            
            let tempAddress = address.trimmingCharacters(in: .whitespaces)
            
            
            if tempAddress != "" {
                //
                // Create confirmation alert before adding to database
                //
                
                order.setAddress(ADDRESS: address)
                self.createAlertChooseName(order: order)
            } else {
                self.createAlertChooseAddress(order: order)
            }
            
            
            
            
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //
    // Creates UIAlert that allows user to fill in name data
    //
    
    func createAlertChooseName(order: newOrder) {
        
        let alert = UIAlertController(title: "Choose Name", message: "", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nameTFSetup)

        
        let ok = UIAlertAction(title: "Next", style: .default, handler: { (action: UIAlertAction) -> Void in
            
            guard var name = self.newNameTF?.text! else {
                self.createAlert(title: "Check input", message: "")
                return
            }
            
            //
            // Checks for arbitrary amount of spaces
            //
            
            let tempName = name.trimmingCharacters(in: .whitespaces)
            
            
            if tempName != "" {
                //
                // Create confirmation alert before adding to database
                //
                
                name = name.capitalizeFirstLetter()
                
                order.setName(NAME: name)
                self.showDeliveryFeePicker = false
                self.showCashCreditPicker = true
                self.createAlertChooseCashCredit(order: order)
            } else {
                self.createAlertChooseName(order: order)
            }
   
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func createAlertChooseCashCredit(order: newOrder) {
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 75)
        
        let alert = UIAlertController(title: "Cash or Credit", message: "", preferredStyle: .alert)
        alert.setValue(vc, forKey: "contentViewController")
        
        let creditButton = UIAlertAction(title: "Credit", style: .default, handler: { (action: UIAlertAction) -> Void in

            order.setCash(CASH: false)

            self.createAlertConfirmOrder(order: order)
            
        })
        
        let cashButton = UIAlertAction(title: "Cash", style: .default, handler: { (action: UIAlertAction) -> Void in
            
            order.setCash(CASH: true)

            self.createAlertConfirmOrder(order: order)
            
        })
        
        alert.addAction(cashButton)
        alert.addAction(creditButton)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    //
    // Creates an alert to confirm order before adding to database
    //
    
    func createAlertConfirmOrder(order: newOrder) {
        var message = ""
        
        //
        // If pickup, dont show delivery fee in confirm (i.e. message doesn't include df)
        //
        
        if order.getPickup() {
            message = "Name: " + order.getName() + "\n" + "Type: " + order.getPickupDeliveryString() + "\n" + "Price: " + String(format: "%.2f", order.getPrice()) + "\n" + "Tip: " + String(format: "%.2f", order.getTip()) + "\n" + "Pay by: " + order.getCashCreditString() + "\n" + "Vendor: " + order.getVendor()

        } else {
            message = "Name: " + order.getName() + "\n" + "Type: " + order.getPickupDeliveryString() + "\n" + "Price: " + String(format: "%.2f", order.getPrice()) + "\n" + "Tip: " + String(format: "%.2f", order.getTip()) + "\n" + "Delivery Fee: " + String(format: "%.2f", order.getDeliveryFee()) + "\n" + "Address: " + order.getAddress() + "\n" + "Pay by: " + order.getCashCreditString() + "\n" + "Vendor: " + order.getVendor()
            
        }
        
        let alert = UIAlertController(title: "Confirm", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            let idRef = self.ref.child("orders").childByAutoId()
            let id = idRef.key

            order.setID(ID: id)
            
            let orderInfo = [
                "name":         order.getName(),
                "price":        order.getPrice(),
                "address":      order.getAddress(),
                "vendor":       order.getVendor(),
                "notes":        order.getNotes(),
                "delivery fee": order.getDeliveryFee(),
                "tip":          order.getTip(),
                "cash":         order.getCash(),
                "refund":       order.getRefund(),
                "pickup":       order.getPickup(),
                "id":           order.getID()
                ] as [String : Any]
            
            
            self.ref.child("orders").child(order.getID()).setValue(orderInfo)
            
            self.getOrders()
            self.zeroOutVendorData()
            
            //
            // Refresh Tableview
            //
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }))
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //
    // Creates an alert with only text
    //
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //
    // Adds a new order via a series of UIAlerts
    //
    
    @IBAction func addNewOrder(_ sender: Any) {
        addOrderViaAlert()
    }
    
    

    //
    // Get updated version of orders every time we
    // come back to this view
    //
    
    @IBAction func unwindToOrdersView(segue: UIStoryboardSegue) {
        zeroOutVendorData()
        getOrders()
    }
    
    //
    // Prepare to display order information in a detailed view
    //
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailseg") {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let destVC = segue.destination as! CellViewController
                destVC.uid = uid

                for o in self.orderslist {
                    destVC.orderslist.append(o)
                }
                
                destVC.orderIndex = indexPath.row
                
            } // end indexPath -- should not ever be null -- however gets information for selected cell
        } else if (segue.identifier == "statseg") {
            
            //
            // Pre populate three candidate arrays used in stat view
            //
            
            let destVC = segue.destination as! StatsViewController
            destVC.uid = uid

            for o in self.orderslist {
                if (!o.getPickup()) {
                    destVC.deliveryorderslist.append(o)
                }
            }
            
            for v in self.deliveryvendorslist {
                destVC.deliveryvendorslist.append(v)
            }
            
            for v in self.pickupvendorslist {
                destVC.pickupvendorslist.append(v)
            }
            
    
            
        } else if (segue.identifier == "eodseg") {
            let destVC = segue.destination as! EndOfDayViewController
            destVC.uid = uid

            for e in self.eodlist {
                destVC.eodlist.append(e)
            }
            
            for o in self.orderslist {
                if (!o.getPickup()) {
                    destVC.deliveryorderslist.append(o)
                }
            }
            
            for v in self.deliveryvendorslist {
                destVC.deliveryvendorslist.append(v)
            }
            
            for v in self.pickupvendorslist {
                destVC.pickupvendorslist.append(v)
            }
            
        }
        
    } //end prepareforseg
    
    //
    // Grabs order entries from database and stores in list
    //
    
    func getOrders() {
        
        self.orderslist.removeAll()
                
        ref.child("orders").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                
                let order = newOrder()
                order.name = dictionary["name"] as? String
                order.address = dictionary["address"] as? String
                order.vendor = dictionary["vendor"] as? String
                order.notes = dictionary["notes"] as? String
                order.price = dictionary["price"] as? Double
                order.tip = dictionary["tip"] as? Double
                order.delivFee = dictionary["delivery fee"] as? Double
                order.refund = dictionary["refund"] as? Double
                order.pickup = dictionary["pickup"] as! Bool
                order.cash = dictionary["cash"] as! Bool
                order.id = dictionary["id"] as? String

                
                var beenAdded = false
                
                for o in self.orderslist {
                    if (o.getID() == order.getID()) {
                        beenAdded = true
                    }
                }
                
                if (!beenAdded) {
                    self.separateVendorData(o: order)
                    self.orderslist.append(order)

                    
                }
                //
                // Refresh Tableview
                //
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
            }
        })
        
        //
        // Refresh Tableview
        //
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        
    }
    
    //
    // Zeros out vendor lists and total for vendors in database
    //
    
    func zeroOutVendorData() {
        
        
        for v in self.pickupvendorslist {
            
            v.setCredit(CREDIT: 0.0)
            v.setCash(CASH: 0.0)
            v.setNum(NUM: 0)
            v.setTotal(TOTAL: 0.0)
            v.setRefund(REFUND: 0.0)
            
        }
        
        for v in self.deliveryvendorslist {
            v.setCredit(CREDIT: 0.0)
            v.setCash(CASH: 0.0)
            v.setNum(NUM: 0)
            v.setTotal(TOTAL: 0.0)
            v.setRefund(REFUND: 0.0)
        }
        //
        // First part is zeroing out pickup vendors
        //
        
        ref.child("vendors").child("pickup vendors").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                let vendorName = dictionary["name"] as? String

                let vendorInfo = [
                    "cash":    0.0,
                    "credit":  0.0,
                    "total":   0.0,
                    "num":     0,
                    "refund":  0.0
                    ] as [String : Any]
                self.ref.child("vendors").child("pickup vendors").child(vendorName!).updateChildValues(vendorInfo)
                
            }
        })
        
        ref.child("vendors").child("delivery vendors").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                let vendorName = dictionary["name"] as? String
                
                let vendorInfo = [
                    "cash":    0.0,
                    "credit":  0.0,
                    "total":   0.0,
                    "num":     0,
                    "refund":  0.0
                    ] as [String : Any]
                
                self.ref.child("vendors").child("delivery vendors").child(vendorName!).updateChildValues(vendorInfo)
                
            }
        })
    
    
    } //end zeroOutVendors()
    
    //
    // Get order vendor name then determine which vendor
    // the order belonds to. Then, update that vendors
    // stats in database -- used in StatsViewController
    //
    
    func separateVendorData(o:newOrder) {
        
        if (o.getPickup()) {
            
            //
            // Order is a pickup, so get pickup vendors
            //
            
            for v in self.pickupvendorslist {
                
                if (o.getVendor() == v.getName()) {
                    
                    //
                    // Found the vendor, determine if cash/credit,
                    // then update
                    //
                    
                    ref.child("vendors").child("pickup vendors").child(v.getName()).observeSingleEvent(of: .value, with: { (snapshot) in
                        
 
                        
                        var newCash = v.getCash()
                        var newCredit = v.getCredit()
                        var newTotal = v.getTotal()
                        var newNum = v.getNum()
                        var newRefund = v.getRefund()
           
                        
                        
                        newTotal += o.getPrice()
                        newNum += 1
                        newRefund += o.getRefund()
                        
                        
                        
                        if (o.getCash()) {
                            newCash += o.getPrice()
                        } else {
                            newCredit += o.getPrice()
                        }

                        let vendorInfo = [
                            "cash":    newCash,
                            "credit":  newCredit,
                            "total":   newTotal,
                            "num":     newNum,
                            "refund":  newRefund
                            ] as [String : Any]

                        self.ref.child("vendors").child("pickup vendors").child(v.getName()).updateChildValues(vendorInfo)
                        
                        v.setCash(CASH: newCash)
                        v.setCredit(CREDIT: newCredit)
                        v.setTotal(TOTAL: newTotal)
                        v.setNum(NUM: newNum)
                        v.setRefund(REFUND: newRefund)
                        
                    })
                    
                } //end match vendor to order
                
            }
            
        } else {
            
            //
            // Order is a delivery, so get delivery vendors
            //
            
            for v in self.deliveryvendorslist {
                
                //
                // Found the vendor, update
                //
                if (o.getVendor() == v.getName()) {
                    //
                    // Found the vendor, determine if cash/credit,
                    // then update
                    //
                    
                    ref.child("vendors").child("delivery vendors").child(v.getName()).observeSingleEvent(of: .value, with: { (snapshot) in
                        

                        var newCash = v.getCash()
                        var newCredit = v.getCredit()
                        var newTotal = v.getTotal()
                        var newNum = v.getNum()
                        var newRefund = v.getRefund()
                        
                        
                        
                        newTotal += o.getPrice()
                        newNum += 1
                        newRefund += o.getRefund()
                        
                        
                        
                        if (o.getCash()) {
                            newCash += o.getPrice()
                        } else {
                            newCredit += o.getPrice()
                        }
                        
                        let vendorInfo = [
                            "cash":    newCash,
                            "credit":  newCredit,
                            "total":   newTotal,
                            "num":     newNum,
                            "refund":  newRefund
                            ] as [String : Any]
                        

                        
                        self.ref.child("vendors").child("delivery vendors").child(v.getName()).updateChildValues(vendorInfo)
                        
                        v.setCash(CASH: newCash)
                        v.setCredit(CREDIT: newCredit)
                        v.setTotal(TOTAL: newTotal)
                        v.setNum(NUM: newNum)
                        v.setRefund(REFUND: newRefund)
                    
                    
                    }) //end dictionary
                } //end match vendor to order
            } //end deliveryvendor for loop
        } //end else
    } //end separateVendorData()

    //
    // used to dismiss keyboards
    //
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    func initView() {
        newOrderButton.layer.cornerRadius = 10
        newOrderButton.layer.masksToBounds = true
        newOrderButton.layer.borderColor = UIColor.black.cgColor
        newOrderButton.layer.borderWidth = 0.5
        newOrderButton.layer.shadowColor = UIColor.black.cgColor
        newOrderButton.layer.shadowOffset = CGSize.zero
        newOrderButton.layer.shadowRadius = 5.0
        newOrderButton.layer.shadowOpacity = 0.5
        newOrderButton.clipsToBounds = false
        
        statsButton.layer.cornerRadius = 10
        statsButton.layer.masksToBounds = true
        statsButton.layer.borderColor = UIColor.black.cgColor
        statsButton.layer.borderWidth = 0.5
        statsButton.layer.shadowColor = UIColor.black.cgColor
        statsButton.layer.shadowOffset = CGSize.zero
        statsButton.layer.shadowRadius = 5.0
        statsButton.layer.shadowOpacity = 0.5
        statsButton.clipsToBounds = false
        
        endOfDayButton.layer.cornerRadius = 10
        endOfDayButton.layer.masksToBounds = true
        endOfDayButton.layer.borderColor = UIColor.black.cgColor
        endOfDayButton.layer.borderWidth = 0.5
        endOfDayButton.layer.shadowColor = UIColor.black.cgColor
        endOfDayButton.layer.shadowOffset = CGSize.zero
        endOfDayButton.layer.shadowRadius = 5.0
        endOfDayButton.layer.shadowOpacity = 0.5
        endOfDayButton.clipsToBounds = false
        
        mainMenuButton.layer.cornerRadius = 10
        mainMenuButton.layer.masksToBounds = true
        mainMenuButton.layer.borderColor = UIColor.black.cgColor
        mainMenuButton.layer.borderWidth = 0.5
        mainMenuButton.layer.shadowColor = UIColor.black.cgColor
        mainMenuButton.layer.shadowOffset = CGSize.zero
        mainMenuButton.layer.shadowRadius = 5.0
        mainMenuButton.layer.shadowOpacity = 0.5
        mainMenuButton.clipsToBounds = false
        
        let strokeTextAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.strokeColor : UIColor.black,
            NSAttributedStringKey.foregroundColor : UIColor.white,
            NSAttributedStringKey.strokeWidth : -2.0,
            ]
        
        ordersHeader.attributedText = NSAttributedString(string: "Orders", attributes: strokeTextAttributes)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // Initialize database reference and display
        // orders from FirebaseDatabase inside of table view
        //
        
        ref = Database.database().reference().child("users").child(uid)

        initView()
        //
        // initially display view for pickup
        //
        
        getOrders()
      
        //
        // creating done button to close keyboards
        //
        
       /* let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([doneButton], animated: false)
        */


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

