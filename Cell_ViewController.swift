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
    
    @IBOutlet weak var statsButton: UIButton!
    
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
    
    func hideButton()
    {
        statsButton.isHidden = true
    }
    
    @IBAction func backtomainmenu(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func customerStats(_ sender: Any)
    {
        createSimpleAlert(title: "NOT READY", message: "This doesn't do anything ( yet ;) )")
    }
    
    func createSimpleAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editorderseg")
        {
            let destVC = segue.destination as! EditOrder_ViewController
            
            let anOrder = restaurantController.OrderItem(NAME: cName!, ADDRESS: cAddress!, VENDOR: cVendor!, PRICE: cPrice!, TIP: cTip!, DELIVFEE: cDeliveryFee!, PICKUP: cPickup!, CASH: cCash!, REFUND: cRefund!)
            
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
       /*
        if segue.source is EditOrder_ViewController
        {
            //do something here if we want to pass info from previous seg (EOD)
            let sourceVC = segue.destination as! Cell_ViewController
            
            name.text = sourceVC.cName
            vendor.text = sourceVC.cVendor
            address.text = sourceVC.cAddress
            cashcredit.text = sourceVC.cCashCredit
            pickupdelivery.text = sourceVC.cPickupDelivery
            
            tip.text = sourceVC.cTip?.description
            price.text = sourceVC.cPrice?.description
            deliveryfee.text = sourceVC.cDeliveryFee?.description
            refund.text = sourceVC.cRefund?.description
            
            
        }*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        hideButton()
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
    


}
