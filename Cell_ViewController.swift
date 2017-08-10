//
//  Cell_ViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 5/20/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit
import CoreData

class Cell_ViewController: UIViewController {

    
    //MARK: Labels and respective variables used for those labels
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var vendor: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var cashcredit: UILabel!
    @IBOutlet weak var pickupdelivery: UILabel!
    
    @IBOutlet weak var notes: UITextField!
    
    @IBOutlet weak var tip: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var deliveryfee: UILabel!
    @IBOutlet weak var refund: UILabel!
    
    var cName:String?
    var cVendor:String?
    var cAddress:String?
    var cCashCredit:String?
    var cPickupDelivery:String?
    var cNotes:String?
    
    var cPickup:Bool?
    var cCash:Bool?
    
    var cTip:Double?
    var cDeliveryFee:Double?
    var cPrice:Double?
    var cRefund:Double?
    
    //used to update notes through coredata
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = restaurantController.getContext()

    
    @IBAction func backtomainmenu(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)

    }
    

    //MARK: Edit/Save button used to change order notes
    
    @IBOutlet weak var editSaveButton: UIButton!
    
    @IBAction func editSaveClicked(_ sender: Any) {
        
        if editSaveButton.currentTitle == "Edit Note"
        {
            //
            //Change button title from "Edit" to "Save"
            //allow user to change notes text field
            //save the current text inside the text field
            //update the current text field to what it was saved to
            //
            
            editSaveButton.setTitle("Save", for: .normal)
            notes.isUserInteractionEnabled = true
            
            
            
        } else {
            editSaveButton.setTitle("Edit Note", for: .normal)
            notes.isUserInteractionEnabled = false
            
            guard var newNotes = notes.text else {
                createSimpleAlert(title: "Need input", message: "")
                return
            }
            
            // if string is couple characters off, just correct it
            if  (newNotes == "No notes have been written for this")        ||
                (newNotes == "No notes have been written for this ")       ||
                (newNotes == "No notes have been written for this o")      ||
                (newNotes == "No notes have been written for this or")     ||
                (newNotes == "No notes have been written for this ord")    ||
                (newNotes == "No notes have been written for this orde")   ||
                (newNotes == "No notes have been written for this order")  ||
                (newNotes == "No notes have been written for this orderr") ||
                (newNotes == "No notes have been written for this order..")
            {
                newNotes = "No notes have been written for this order."
            }
            
            
            //get request for order entity
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")

            do {
                
                let results = try context.fetch(request)
                
                for result in results as! [NSManagedObject]
                {
                    if ( (result.value(forKey: "notes") as? String) != nil &&  (result.value(forKey: "notes") as? String) == cNotes && (result.value(forKey: "name") as? String) != nil && (result.value(forKey: "name") as? String) == cName )
                    {
                        //Dont want to create alert if we are restoring to default string
                        if newNotes != "No notes have been written for this order."
                        {
                            createSimpleAlert(title: "Notes Edited", message: "Notes changed from '\(cNotes!)' to '\(newNotes)'")

                        }
                        
                        notes.text = newNotes
                        result.setValue(newNotes, forKey: "notes")
                        restaurantController.saveContext()

                    }
                }
                
            } catch {
                print(error.localizedDescription)
                return
            }


        }
    }
    
    //Alert function
    func createSimpleAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //Prepare each piece of data to be edited in next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editorderseg")
        {
            let destVC = segue.destination as! EditOrder_ViewController
            
            let anOrder = restaurantController.OrderItem(NAME: cName!, ADDRESS: cAddress!, VENDOR: cVendor!, PRICE: cPrice!, TIP: cTip!, DELIVFEE: cDeliveryFee!, PICKUP: cPickup!, CASH: cCash!, REFUND: cRefund!,NOTES:cNotes!)
            
            destVC.cName = anOrder.getName()
            destVC.cVendor = anOrder.getVendor()
            destVC.cTip = anOrder.getTip()
            destVC.cDeliveryFee = anOrder.getDeliveryFee()
            destVC.cRefund = anOrder.getRefund()
            destVC.cPickup = anOrder.getPickup()
            destVC.cCash = anOrder.getCash()
            destVC.cPrice = anOrder.getPrice()
            destVC.cRefund = anOrder.getRefund()
            
            
            if (anOrder.getPickup())
            {
                destVC.cPickupDelivery = "Pickup"
                destVC.cAddress = "None -- Pickup"
                destVC.vendors = restaurantController.fetchPickupVendors()
            } else {
                destVC.cPickupDelivery = "Delivery"
                destVC.cAddress = anOrder.getAddress()
                destVC.vendors = restaurantController.fetchDeliveryVendors()
            }
            
            if (anOrder.getCash())
            {
                destVC.cCashCredit = "Cash"
            } else {
                destVC.cCashCredit = "Credit"
            }
            
            
            } // end indexPath -- should not ever be null -- however gets information for selected cell
        } //end detailseg option

    @IBAction func unwindToCellView(segue: UIStoryboardSegue) {
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Initially no edit will be done, so user cant change without clicking button
        notes.isUserInteractionEnabled = false
    }
    
    //load each label with proper data before view appears
    override func viewWillAppear(_ animated: Bool) {
        
        if let cName = cName, let cVendor = cVendor, let cAddress = cAddress, let cCashCredit = cCashCredit, let cPickupDelivery = cPickupDelivery, let cTip = cTip, let cDeliveryFee = cDeliveryFee, let cPrice = cPrice, let cRefund = cRefund,let cNotes = cNotes {
            
            name.text = cName
            vendor.text = cVendor
            address.text = cAddress
            cashcredit.text = cCashCredit
            pickupdelivery.text = cPickupDelivery
            
            notes.text = cNotes
            
            tip.text = cTip.description
            price.text = cPrice.description
            deliveryfee.text = cDeliveryFee.description
            refund.text = cRefund.description
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    


}
