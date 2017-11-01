//
//  Cell_ViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 5/20/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit
import FirebaseDatabase

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

    
    @IBAction func backtomainmenu(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)

    }
    

    //MARK: Edit/Save button used to change order notes
    
    @IBOutlet weak var editSaveButton: UIButton!
    
    @IBAction func editSaveClicked(_ sender: Any) {
        
        if editSaveButton.currentTitle == "Edit Note" {
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
            
            //
            // if string is couple characters off, just correct it
            //
            
            if  (newNotes == "No notes have been written for this")        ||
                (newNotes == "No notes have been written for this ")       ||
                (newNotes == "No notes have been written for this o")      ||
                (newNotes == "No notes have been written for this or")     ||
                (newNotes == "No notes have been written for this ord")    ||
                (newNotes == "No notes have been written for this orde")   ||
                (newNotes == "No notes have been written for this order")  ||
                (newNotes == "No notes have been written for this orderr") ||
                (newNotes == "No notes have been written for this order..") {
                 newNotes = "No notes have been written for this order."
            }
            
            
            //
            // TODO: Fetch note part of database entry and update
            //
            
            
            
            

        }
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
    // Prepare each piece of data to be edited in next view
    //
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editorderseg")
        {
            let destVC = segue.destination as! EditOrder_ViewController
            
            let anOrder = newOrder(NAME: orderInQuestion.getName(), ADDRESS: orderInQuestion.getAddress(), VENDOR: orderInQuestion.getVendor(), PRICE: orderInQuestion.getPrice(), TIP: orderInQuestion.getTip(), DELIVFEE: orderInQuestion.getDeliveryFee(), PICKUP: orderInQuestion.getPickup(), CASH: orderInQuestion.getCash(), REFUND: orderInQuestion.getRefund(), NOTES: orderInQuestion.getNotes())
            
            
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
                

                for v in self.pickupvendorslist {
                    destVC.vendorslist.append(v)
                }

            } else {
                destVC.cPickupDelivery = "Delivery"
                destVC.cAddress = anOrder.getAddress()
                
                for v in self.deliveryvendorslist {
                    destVC.vendorslist.append(v)
                }

            }
            
            if (anOrder.getCash()) {
                destVC.cCashCredit = "Cash"
            } else {
                destVC.cCashCredit = "Credit"
            }
            
            
            } // end indexPath -- should not ever be null -- however gets information for selected cell
        } //end detailseg option
    
    //
    //used to dismiss keyboards
    //
    @objc func doneClicked(){
        view.endEditing(true)
    }

    @IBAction func unwindToCellView(segue: UIStoryboardSegue) {
        
        
    }
    
    func initLabels(order:newOrder) {
        name.text = order.getName()
        vendor.text = order.getVendor()
        address.text = order.getAddress()
        
        if (order.getCash()) {
            cashcredit.text = "Cash"
        } else {
            cashcredit.text = "Credit"
        }
        
        if (order.getPickup()) {
            pickupdelivery.text = "Pickup"
        } else {
            pickupdelivery.text = order.getAddress()
        }
        
        notes.text = order.getNotes()
        tip.text = order.getTip().description
        price.text = order.getPrice().description
        refund.text = order.getRefund().description
        deliveryfee.text = order.getDeliveryFee().description
    } //end initLabels()
    

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
                    }
                    
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
                
            }
            
        })
        
        
    } //end getDeliveryVendors
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //
        // Database reference
        //
        

        ref = Database.database().reference()

        
        //
        //Initially no edit will be done, so user cant change without clicking button
        //
        
        notes.isUserInteractionEnabled = false
    }
    
    //load each label with proper data before view appears
    override func viewWillAppear(_ animated: Bool) {
        
        //
        //creating done button to close keyboards
        //
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))

        //
        // adding done button to keyboards
        //
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.setItems([doneButton], animated: false)
        notes.inputAccessoryView = toolBar
        
        orderInQuestion = orderslist[orderIndex]
        

        initLabels(order: orderInQuestion)
        
        //
        // Prepare vendor for edit view
        //
        
        if (orderInQuestion.getPickup()) {
            getPickupVendors()
        } else {
            getDeliveryVendors()
        }
 
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    


}
