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
    // Declare variables used for a part of each order
    //
    
    var isPickup = true
    var isCash = true
    
    //
    // Create FirebaseDatabase reference
    //
    
    var ref:DatabaseReference!

    //
    // Text fields for order input
    //
    
    @IBOutlet weak var tf_CustomerName: UITextField!
    @IBOutlet weak var tf_CustomerAddr: UITextField!
    @IBOutlet weak var tf_Price: UITextField!
    @IBOutlet weak var tf_Vendor: UITextField!
    @IBOutlet weak var tf_Tip: UITextField!
    @IBOutlet weak var tf_DeliveryFee: UITextField!
    
    //
    // MARK: Picker View for vendors -- includes list and functions needed for picker view
    //
    
    //
    // Two lists used for pickup/delivery vendors
    //
    
    var pickupvendorslist = [newVendor]()
    var deliveryvendorslist = [newVendor]()
    var orderslist = [newOrder]()

    
    
    @IBOutlet weak var pickupVendorPicker: UIPickerView!
    @IBOutlet weak var deliveryVendorPicker: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //
    // Returns string (vendor name) that will be displayed in the picker view
    //
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickupVendorPicker {
            if (pickupvendorslist.count > 0) {
                return pickupvendorslist[row].getName()
            }
        } else if pickerView == deliveryVendorPicker {
            if (deliveryvendorslist.count > 0) {
                return deliveryvendorslist[row].getName()
            }
        }
        
        return ""

        
    }
    
    //
    // Returns number of components inside of picker view
    //
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == pickupVendorPicker {
            return pickupvendorslist.count
            
        } else if pickerView == deliveryVendorPicker {
            return deliveryvendorslist.count
            
        } else {
            
            return 0
        }

    }
    
    //
    // Depending on which row is selected, display it in the vendor text field
    //
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickupVendorPicker {
            if (pickupvendorslist.count > 0) {
                tf_Vendor.text = pickupvendorslist[row].getName()
            }
        } else if pickerView == deliveryVendorPicker {
            if (deliveryvendorslist.count > 0) {
                tf_Vendor.text = deliveryvendorslist[row].getName()
            }
        }

    }
    
    
    //
    //MARK: Table View initialization and refresh control
    //
    
    @IBOutlet weak var tableView: UITableView!
    
    var refresher: UIRefreshControl!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderslist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (orderslist.count > 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
            
            
            cell.orderName.text = orderslist[indexPath.row].getName()
            cell.orderVendor.text = orderslist[indexPath.row].getVendor()
            let price = orderslist[indexPath.row].getPrice() - orderslist[indexPath.row].getRefund()
            cell.orderPrice.text = price.description
            
            if (orderslist[indexPath.row].getPickup())
            {
                cell.orderPickupDelivery.text = "Pickup"
                
            }else{
                cell.orderPickupDelivery.text = "Delivery"
            }
 

            return cell
                
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        
        cell.orderName.text = "nil"
        cell.orderVendor.text = "nil"
        cell.orderPrice.text = "nil"
        cell.orderPickupDelivery.text = "nil"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
   
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete)
        {
            ref.child("orders").child(orderslist[indexPath.row].getName()).removeValue()
            
            print("removing " + orderslist[indexPath.row].getName())

            getOrders()
     
        }
    }

    //
    // MARK: Segmented Control - pickup/delivery & cash/credit options
    //
    
    @IBOutlet weak var pickupdeliverySeg: UISegmentedControl!
    @IBOutlet weak var cashcreditSeg: UISegmentedControl!

    //
    // $4 or $6 delivery fee -- easier than typing
    //
    @IBOutlet weak var delivFeeSegControl: UISegmentedControl!
    
    //
    //pickup/delivery
    //
    
    @IBAction func pickupdelivery(_ sender: Any) {
        
        switch pickupdeliverySeg.selectedSegmentIndex {
            
        case 0:
            displayForPickup()
            break
        case 1:
            displayForDelivery()
            break
        default:
            break
        }
    }
    
    @IBAction func changeDeliveryFee(_ sender: Any) {
        
        switch delivFeeSegControl.selectedSegmentIndex {
        case 0:
            tf_DeliveryFee.text = "0"
            break
        case 1:
            tf_DeliveryFee.text = "4"
            break
        case 2:
            tf_DeliveryFee.text = "6"
            break
        default:
            break
        }
    }
    
    //
    // functions used to show and hide labels, tf, etc.
    //
    
    func displayForPickup()
    {
        isPickup = true;
        tf_CustomerAddr.isUserInteractionEnabled = false
        tf_DeliveryFee.isUserInteractionEnabled = false
        delivFeeSegControl.isUserInteractionEnabled = false
        tf_Vendor.isUserInteractionEnabled = false
        tf_Vendor.text = ""
        tf_CustomerAddr.text = "Pickup"
        tf_DeliveryFee.text = "0"
        pickupVendorPicker.isHidden = false
        deliveryVendorPicker.isHidden = true
        delivFeeSegControl.selectedSegmentIndex = 0

    }
    
    func displayForDelivery() {
        isPickup = false;
        tf_CustomerAddr.isUserInteractionEnabled = true
        delivFeeSegControl.isUserInteractionEnabled = true
        tf_Vendor.isUserInteractionEnabled = false
        tf_Vendor.text = ""
        tf_CustomerAddr.text = ""
        tf_DeliveryFee.text = "0"
        pickupVendorPicker.isHidden = true
        deliveryVendorPicker.isHidden = false
        tf_DeliveryFee.isUserInteractionEnabled = false
        delivFeeSegControl.selectedSegmentIndex = 0
        
    }
    
    //
    // used to change cash variable
    //
    
    func changeIsCash(cash:Bool)
    {
        isCash = cash
    }
    
    
    //
    // cash/credit
    //
    
    @IBAction func cashcredit(_ sender: Any) {
        
        switch cashcreditSeg.selectedSegmentIndex {
            
        case 0:
            changeIsCash(cash: true)
        case 1:
            changeIsCash(cash: false)

        default:
            break
        }

    }
    
    
    
    //
    // MARK: UIAlert functions
    //
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    

    //
    //MARK: Add order to FirebaseDatabase
    //
    
    @IBAction func addOrder(_ sender: Any) {

        guard let orderName = self.tf_CustomerName.text, let orderAddress = self.tf_CustomerAddr.text, let orderVendor = self.tf_Vendor.text, let orderPrice = Double(self.tf_Price.text!), let orderTip = Double(self.tf_Tip.text!), let orderDelivFee = Double(self.tf_DeliveryFee.text!) else {
            
            createAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
            return
        }
        
        
        let theOrder = newOrder(NAME: orderName, ADDRESS: orderAddress, VENDOR: orderVendor, PRICE: orderPrice, TIP: orderTip, DELIVFEE: orderDelivFee, PICKUP: isPickup, CASH: isCash, REFUND: 0.0, NOTES: "No notes have been written for this order.")
            
        var pickupText = ""
        var cashText = ""
            
        
        if isPickup {
            pickupText = "Pickup"
        } else {
            pickupText = "Delivery"
        }
            
        if isCash {
            cashText = "Cash"
        } else {
            cashText = "Credit"
        }
        
            
            
        let alertMessage = "Name: \(orderName)\n Address: \(orderAddress)\n Vendor: \(orderVendor)\n Price: \(orderPrice)\n Tip: \(orderTip)\n Delivery Fee: \(orderDelivFee)\n \(cashText) \(pickupText) \n"
        createAlert(title: "Order Added", message: alertMessage)
        
        let orderInfo = [
            "name":         theOrder.getName(),
            "price":        theOrder.getPrice(),
            "address":      theOrder.getAddress(),
            "vendor":       theOrder.getVendor(),
            "notes":        theOrder.getNotes(),
            "delivery fee": theOrder.getDeliveryFee(),
            "tip":          theOrder.getTip(),
            "cash":         theOrder.getCash(),
            "refund":       theOrder.getRefund(),
            "pickup":       theOrder.getPickup()
            ] as [String : Any]
        
        self.ref.child("orders").child(theOrder.getName()).setValue(orderInfo)
        
        displayAfterOrderAdded()
        
        //
        // Refresh Tableview
        //
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    } //end addOrder

    func displayAfterOrderAdded() {
        self.tf_CustomerName.text = ""
        
        if (self.pickupdeliverySeg.selectedSegmentIndex == 0) {
            
            self.tf_CustomerAddr.text = "Pickup"
            
        } else {
            
            self.tf_CustomerAddr.text = ""
            
        }
        
        self.tf_Vendor.text = ""
        self.tf_Price.text = ""
        self.tf_Tip.text = "0"
        self.tf_DeliveryFee.text = "0"
        self.delivFeeSegControl.selectedSegmentIndex = 0
        
        getOrders()

    }
    
    //
    //MARK: Segues
    //
    
    @IBAction func endofday(_ sender: Any) {

    }
    
    @IBAction func unwindToOrdersView(segue: UIStoryboardSegue) {
        

    }
    
    //
    // Prepare to display order information in a detailed view
    //
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailseg")
        {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let destVC = segue.destination as! Cell_ViewController
                
                for o in self.orderslist {
                    destVC.orderslist.append(o)
                    print(o.getDeliveryFee())
                }
                
                destVC.orderIndex = indexPath.row
                
            } // end indexPath -- should not ever be null -- however gets information for selected cell
        } //end detailseg option
    } //end prepareforseg
    
    
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
                
                var beenAdded = false
                
                for o in self.orderslist {
                    if (o.getName() == order.getName() && o.getPrice() == order.getPrice() && o.getVendor() == order.getVendor()) {
                        beenAdded = true
                    }
                }
                
                if (!beenAdded) {
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
    // used to dismiss keyboards
    //
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // Initialize database reference and display
        // orders from FirebaseDatabase inside of table view
        //
        
        ref = Database.database().reference()

        //
        // initially display view for pickup
        //
        
        displayForPickup()
        
        getOrders()
        
      
        //
        //creating done button to close keyboards
        //
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([doneButton], animated: false)
        
        //
        // adding done button to keyboards
        //
        
        tf_CustomerName.inputAccessoryView = toolBar
        tf_Price.inputAccessoryView = toolBar
        tf_Tip.inputAccessoryView = toolBar
        tf_DeliveryFee.inputAccessoryView = toolBar
        tf_CustomerAddr.inputAccessoryView = toolBar
        
        tf_Price.keyboardType = UIKeyboardType.decimalPad
        tf_Tip.keyboardType = UIKeyboardType.decimalPad
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

