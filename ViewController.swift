//
//  ViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 5/16/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit
import CoreData

var isPickup = true
var isCash = true

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Text fields for customer input
    
    @IBOutlet weak var tf_CustomerName: UITextField!
    @IBOutlet weak var tf_CustomerAddr: UITextField!
    @IBOutlet weak var tf_Price: UITextField!
    @IBOutlet weak var tf_Vendor: UITextField!
    @IBOutlet weak var tf_Tip: UITextField!
    @IBOutlet weak var tf_DeliveryFee: UITextField!
    
    //MARK: Picker View for vendor -- includes list and functions needed for picker view
    let vendors = ["Amazon" , "Caviar", "Delivery.com", "Doordash", "Eat24" , "Foodler", "Groupon", "Grubhub" , "In Store", "Postmates", "Seamless", "Slice", "Uber"]
    @IBOutlet weak var vendor_Picker: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return vendors[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return vendors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tf_Vendor.text = vendors[row]
    }
    //end picker view
    
    //MARK: Table View initialization
    
    let list = restaurantController.fetchOrders()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        
        cell.orderName.text = list[indexPath.row].name
        cell.orderVendor.text = list[indexPath.row].vendor
        cell.orderPrice.text = list[indexPath.row].price?.description
        if (list[indexPath.row].pickup)
        {
            cell.orderPickupDelivery.text = "Pickup"

        }else{
            cell.orderPickupDelivery.text = "Delivery"
        }
        
        return cell
    }
    
    
    //MARK: Segmented Control - pickup/delivery & cash/credit options
    
    @IBOutlet weak var pickupdeliverySeg: UISegmentedControl!
    @IBOutlet weak var cashcreditSeg: UISegmentedControl!
    
    //pickup/delivery
    @IBAction func pickupdelivery(_ sender: Any) {
        
        switch pickupdeliverySeg.selectedSegmentIndex
        {
        case 0:
            isPickup = true;
            //print("pickup")
        case 1:
            isPickup = false;
            //print("delivery")
        default:
            break;
        }
    }
    
    //cash/credit
    @IBAction func cashcredit(_ sender: Any) {
        
        switch cashcreditSeg.selectedSegmentIndex
        {
        case 0:
            isCash = true
            //print("cash")
        case 1:
            isCash = false
            //print("credit")
        default:
            break
        }

    }
    //end segmented control
    
    //MARK: UIAlert functions
    func createSimpleAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func createAlert(title: String, message: String, theOrder:restaurantController.OrderItem)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //create cancel action
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //create ok action
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) -> Void in print("OK")
            
            restaurantController.storeOrder_OBJECT(newOrder: theOrder)
            
            
            self.tf_CustomerName.text = ""
            self.tf_CustomerAddr.text = ""
            self.tf_Vendor.text = ""
            self.tf_Price.text = ""
            self.tf_Tip.text = "0"
            self.tf_DeliveryFee.text = "0"
            
        })
        
        alert.addAction(cancel)
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
        
    }


    
    //MARK: Add order to core data -- button
    
    @IBAction func addOrder(_ sender: Any) {
        
        if (tf_CustomerName.text == "")
        {
            createSimpleAlert(title: "Additional input required", message: "Name field was left blank")
        }
            
        else if (tf_CustomerAddr.text == "")
        {
            createSimpleAlert(title: "Additional input required", message: "Address field was left blank")
            
        }
            
        else if (tf_Price.text == "")
        {
            createSimpleAlert(title: "Additional input required", message: "Price field was left blank")
            
        }
            
        else if (tf_Vendor.text == "")
        {
            createSimpleAlert(title: "Additional input required", message: "Vendor field was left blank")
            
        }
            
        else
        {
            
            guard let orderName = self.tf_CustomerName.text, let orderAddress = self.tf_CustomerAddr.text, let orderVendor = self.tf_Vendor.text, let orderPrice = Double(self.tf_Price.text!), let orderTip = Double(self.tf_Tip.text!), let orderDelivFee = Double(self.tf_DeliveryFee.text!) else
            {
                createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                return
            }
            
            let anOrder = restaurantController.OrderItem(NAME: orderName, ADDRESS: orderAddress, VENDOR: orderVendor, PRICE: orderPrice, TIP: orderTip, DELIVFEE: orderDelivFee, PICKUP: isPickup, CASH: isCash)
            
            print(orderName)
            
            restaurantController.storeOrder_OBJECT(newOrder: anOrder)
                     
            
        }
    } //end addOrder

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

