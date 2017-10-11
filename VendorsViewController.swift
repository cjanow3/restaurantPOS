//
//  VendorsViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 7/14/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit
import CoreData

class VendorsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //initialize variables for view to pickup for initial view
    var isPickup:Bool = true
    var isPickupString:String = "Pickup"
    var list = restaurantController.fetchVendorsStrings(pickupvendor: true)
    
    //MARK: Functions used to display appropriate data in table view
    @IBOutlet weak var vendorName: UITextField!
    
    func showPickup()
    {
        list = restaurantController.fetchVendorsStrings(pickupvendor: true)
        isPickup = true
        isPickupString = "Pickup"

    }
    
    func showDelivery()
    {
        list = restaurantController.fetchVendorsStrings(pickupvendor: false)
        isPickup = false
        isPickupString = "Delivery"
    }
    
    //MARK: Segmented Control
    @IBOutlet weak var pickupDeliverySeg: UISegmentedControl!
    
    @IBAction func changePickup(_ sender: Any)
    {
        switch pickupDeliverySeg.selectedSegmentIndex
        {
        case 0:
            showPickup()
    
        case 1:
            showDelivery()
        default:
            break
        }
    } //end seg action function
    
    
    
    //MARK: Table View functions
    var refresher: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "vendorCell", for: indexPath) as! VendorTableViewCell
        
        cell.vendorName.text = list[indexPath.row]
                
        return cell
    }
    
    @objc func populate() {
        
        if pickupDeliverySeg.selectedSegmentIndex == 0
        {
            list = restaurantController.fetchVendorsStrings(pickupvendor: true)
            refresher.endRefreshing()
            tableView.reloadData()
        } else
        {
            list = restaurantController.fetchVendorsStrings(pickupvendor: false)
            refresher.endRefreshing()
            tableView.reloadData()
        }

    }
    
    //Delete button
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete)
        {
            
            let fetchRequest:NSFetchRequest<Vendor> = Vendor.fetchRequest();
            
            let predicate = NSPredicate(format: "name contains[c] %@", list[indexPath.row])
            
            fetchRequest.predicate = predicate;
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest:
                fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            do {
                print("Deleting specific content(s)")
                //Print are you sure message alert -- yes or no buttons
                try restaurantController.getContext().execute(deleteRequest)
                
            } catch {
                
                print(error.localizedDescription)
                return
            }
            
            
            
            list.remove(at: indexPath.row)
            
            tableView.reloadData()
        }
    }

    //MARK: Save button to add new vendor -- has confirmation in UIAlert
    @IBAction func save(_ sender: Any) {

        
        guard let name = vendorName.text else {
            createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
            return

        }
        
        //create an alert to notify user about no input
        if name == "" {
            
            createSimpleAlert(title: "No input", message: "There was no input for a vendor name, try again.")
            
        //create a vendor item and pass it into a ui alert to determine whether to store or not
        } else {
            
            let newVendor = restaurantController.VendorItem(NAME: name, CASH: 0.0, CREDIT: 0.0, TOTAL: 0.0, NUM: 0,PICKUP: isPickup, REFUND: 0.0)
            
            createAlert(title: "Is this correct?", message: "Name: '\(name)'\n\nType: \(isPickupString)", theVendor: newVendor)
        }
        
        
        

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
    
    //used to dismiss keyboards
    @objc func doneClicked()
    {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //adding refresher to table view
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Updating...")
        refresher.addTarget(self, action: #selector(VendorsViewController.populate), for: .valueChanged)
        tableView.addSubview(refresher)

        //creating done button to close keyboards
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
    
    //pickup --  Amazon Caviar Doordash Eat24 Grubhub Postmates Uber
    //Delivery.com Eat24 Foodler Groupon Grubhub Seamless SLICE In Store



}
