//
//  VendorsViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 7/14/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit


class VendorsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var isPickup:Bool = true
    var isPickupString:String = "Pickup"
    
    @IBOutlet weak var vendorName: UITextField!
    
    
    let list = restaurantController.fetchVendors()
    
    //MARK: Segmented Control
    @IBOutlet weak var pickupDeliverySeg: UISegmentedControl!
    
    @IBAction func changePickup(_ sender: Any)
    {
        switch pickupDeliverySeg.selectedSegmentIndex
        {
        case 0:
            isPickup = true
            isPickupString = "Pickup"
        case 1:
            isPickup = false
            isPickupString = "Delivery"
        default:
            break
        }
    } //end seg action function
    
    
    //MARK: Table View functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "vendorCell", for: indexPath) as! VendorTableViewCell
        
        cell.vendorName.text = list[indexPath.row].getName()
                
        return cell
    }
    
    
    //MARK: Save button to add new vendor -- has confirmation in UIAlert
    @IBAction func save(_ sender: Any) {

        
            guard let name = vendorName.text else {
                createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                return

            }
        
            let newVendor = restaurantController.VendorItem(NAME: name, CASH: 0.0, CREDIT: 0.0, TOTAL: 0.0, NUM: 0,PICKUP: isPickup)
            
            createAlert(title: "Is this correct?", message: "Name: '\(name)'\n\nType: \(isPickupString)", theVendor: newVendor)

    }
    
    //MARK: Alert functions
    func createAlert(title: String, message: String, theVendor:restaurantController.VendorItem) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //create cancel action
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //create ok action
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) -> Void in print("OK")
            
            restaurantController.storeVendor_OBJECT(newVendor: theVendor)
            
            
            self.vendorName.text = ""
            
            
        })
        
        alert.addAction(cancel)
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
        
    }

    
    func createSimpleAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    } //end alert functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
              // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
