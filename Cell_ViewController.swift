//
//  Cell_ViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 5/20/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit

class Cell_ViewController: UIViewController {

    
    //MARK: Labels and respective variables used for those labels
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var vendor: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var cashcredit: UILabel!
    @IBOutlet weak var pickupdelivery: UILabel!
    
    @IBOutlet weak var tip: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var deliveryfee: UILabel!
    @IBOutlet weak var refund: UILabel!
    
    
    var cName:String?
    var cVendor:String?
    var cAddress:String?
    var cCashCredit:String?
    var cPickupDelivery:String?
    
    var cPickup:Bool?
    var cCash:Bool?
    
    var cTip:Double?
    var cDeliveryFee:Double?
    var cPrice:Double?
    var cRefund:Double?
    
    @IBAction func backtomainmenu(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editorderseg")
        {
            let destVC = segue.destination as! EditOrder_ViewController
            
            let anOrder = restaurantController.OrderItem(NAME: cName!, ADDRESS: cAddress!, VENDOR: cVendor!, PRICE: cPrice!, TIP: cTip!, DELIVFEE: cDeliveryFee!, PICKUP: cPickup!, CASH: cCash!)
            
            destVC.cName = anOrder.getName()
            destVC.cVendor = anOrder.getVendor()
            destVC.cTip = anOrder.getTip()
            destVC.cDeliveryFee = anOrder.getDeliveryFee()
            destVC.cRefund = anOrder.getRefund()
            destVC.cPickup = anOrder.getPickup()
            destVC.cCash = anOrder.getCash()
            
            if (anOrder.getPickup())
            {
                destVC.cPickupDelivery = "Pickup"
                destVC.cAddress = "None -- Pickup"
            } else {
                destVC.cPickupDelivery = "Delivery"
                destVC.cAddress = anOrder.getAddress()
            }
            
            if (anOrder.getCash())
            {
                destVC.cCashCredit = "Cash"
            } else {
                destVC.cCashCredit = "Credit"
            }
            
            
            } // end indexPath -- should not ever be null -- however gets information for selected cell
        } //end detailseg option

    
    @IBAction func unwindEODView(segue: UIStoryboardSegue)
    {
        //print("unwindEODView fired in first view")
        
        if segue.source is EditOrder_ViewController
        {
            //do something here if we want to pass info from previous seg (EOD)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let cName = cName, let cVendor = cVendor, let cAddress = cAddress, let cCashCredit = cCashCredit, let cPickupDelivery = cPickupDelivery, let cTip = cTip, let cDeliveryFee = cDeliveryFee, let cPrice = cPrice, let cRefund = cRefund {
            
            name.text = cName
            vendor.text = cVendor
            address.text = cAddress
            cashcredit.text = cCashCredit
            pickupdelivery.text = cPickupDelivery
            
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
