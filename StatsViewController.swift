//
//  StatsViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 7/27/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
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
            
            let list = restaurantController.fetchVendors()
            
            cell.vendorName.text = list[indexPath.row-1].getName()
            cell.cash.text = list[indexPath.row-1].getCash().description
            cell.credit.text = list[indexPath.row-1].getCredit().description
            cell.total.text = list[indexPath.row-1].getTotal().description
            cell.num.text = list[indexPath.row-1].getNum().description
            
            return cell

        }
        


    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        var vendors = restaurantController.fetchVendors()
        var orders = restaurantController.fetchOrders()

        
       /* for order in orders
        {
            for vendor in vendors
            {
                if order.getVendor() == vendor.getName()
                {
                    vendor.setTotal(TOTAL: vendor.getTotal() + order.getPrice())
                }
            }
        }*/
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    
}
