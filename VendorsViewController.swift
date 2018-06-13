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
    var uid:String = ""
    
    @IBOutlet weak var vendorsHeader: UILabel!
    
    @IBOutlet weak var mainMenuButton: UIButton!
    @IBOutlet weak var newVendorButton: UIButton!
    //
    // - initialize variables for pickup as initial view
    // - create lists that will display vendors
    //
    
    var isPickup:Bool = true
    
    var pickupvendorslist = [newVendor]()
    var deliveryvendorslist = [newVendor]()
    
    var newNameTF: UITextField?


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
    
        case 1:
            isPickup = false
            getDeliveryVendors()
            
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
                //
                // Delete note and refresh with confirmation alert
                //
                
                let vendorname = self.pickupvendorslist[indexPath.row].getName()
                
                let alert = UIAlertController(title: "Confirm Deletion", message: "Really delete '" + vendorname + "'?", preferredStyle: .alert)
                let vc = UIViewController()
                vc.preferredContentSize = CGSize(width: 250,height: 30)
                
                alert.setValue(vc, forKey: "contentViewController")
                
                let ok = UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction) -> Void in
                    self.ref.child("vendors").child("pickup vendors").child(self.pickupvendorslist[indexPath.row].getName()).removeValue()
                    self.zeroOutVendorData()
                    self.getPickupVendors()
                })
                
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancel)
                alert.addAction(ok)
                
                self.present(alert, animated: true, completion: nil)
                
            case 1:
                //
                // Delete note and refresh with confirmation alert
                //
                
                let vendorname = self.deliveryvendorslist[indexPath.row].getName()
                
                let alert = UIAlertController(title: "Confirm Deletion", message: "Really delete '" + vendorname + "'?", preferredStyle: .alert)
                let vc = UIViewController()
                vc.preferredContentSize = CGSize(width: 250,height: 30)
                
                alert.setValue(vc, forKey: "contentViewController")
                
                let ok = UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction) -> Void in
                    self.ref.child("vendors").child("delivery vendors").child(self.deliveryvendorslist[indexPath.row].getName()).removeValue()
                    self.zeroOutVendorData()
                    self.getDeliveryVendors()
                })
                
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancel)
                alert.addAction(ok)
                
                self.present(alert, animated: true, completion: nil)

            default:
                break
            }
            
        }
    }
 

    //
    // New button to add new vendor to FirebaseDatabae -- has confirmation in verifyNewVendorInUIAlert
    //
    
    @IBAction func save(_ sender: Any) {
        
        var pickupdeliverystring = ""
        
        if (isPickup) {
            pickupdeliverystring = "Pickup"
        } else {
            pickupdeliverystring = "Delivery"
        }
        createAlertAddVendor(title: "New Vendor", message: "Pickup/Delivery: " + pickupdeliverystring)
    }
    
    //
    // MARK: Alert functions
    //
    
    func verifyNewVendorInUIAlert(title: String, message: String, theVendor: newVendor) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //create cancel action
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //create ok action
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) -> Void in
            
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
            }
            
            self.vendorName.text = ""
            
            
            //
            // Refresh table view
            //
            
            DispatchQueue.main.async {
                self.tableView.reloadData()

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
        
    } //end getPickupVendors
    
    
    //
    // Grabs all delivery vendors from FirebaseDatabase and refreshes table view
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
        
    } //end getDeliveryVendors
    
    //
    // used to dismiss keyboards
    //
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    func nameTFSetup(textfield: UITextField!) {
        newNameTF = textfield
        newNameTF?.placeholder = "Name"
    }
    
    func createAlertAddVendor(title: String, message: String)
    {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nameTFSetup)

        
        let ok = UIAlertAction(title: "Add", style: .default, handler: { (action: UIAlertAction) -> Void in print("OK")
            
            guard var name = self.newNameTF?.text! else {
                self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                return
            }
            
            //
            // Checks for arbitrary amount of spaces
            //
            
            let tempName = name.trimmingCharacters(in: .whitespaces)
            
            if tempName != "" {
                
                name = name.capitalizeFirstLetter()
                
                let theVendor = newVendor(NAME: name, CASH: 0.0, CREDIT: 0.0, TOTAL: 0.0, NUM: 0,PICKUP: self.isPickup, REFUND: 0.0)
                
                if (theVendor.getPickup()) {
                    
                    let vendorInfo = [
                        "name":  theVendor.getName(),
                        "cash":     theVendor.getCash(),
                        "credit":   theVendor.getCredit(),
                        "total":    theVendor.getTotal(),
                        "num":      theVendor.getNum(),
                        "refund":   theVendor.getRefund(),
                        "pickup":   theVendor.getPickup()
                        ] as [String : Any]
                    
                    self.ref.child("vendors").child("pickup vendors").child(theVendor.getName()).setValue(vendorInfo)
                    
                    self.getPickupVendors()
                    
                    
                } else {
                    
                    let vendorInfo = [
                        "name":     theVendor.getName(),
                        "cash":     theVendor.getCash(),
                        "credit":   theVendor.getCredit(),
                        "total":    theVendor.getTotal(),
                        "num":      theVendor.getNum(),
                        "refund":   theVendor.getRefund(),
                        "pickup":   theVendor.getPickup()
                        ] as [String : Any]
                    
                    
                    self.ref.child("vendors").child("delivery vendors").child(theVendor.getName()).setValue(vendorInfo)
                    
                    self.getDeliveryVendors()
                }
                
            }
            
            
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    //
    // Changes total in database to 0 to prevent doubled values
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
    
    func initView() {
        newVendorButton.layer.cornerRadius = 10
        newVendorButton.layer.masksToBounds = true
        newVendorButton.layer.borderColor = UIColor.black.cgColor
        newVendorButton.layer.borderWidth = 0.5
        newVendorButton.layer.shadowColor = UIColor.black.cgColor
        newVendorButton.layer.shadowOffset = CGSize.zero
        newVendorButton.layer.shadowRadius = 5.0
        newVendorButton.layer.shadowOpacity = 0.5
        newVendorButton.clipsToBounds = false
        
        mainMenuButton.layer.cornerRadius = 10
        mainMenuButton.layer.masksToBounds = true
        mainMenuButton.layer.borderColor = UIColor.black.cgColor
        mainMenuButton.layer.borderWidth = 0.5
        mainMenuButton.layer.shadowColor = UIColor.black.cgColor
        mainMenuButton.layer.shadowOffset = CGSize.zero
        mainMenuButton.layer.shadowRadius = 5.0
        mainMenuButton.layer.shadowOpacity = 0.5
        mainMenuButton.clipsToBounds = false
        
        pickupDeliverySeg.layer.borderColor = UIColor.black.cgColor
        pickupDeliverySeg.layer.borderWidth = 1.0
        
        let strokeTextAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.strokeColor : UIColor.black,
            NSAttributedStringKey.foregroundColor : UIColor.white,
            NSAttributedStringKey.strokeWidth : -2.0,
            ]
        
        vendorsHeader.attributedText = NSAttributedString(string: "Vendors", attributes: strokeTextAttributes)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //
        // Initialize database reference and
        // display pickup vendors in table view
        //

        ref = Database.database().reference().child("users").child(uid)

        getPickupVendors()

        initView()

        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
