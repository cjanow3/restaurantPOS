//
//  VendorsViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 7/14/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit
import FirebaseDatabase

class VendorsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //
    // Create FirebaseDatabase reference
    //
    
    var ref:DatabaseReference!
    var refHandle: UInt!
    
    
    //
    // - initialize variables for pickup as initial view
    // - create lists that will display vendors
    //
    
    var isPickup:Bool = true
    
    var pickupvendorslist = [newVendor]()
    var deliveryvendorslist = [newVendor]()
    

    //
    // Functions used to display appropriate data in table view
    //
    
    @IBOutlet weak var vendorName: UITextField!
    
    //
    // Segmented Control
    //
    // If first index (0) is selected -- display pickup vendors
    // If second index (1) is selected -- display delivery vendors
    //
    // Vendors are taken from FirebaseDatabase
    //
    
    @IBOutlet weak var pickupDeliverySeg: UISegmentedControl!
    
    @IBAction func changePickup(_ sender: Any)
    {
        switch pickupDeliverySeg.selectedSegmentIndex
        {
        case 0:
            isPickup = true
            getPickupVendors()
            break
    
        case 1:
            isPickup = false
            getDeliveryVendors()
            break
            
        default:
            break
        }
    } //end seg action function
    

    //
    // Deselects row in table view
    //
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    @IBOutlet weak var tableView: UITableView!

    //
    // Returns appropriate count for rows in table view
    //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch pickupDeliverySeg.selectedSegmentIndex
        {
        case 0:
            return pickupvendorslist.count
            
        case 1:
            return deliveryvendorslist.count
            
        default:
            return 0
        }
        
    }
    
    //
    // Determines what is displayed in table view based on selected index
    //
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch pickupDeliverySeg.selectedSegmentIndex
        {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "vendorCell", for: indexPath) as! VendorTableViewCell
            
            let vendor = pickupvendorslist[indexPath.row]
            
            cell.vendorName.text = vendor.name
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "vendorCell", for: indexPath) as! VendorTableViewCell
            
            let vendor = deliveryvendorslist[indexPath.row]
            
            cell.vendorName.text = vendor.name
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "vendorCell", for: indexPath) as! VendorTableViewCell
            
            
            cell.vendorName.text = "nil"
            
            return cell
        }
        
        
    }

    //
    // Delete button - Removes vendor from database and updates table view
    //
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete)
        {
            
            switch pickupDeliverySeg.selectedSegmentIndex
            {
            case 0:
                ref.child("vendors").child("pickup vendors").child(pickupvendorslist[indexPath.row].getName()).removeValue()
                getPickupVendors()
                break
            case 1:
                ref.child("vendors").child("delivery vendors").child(deliveryvendorslist[indexPath.row].getName()).removeValue()
                getDeliveryVendors()
                break
            default:
                break
            }
            
        }
    }
 

    //
    // Save button to add new vendor to FirebaseDatabae -- has confirmation in verifyNewVendorInUIAlert
    //
    
    @IBAction func save(_ sender: Any) {
        guard let name = vendorName.text else {
            createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
            return
        }
        
        let aVendor = newVendor(NAME: name, CASH: 0.0, CREDIT: 0.0, TOTAL: 0.0, NUM: 0,PICKUP: isPickup, REFUND: 0.0)
        
        if (isPickup) {
            verifyNewVendorInUIAlert(title: "Is this correct?", message: "Name: '\(name)'\n\nType: Pickup", theVendor: aVendor.self)

        } else {
            verifyNewVendorInUIAlert(title: "Is this correct?", message: "Name: '\(name)'\n\nType: Delivery", theVendor: aVendor.self)

        }
            
        
        

    }
    
    //
    // MARK: Alert functions
    //
    
    func verifyNewVendorInUIAlert(title: String, message: String, theVendor: newVendor) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //create cancel action
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //create ok action
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) -> Void in print("OK")
            
            //
            // Stores vendor in firebase database
            //
            
            if (theVendor.getPickup()) {
                
                let vendorInfo = [
                    "name":  theVendor.getName(),
                    "cash": theVendor.getCash(),
                    "credit":   theVendor.getCredit(),
                    "total":   theVendor.getTotal(),
                    "num":   theVendor.getNum(),
                    "refund":   theVendor.getRefund(),
                    "pickup":   theVendor.getPickup()
                    ] as [String : Any]
                
                
                self.ref.child("vendors").child("pickup vendors").child(theVendor.getName()).setValue(vendorInfo)
                print(theVendor.getName() + " stored")
        
            } else {
                
                let vendorInfo = [
                    "name":  theVendor.getName(),
                    "cash": theVendor.getCash(),
                    "credit":   theVendor.getCredit(),
                    "total":   theVendor.getTotal(),
                    "num":   theVendor.getNum(),
                    "refund":   theVendor.getRefund(),
                    "pickup":   theVendor.getPickup()
                    ] as [String : Any]
                
                
                self.ref.child("vendors").child("delivery vendors").child(theVendor.getName()).setValue(vendorInfo)
                print(theVendor.getName() + " stored")
            }
            
            self.vendorName.text = ""
            
            
            //
            // Refresh table view
            //
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                print("tableview refreshed in OK alert button")

            }
            
        })
        
        alert.addAction(cancel)
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
        
    }

    //
    // Displays UIAlert with some text
    //
    
    func createSimpleAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    } //end alert functions
    
    
    //
    // Grabs all pickup vendors from FirebaseDatabase and refreshes table view
    //
    
    func getPickupVendors(){
        
        self.pickupvendorslist.removeAll()
        
        ref.child("vendors").child("pickup vendors").observe(.childAdded, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                let isaPickupOrder = dictionary["pickup"] as! Bool
                
                //
                // Determine if vendor is a pickup vendor
                //
                
                if (isaPickupOrder) {
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
                        print("has")
                    } else {
                        print("not")
                    }
                    
                }
                
                
                //
                // Refresh Tableview
                //
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
                
                
            }
            
        })
        
        
    } //end getPickupVendors
    
    
    //
    // Grabs all delivery vendors from FirebaseDatabase and refreshes table view
    //
    
    func getDeliveryVendors(){
        
        self.deliveryvendorslist.removeAll()
        
        ref.child("vendors").child("delivery vendors").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                let isaDeliveryOrder = dictionary["pickup"] as! Bool
                
                //
                // Determine if vendor is a delivery vendor
                //
                
                if (!isaDeliveryOrder) {
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
                    // NOTE: I feel like this is a workaround but I can't find a better solution...
                    //       Every time I click on opposite index in seg control, creates extra
                    //       objects when adding new vendor
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
                
                
                //
                // Refresh Tableview
                //
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            
        })
        
        
    } //end getDeliveryVendors
    
    //
    // used to dismiss keyboards
    //
    
    @objc func doneClicked()
    {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //
        // Initialize database reference and display table view for pickup vendors
        //
        
        ref = Database.database().reference()
        getPickupVendors()

        //
        //creating done button to close keyboards
        //
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([doneButton], animated: false)
        
        vendorName.inputAccessoryView = toolBar

        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
