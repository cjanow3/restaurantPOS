//
//  EOD_ViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 5/17/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit

class EOD_ViewController: UIViewController {

    //MARK: Labels used for cash/credit/total$/total#
    
    //Pickup
    @IBOutlet weak var amazonCreditLabel: UILabel!
    @IBOutlet weak var amazonNumLabel: UILabel!
    
    @IBOutlet weak var caviarCreditLabel: UILabel!
    @IBOutlet weak var caviarNumLabel: UILabel!
    
    @IBOutlet weak var doordashCreditLabel: UILabel!
    @IBOutlet weak var doordashNumLabel: UILabel!
    
    @IBOutlet weak var eat24CreditLabel: UILabel!
    @IBOutlet weak var eat24NumLabel: UILabel!
    
    @IBOutlet weak var grubhubCreditLabel: UILabel!
    @IBOutlet weak var grubhubNumLabel: UILabel!
    
    @IBOutlet weak var postmatesCreditLabel: UILabel!
    @IBOutlet weak var postmatesNumLabel: UILabel!
    
    @IBOutlet weak var uberCreditLabel: UILabel!
    @IBOutlet weak var uberNumLabel: UILabel!
    
    //Delivery
    @IBOutlet weak var dcomCashLabel: UILabel!
    @IBOutlet weak var dcomCreditLabel: UILabel!
    @IBOutlet weak var dcomTotalLabel: UILabel!
    @IBOutlet weak var dcomNumLabel: UILabel!
    
    @IBOutlet weak var eat24CashDeliveryLabel: UILabel!
    @IBOutlet weak var eat24CreditDeliveryLabel: UILabel!
    @IBOutlet weak var eat24TotalDeliveryLabel: UILabel!
    @IBOutlet weak var eat24NumDeliveryLabel: UILabel!
    
    @IBOutlet weak var foodlerCashLabel: UILabel!
    @IBOutlet weak var foodlerCreditLabel: UILabel!
    @IBOutlet weak var foodlerTotalLabel: UILabel!
    @IBOutlet weak var foodlerNumLabel: UILabel!
    
    //credit only
    @IBOutlet weak var grouponCreditLabel: UILabel!
    @IBOutlet weak var grouponTotalLabel: UILabel!
    @IBOutlet weak var grouponNumLabel: UILabel!
    
    @IBOutlet weak var grubhubCashDeliveryLabel: UILabel!
    @IBOutlet weak var grubhubCreditDeliveryLabel: UILabel!
    @IBOutlet weak var grubhubTotalDeliveryLabel: UILabel!
    @IBOutlet weak var grubhubNumDeliveryLabel: UILabel!
    
    //credit only
    @IBOutlet weak var seamlessCreditLabel: UILabel!
    @IBOutlet weak var seamlessTotalLabel: UILabel!
    @IBOutlet weak var seamlessNumLabel: UILabel!

    
    //credit only
    @IBOutlet weak var sliceCreditLabel: UILabel!
    @IBOutlet weak var sliceTotalLabel: UILabel!
    @IBOutlet weak var sliceNumLabel: UILabel!

    
    
    //MARK: Return to main menu button

    @IBAction func backToMainMenu(_ sender: Any)
    {
        
        dismiss(animated: true, completion: nil)
        
    }

    func separateTotals()
    {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
