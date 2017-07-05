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

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    //MARK: Text fields for customer input
    
    @IBOutlet weak var tf_CustomerName: UITextField!
    @IBOutlet weak var tf_CustomerAddr: UITextField!
    @IBOutlet weak var tf_Price: UITextField!
    @IBOutlet weak var tf_Vendor: UITextField!
    @IBOutlet weak var tf_Tip: UITextField!
    @IBOutlet weak var tf_DeliveryFee: UITextField!
    
    
    //MARK: Picker View for vendor -- includes list and functions needed for picker view
    let pickupVendors =   ["Amazon", "Caviar", "Doordash", "Eat24", "Grubhub", "Postmates", "Uber"]
    let deliveryVendors = ["Delivery.com", "Eat24", "Foodler", "Groupon", "Grubhub","In Store", "Seamless", "SLICE"]
    
    @IBOutlet weak var pickupVendorPicker: UIPickerView!
    @IBOutlet weak var deliveryVendorPicker: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == pickupVendorPicker
        {
            return pickupVendors[row]
        }
        
        else if pickerView == deliveryVendorPicker
        {
            return deliveryVendors[row]
        }
        
        else
        {
            return ""
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == pickupVendorPicker
        {
            return pickupVendors.count
        }
            
        else if pickerView == deliveryVendorPicker
        {
            return deliveryVendors.count
        }
            
        else
        {
            return 1
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if pickerView == pickupVendorPicker
        {
            tf_Vendor.text = pickupVendors[row]
        }
            
        else if pickerView == deliveryVendorPicker
        {
            tf_Vendor.text = deliveryVendors[row]
        }

    }
    //end picker view
    
    
    
    //MARK: Table View initialization and refresh control
    
    @IBOutlet weak var tableView: UITableView!
    var list = restaurantController.fetchOrders()
    var refresher: UIRefreshControl!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        
        cell.orderName.text = list[indexPath.row].getName()
        cell.orderVendor.text = list[indexPath.row].getVendor()
        let price = list[indexPath.row].getPrice() - list[indexPath.row].getRefund()
        cell.orderPrice.text = price.description
        
        if (list[indexPath.row].getPickup())
        {
            cell.orderPickupDelivery.text = "Pickup"

        }else{
            cell.orderPickupDelivery.text = "Delivery"
        }
        
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete)
        {
            
            let fetchRequest:NSFetchRequest<Order> = Order.fetchRequest();
            
            let predicate = NSPredicate(format: "name contains[c] %@", list[indexPath.row].getName())
            
            fetchRequest.predicate = predicate;
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest:
                fetchRequest as! NSFetchRequest<NSFetchRequestResult>);
            
            do {
                print("Deleting specific content(s)");
                //Print are you sure message alert -- yes or no buttons
                try restaurantController.getContext().execute(deleteRequest);
                
            } catch {
                
                print(error.localizedDescription);
            }


            
            list.remove(at: indexPath.row)
            
            tableView.reloadData()
        }
    }
    
    func populate() {
        
        list = restaurantController.fetchOrders()
        
        refresher.endRefreshing()
        tableView.reloadData()
    }
    //end table view functions and init
    
        
    //MARK: Segmented Control - pickup/delivery & cash/credit options
    
    @IBOutlet weak var pickupdeliverySeg: UISegmentedControl!
    @IBOutlet weak var cashcreditSeg: UISegmentedControl!
    
    //pickup/delivery
    @IBAction func pickupdelivery(_ sender: Any) {
        
        switch pickupdeliverySeg.selectedSegmentIndex {
            
        case 0:
            displayForPickup()
            
        case 1:
            displayForDelivery()
            
            
        default:
            break;
        }
    }
    
    func displayForPickup()
    {
        isPickup = true;
        tf_CustomerAddr.isUserInteractionEnabled = false
        tf_DeliveryFee.isUserInteractionEnabled = false
        tf_CustomerAddr.text = "Pickup"
        tf_DeliveryFee.text = "0"
        pickupVendorPicker.isHidden = false
        deliveryVendorPicker.isHidden = true
    }
    
    func displayForDelivery()
    {
        isPickup = false;
        tf_CustomerAddr.isUserInteractionEnabled = true
        tf_DeliveryFee.isUserInteractionEnabled = true
        tf_CustomerAddr.text = ""
        tf_DeliveryFee.text = "0"
        pickupVendorPicker.isHidden = true
        deliveryVendorPicker.isHidden = false
    }
    
    func changeIsCash(cash:Bool)
    {
        isCash = cash
    }
    
    //cash/credit
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
    //end segmented control
    
    
    
    
    //MARK: UIAlert functions
    func createSimpleAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func createAlert(title: String, message: String, theOrder:restaurantController.OrderItem) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //create cancel action
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //create ok action
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) -> Void in print("OK")
            
            restaurantController.storeOrder_OBJECT(newOrder: theOrder)
            
            
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
            
        })
        
        alert.addAction(cancel)
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    //end alert functions

    
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
            
            //Another check to see if Groupon, SLICE, or Seamless were inputted with cash -- it is credit only
            if ( isCash && (orderVendor == "Groupon" || orderVendor == "SLICE" || orderVendor == "Seamless") )
            {
                createSimpleAlert(title: "Check input", message: "Attempted to add order with vendor that doesn't accept cash.")
            } else {
                
                
                let anOrder = restaurantController.OrderItem(NAME: orderName, ADDRESS: orderAddress, VENDOR: orderVendor, PRICE: orderPrice, TIP: orderTip, DELIVFEE: orderDelivFee, PICKUP: isPickup, CASH: isCash, REFUND: 0.0)
                
                
                if (isPickup)
                {
                    //if (anOrder.getVendor())
                    if (isCash)
                    {
                        createAlert(title: "Is this correct?", message: "Name: \(tf_CustomerName.text!)\n Address: \(tf_CustomerAddr.text!)\n Vendor: \(tf_Vendor.text!)\n Price: \(tf_Price.text!)\n Tip: \(tf_Tip.text!)\n Delivery Fee: \(tf_DeliveryFee.text!)\n Cash Pickup\n", theOrder: anOrder)
                    }else{
                        createAlert(title: "Is this correct?", message: "Name: \(tf_CustomerName.text!)\n Address: \(tf_CustomerAddr.text!)\n Vendor: \(tf_Vendor.text!)\n Price: \(tf_Price.text!)\n Tip: \(tf_Tip.text!)\n Delivery Fee: \(tf_DeliveryFee.text!)\n Credit Pickup\n", theOrder: anOrder)
                    }
                    
                }else
                {
                    if (isCash)
                    {
                        createAlert(title: "Is this correct?", message: "Name: \(tf_CustomerName.text!)\n Address: \(tf_CustomerAddr.text!)\n Vendor: \(tf_Vendor.text!)\n Price: \(tf_Price.text!)\n Tip: \(tf_Tip.text!)\n Delivery Fee: \(tf_DeliveryFee.text!)\n Cash Delivery\n", theOrder: anOrder)
                    }else{
                        createAlert(title: "Is this correct?", message: "Name: \(tf_CustomerName.text!)\n Address: \(tf_CustomerAddr.text!)\n Vendor: \(tf_Vendor.text!)\n Price: \(tf_Price.text!)\n Tip: \(tf_Tip.text!)\n Delivery Fee: \(tf_DeliveryFee.text!)\n Credit Delivery\n", theOrder: anOrder)
                    }
                    
                }
                
            }
            

            
            
        }
    } //end addOrder

    
    
    //MARK: Segues
    
    @IBAction func endofday(_ sender: Any) {
        //performSegue(withIdentifier: "endofdayseg", sender: self)
    }
    
    @IBAction func unwindView(segue: UIStoryboardSegue) {
        
        //print("unwindEODView fired in View Controller")
        
        if segue.source is OrderStatsViewController
        {
            //do something here if we want to pass info from previous seg (EOD)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailseg")
        {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let destVC = segue.destination as! Cell_ViewController
                
                destVC.cName = list[indexPath.row].getName()
                destVC.cVendor = list[indexPath.row].getVendor()
                destVC.cTip = list[indexPath.row].getTip()
                destVC.cPrice = list[indexPath.row].getPrice()
                destVC.cDeliveryFee = list[indexPath.row].getDeliveryFee()
                destVC.cRefund = list[indexPath.row].getRefund()
                
                destVC.cCash = list[indexPath.row].getCash()
                destVC.cPickup = list[indexPath.row].getPickup()
                
                //determine if pickup/delivery -- also update address accordingly
                if (list[indexPath.row].getPickup()) {
                    destVC.cPickupDelivery = "Pickup"
                    destVC.cAddress = "None -- Pickup"
                    
                } else {
                    destVC.cPickupDelivery = "Delivery"
                    destVC.cAddress = list[indexPath.row].getAddress()
                }
                
                //determine if cash/credit
                if (list[indexPath.row].getCash())
                {
                    destVC.cCashCredit = "Cash"
                } else {
                    destVC.cCashCredit = "Credit"
                }
                
            } // end indexPath -- should not ever be null -- however gets information for selected cell
        } //end detailseg option
    } //end prepareforseg

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Updating...")
        refresher.addTarget(self, action: #selector(ViewController.populate), for: .valueChanged)
        tableView.addSubview(refresher)
        
        tf_Vendor.isUserInteractionEnabled = false
        tf_CustomerAddr.isUserInteractionEnabled = false

        pickupVendorPicker.isHidden = false
        deliveryVendorPicker.isHidden = true
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

