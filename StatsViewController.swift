//
//  StatsViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 7/27/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit
import CoreData

class StatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //used to update vendors through coredata
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = restaurantController.getContext()

    
    //MARK: Segmented Control
    @IBOutlet weak var pickupDeliveryDriverSeg: UISegmentedControl!
    
    /*@IBAction func changeCell(_ sender: Any)
    {
        switch pickupDeliveryDriverSeg.selectedSegmentIndex
        {
        //case 0:
        //case 1:
        //case 2:
        default:
            
        }
    }
    */
    //MARK: Table View
    @IBOutlet weak var tableView: UITableView!
    let list = restaurantController.fetchPickupVendors()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
       /* switch pickupDeliveryDriverSeg.selectedSegmentIndex
        {
        case 0:
            let list = restaurantController.fetchPickupVendors()
            return list.count + 1
            
        case 1:
            let list = restaurantController.fetchDeliveryVendors()
            return list.count + 1
            
        case 2:
            let list = restaurantController.fetchDeliveryVendors()
            return list .count + 1
        default:
            return 0

        }*/
        
        return list.count + 1


    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "totalVendorStatsCell", for: indexPath) as! vendorTotalStatsTableViewCell
            let list = restaurantController.fetchPickupVendors()
            
            var totrefunds = 0.0
            var totcash = 0.0
            var totcredit = 0.0
            var tottotal = 0.0
            var totnum = 0
            
            for res in list
            {
                totcash += res.getCash()
                totcredit += res.getCredit()
                totnum += res.getNum()
                totrefunds += res.getRefund()
                
                  
            }
            
            tottotal = totcash + totcredit
            
            
            cell.credit.text = totcredit.description
            cell.cash.text = totcash.description
            cell.num.text = totnum.description
            cell.refunds.text = totrefunds.description
            cell.total.text = tottotal.description
            
            return cell

            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "vendorStatsCell", for: indexPath) as! vendorStatsTableViewCell
            
            let list = restaurantController.fetchPickupVendors()
            
            //fill cells from returned list
            
            cell.vendorName.text = list[indexPath.row - 1].getName()
            cell.cash.text = list[indexPath.row - 1].getCash().description
            cell.credit.text = list[indexPath.row - 1].getCredit().description
            cell.total.text = list[indexPath.row - 1].getTotal().description
            cell.num.text = list[indexPath.row - 1].getNum().description
            
 
            return cell

        }
        


    }
    
        
    func separateData()
    {
        
        restaurantController.zeroOutVendors()
        
        //get request for entity
        let vendorRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Vendor")
        
        let orderRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
        
        do {
            
            let orderResults = try context.fetch(orderRequest)
            let vendorResults = try context.fetch(vendorRequest)
            
            for order in orderResults as! [NSManagedObject]
            {
                for vendor in vendorResults as! [NSManagedObject]
                {
                    //
                    // For every order, go through all vendors 
                    // Check if the order's vendor == vendor's name
                    // and if the pickup/delivery key matches
                    // if so -- include totals for that vendor for that paricular order
                    //
                    
                    if ( (order.value(forKey: "vendor") as? String) != nil && (vendor.value(forKey: "name") as? String) != nil && (order.value(forKey: "vendor") as? String) == (vendor.value(forKey: "name") as? String) )
                    {
                        if (order.value(forKey: "pickup") as? Bool != nil && vendor.value(forKey: "pickup") as? Bool != nil && order.value(forKey: "pickup") as? Bool == vendor.value(forKey: "pickup") as? Bool)
                        {
                            //set new total for total
                            let orderPrice = order.value(forKey: "price") as? Double
                            let vendorTotal = vendor.value(forKey: "total") as? Double
                            let newTotal = orderPrice! + vendorTotal!
                            vendor.setValue(newTotal, forKey: "total")
                            
                            //set new total for num
                            let vendorNum = vendor.value(forKey: "num") as? Int
                            let newNum = vendorNum! + 1
                            vendor.setValue(newNum, forKey: "num")
                            
                            //set new total for refund
                            let orderRefund = order.value(forKey: "refund") as? Double
                            let vendorRefund = vendor.value(forKey: "refund") as? Double
                            let newRefund = orderRefund! + vendorRefund!
                            vendor.setValue(newRefund, forKey: "refund")
                            
                            if (order.value(forKey: "cash") as? Bool != nil && order.value(forKey: "cash") as? Bool == true)
                            {
                                //set new total for cash
                                let orderPrice = order.value(forKey: "price") as? Double
                                let vendorCash = vendor.value(forKey: "cash") as? Double
                                let newTotal = orderPrice! + vendorCash!
                                vendor.setValue(newTotal, forKey: "cash")
                                
                            } else {
                                //set new total for credit
                                let orderPrice = order.value(forKey: "price") as? Double
                                let vendorCredit = vendor.value(forKey: "credit") as? Double
                                let newTotal = orderPrice! + vendorCredit!
                                vendor.setValue(newTotal, forKey: "credit")
                            }
                        }
                        
                        

                    }
                }
            }
            
        } catch {
            print(error.localizedDescription)
            return
        }
        
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        separateData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    
}
