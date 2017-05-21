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
    
    
    var cName:String?
    var cVendor:String?
    var cAddress:String?
    var cCashCredit:String?
    var cPickupDelivery:String?
    
    var cTip:Double?
    var cDeliveryFee:Double?
    var cPrice:Double?
    
    
    @IBAction func backtomainmenu(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let cName = cName, let cVendor = cVendor, let cAddress = cAddress, let cCashCredit = cCashCredit, let cPickupDelivery = cPickupDelivery, let cTip = cTip, let cDeliveryFee = cDeliveryFee, let cPrice = cPrice {
            
            name.text = cName
            vendor.text = cVendor
            address.text = cAddress
            cashcredit.text = cCashCredit
            pickupdelivery.text = cPickupDelivery
            
            tip.text = cTip.description
            price.text = cPrice.description
            deliveryfee.text = cDeliveryFee.description
            
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
