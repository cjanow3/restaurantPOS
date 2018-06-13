//
//  StatsViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 7/27/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit
import FirebaseDatabase


class StatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var ref:DatabaseReference!
    var uid:String = ""

    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var statsHeader: UILabel!
    //
    // 1 of 3 potential lists will be used,
    // pre load all of them
    //
    
    var pickupvendorslist = [newVendor]()
    var deliveryvendorslist = [newVendor]()
    var deliveryorderslist = [newOrder]()

    //
    // MARK: Segmented Control definition
    //
    
    @IBOutlet weak var pickupDeliveryDriverSeg: UISegmentedControl!
    
    //
    // MARK: Table View function that returns number of elements
    //
   
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0 && pickupDeliveryDriverSeg.selectedSegmentIndex == 2 {
            return 95.0
        } else if indexPath.row == 0 {
            return 70.0
        } else {
            return 95.0
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
       switch pickupDeliveryDriverSeg.selectedSegmentIndex
        {
        case 0:
            return pickupvendorslist.count + 1
            
        case 1:
            return deliveryvendorslist.count + 1
            
        case 2:
            return deliveryorderslist.count + 1
        default:
            return 0

        }
        


    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
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
        
        
    } //end getDeliveryVendors
    
    //
    // Grabs all delivery orders from FirebaseDatabase and refreshes table view
    //
    
    func getDeliveryOrders(){
        
        self.deliveryorderslist.removeAll()
        
        ref.child("orders").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                let isAPickupOrder = dictionary["pickup"] as! Bool
                
                //
                // Determine if vendor is a delivery vendor
                //
                
                if (!isAPickupOrder) {
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
                    order.id = dictionary["id"] as? String

                    
                    //
                    // Determines if item has already been added to the array
                    //

                    
                    var beenAdded = false
                    for o in self.deliveryorderslist {
                        if o.getID() == order.getID() {
                            beenAdded = true
                        }
                    }
                    
                    if (!beenAdded) {
                        self.deliveryorderslist.append(order)
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
        
        
    } //end getDeliveryOrders
    
    @IBAction func changeIndex(_ sender: Any) {
        
        switch pickupDeliveryDriverSeg.selectedSegmentIndex
        {
        case 0:
            getPickupVendors()
        case 1:
            getDeliveryVendors()
        case 2:
            getDeliveryOrders()
        default:
            break
        }
        
    }
    
    
    //
    // Function that determines what each cell is composed of depending on its index
    //
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //
        // Three cases that depend on seg control -- pickup/delivery/driver
        //
        
        //
        // if == 0 , then pickup so first display total cell, then all pickup vendors
        //
        
        if pickupDeliveryDriverSeg.selectedSegmentIndex == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "totalVendorStatsCell", for: indexPath) as! vendorTotalStatsTableViewCell

                var totrefunds = 0.0
                var totcash = 0.0
                var totcredit = 0.0
                var tottotal = 0.0
                var totnum = 0
                
                for res in self.pickupvendorslist {
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
                
                
                //
                // fill cells from returned list
                //

                let isIndexValid = self.pickupvendorslist.indices.contains(indexPath.row-1)
                
                if (isIndexValid) {
                    cell.vendorName.text = pickupvendorslist[indexPath.row - 1].getName()
                    cell.cash.text = pickupvendorslist[indexPath.row - 1].getCash().description
                    cell.credit.text = pickupvendorslist[indexPath.row - 1].getCredit().description
                    cell.total.text = pickupvendorslist[indexPath.row - 1].getTotal().description
                    cell.num.text = pickupvendorslist[indexPath.row - 1].getNum().description
                    
                    return cell
                    
                } else {
                    
                    cell.vendorName.text = "nil"
                    cell.cash.text = "nil"
                    cell.credit.text = "nil"
                    cell.total.text = "nil"
                    cell.num.text = "nil"
                    
                    return cell
                }
                
            }
            
            //
            // if == 1 , then delivery so first display total cell, then all delivery vendors
            //

            
        } else if pickupDeliveryDriverSeg.selectedSegmentIndex == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "totalDeliveryStatsCell", for: indexPath) as! totalDeliveryVendorTableViewCell
                
                
                var totrefunds = 0.0
                var totcash = 0.0
                var totcredit = 0.0
                var tottotal = 0.0
                var totnum = 0
                
                for res in self.deliveryvendorslist
                {
                    totcash += res.getCash()
                    totcredit += res.getCredit()
                    totnum += res.getNum()
                    totrefunds += res.getRefund()
                }
                
                tottotal = totcash + totcredit

                cell.totalCredit.text = totcredit.description
                cell.totalCash.text = totcash.description
                cell.totalNum.text = totnum.description
                cell.totalRefund.text = totrefunds.description
                cell.total.text = tottotal.description
                
                return cell
                
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "vendorStatsCell", for: indexPath) as! vendorStatsTableViewCell
                
                //
                // fill cells from returned list
                //
                
                let isIndexValid = self.deliveryvendorslist.indices.contains(indexPath.row-1)

                if (isIndexValid) {
                    cell.vendorName.text = deliveryvendorslist[indexPath.row - 1].getName()
                    cell.cash.text = deliveryvendorslist[indexPath.row - 1].getCash().description
                    cell.credit.text = deliveryvendorslist[indexPath.row - 1].getCredit().description
                    cell.total.text = deliveryvendorslist[indexPath.row - 1].getTotal().description
                    cell.num.text = deliveryvendorslist[indexPath.row - 1].getNum().description
                    
                    return cell

                } else {
                    
                    cell.vendorName.text = "nil"
                    cell.cash.text = "nil"
                    cell.credit.text = "nil"
                    cell.total.text = "nil"
                    cell.num.text = "nil"
                    
                    return cell
                }

                
            }
        } else {
            
            //
            // if == 2 , then driver so first display total cell, then all delivery orders
            //
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "totalDriverStatsCell", for: indexPath) as! driverTotalTableViewCell
                
                
                var totDF = 0.0
                var totTip = 0.0
                var totCash = 0.0
                var totEarned = 0.0
                var totDifference = 0.0
                
                for res in self.deliveryorderslist {
                    totDF += res.getDeliveryFee()
                    
                    //
                    // If it is a cash delivery, do not include
                    // tip in what store has to pay out
                    //
                    
                    if (res.getCash()) {
                        totCash += res.getPrice()
                    } else {
                        totTip += res.getTip()
                    }
                }
                
                totEarned = totDF + totTip
                totDifference = totEarned - totCash

                cell.totalDeliveryFee.text = totDF.description
                cell.totalTip.text = totTip.description
                cell.totalDifference.text = totDifference.description
                cell.totalEarned.text = totEarned.description
                
                if (totDifference > 0) {
                    cell.whoPays.text = "Store"
                } else if (totDifference < 0) {
                    cell.whoPays.text = "Driver"
                } else {
                    cell.whoPays.text = "Equal!"
                }
                
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "driverStatsCell", for: indexPath) as! driverOrdersTableViewCell
                
                
                let isIndexValid = self.deliveryorderslist.indices.contains(indexPath.row-1);
                
                if (isIndexValid) {
                    
                    //
                    // fill cells from returned list
                    //
                    
                    cell.custName.text = deliveryorderslist[indexPath.row - 1].getName()
                    cell.deliveryFee.text = deliveryorderslist[indexPath.row - 1].getDeliveryFee().description
                    cell.tip.text = deliveryorderslist[indexPath.row - 1].getTip().description
                    let total = deliveryorderslist[indexPath.row - 1].getTip() + deliveryorderslist[indexPath.row - 1].getDeliveryFee()
                    cell.total.text = total.description
                    
                    return cell

                } else {
                    
                    
                    cell.custName.text = "nil"
                    cell.deliveryFee.text = "nil"
                    cell.tip.text = "nil"
                    cell.total.text = "nil"
                    return cell
                }
            }
        }


    }
        
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
        returnButton.layer.cornerRadius = 10
        returnButton.layer.masksToBounds = true
        returnButton.layer.borderColor = UIColor.black.cgColor
        returnButton.layer.borderWidth = 0.5
        returnButton.layer.shadowColor = UIColor.black.cgColor
        returnButton.layer.shadowOffset = CGSize.zero
        returnButton.layer.shadowRadius = 5.0
        returnButton.layer.shadowOpacity = 0.5
        returnButton.clipsToBounds = false
        
        
        pickupDeliveryDriverSeg.layer.borderColor = UIColor.black.cgColor
        pickupDeliveryDriverSeg.layer.borderWidth = 1.0
        
        let strokeTextAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.strokeColor : UIColor.black,
            NSAttributedStringKey.foregroundColor : UIColor.white,
            NSAttributedStringKey.strokeWidth : -2.0,
            ]
        
        statsHeader.attributedText = NSAttributedString(string: "Statistics", attributes: strokeTextAttributes)
     
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference().child("users").child(uid)

        initView()
        
        
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    
}
