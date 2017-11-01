//
//  MainMenuViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 7/7/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MainMenuViewController: UIViewController {
    
    var ref:DatabaseReference!
    var orderslist = [newOrder]()


    func getOrders() {
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
                
                
                
            }
        })
        
        
    }
    
    //Prepare each piece of data to be edited in next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ordersseg")
        {
            let destVC = segue.destination as! OrdersViewController
            
            
            for o in self.orderslist {
                destVC.orderslist.append(o)
            }
            
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
                        for v in destVC.deliveryvendorslist {
                            if v.getName() == vendor.getName() {
                                beenAdded = true
                            }
                        }
                        
                        if (!beenAdded) {
                            destVC.deliveryvendorslist.append(vendor)
                        } 
                    }
                    
                }
                
            })
            
            
            
            
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
                        
                        for v in destVC.pickupvendorslist {
                            if v.getName() == vendor.getName() {
                                beenAdded = true
                            }
                        }
                        
                        if (!beenAdded) {
                            destVC.pickupvendorslist.append(vendor)
                            print("has pickup vendor in main menu")
                        } else {
                            print("not")
                        }
                        
                    }
                    
                    
                    
                }
                
            })
            
            
            
            
        } // end indexPath -- should not ever be null -- however gets information for selected cell
    } //end detailseg option


    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        getOrders()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func unwindToMainView(segue: UIStoryboardSegue) {
    }
    
}
