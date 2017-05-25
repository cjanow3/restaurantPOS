//
//  EditOrder_ViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 5/25/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit

class EditOrder_ViewController: UIViewController {
    
    
    var cName:String?
    var cVendor:String?
    var cAddress:String?
    var cCashCredit:String?
    var cPickupDelivery:String?
    
    var cTip:Double?
    var cDeliveryFee:Double?
    var cPrice:Double?
    var cRefund:Double?
    
    var cPickup:Bool?
    var cCash:Bool?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
