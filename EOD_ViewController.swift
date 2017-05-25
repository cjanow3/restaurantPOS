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
    @IBOutlet weak var amazonCashLabel: UILabel!
    @IBOutlet weak var amazonTotalLabel: UILabel!
    
    @IBOutlet weak var caviarCreditLabel: UILabel!
    @IBOutlet weak var caviarNumLabel: UILabel!
    @IBOutlet weak var caviarCashLabel: UILabel!
    @IBOutlet weak var caviarTotalLabel: UILabel!
    
    @IBOutlet weak var doordashCreditLabel: UILabel!
    @IBOutlet weak var doordashNumLabel: UILabel!
    @IBOutlet weak var doordashCashLabel: UILabel!
    @IBOutlet weak var doordashTotalLabel: UILabel!
    
    @IBOutlet weak var eat24CreditLabel: UILabel!
    @IBOutlet weak var eat24NumLabel: UILabel!
    @IBOutlet weak var eat24CashLabel: UILabel!
    @IBOutlet weak var eat24TotalLabel: UILabel!
    
    @IBOutlet weak var grubhubCreditLabel: UILabel!
    @IBOutlet weak var grubhubNumLabel: UILabel!
    @IBOutlet weak var grubhubCashLabel: UILabel!
    @IBOutlet weak var grubhubTotalLabel: UILabel!
    
    @IBOutlet weak var postmatesCreditLabel: UILabel!
    @IBOutlet weak var postmatesNumLabel: UILabel!
    @IBOutlet weak var postmatesCashLabel: UILabel!
    @IBOutlet weak var postmatesTotalLabel: UILabel!
    
    @IBOutlet weak var uberCreditLabel: UILabel!
    @IBOutlet weak var uberNumLabel: UILabel!
    @IBOutlet weak var uberCashLabel: UILabel!
    @IBOutlet weak var uberTotalLabel: UILabel!
    
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
    
    //Final totals (on bottom on main storyboard)
    
    @IBOutlet weak var totalPickupCredit: UILabel!
    @IBOutlet weak var totalPickupNum: UILabel!
    
    @IBOutlet weak var totalDeliveryCredit: UILabel!
    @IBOutlet weak var totalDeliveryCash: UILabel!
    @IBOutlet weak var totalDelivery: UILabel!
    @IBOutlet weak var totalDeliveryNum: UILabel!

    @IBOutlet weak var totalTips: UILabel!
    @IBOutlet weak var totalDeliveryFees: UILabel!
    @IBOutlet weak var driverPayout: UILabel!
    
    @IBOutlet weak var deliveryRefunds: UILabel!
    @IBOutlet weak var pickupRefunds: UILabel!
    
    
    //MARK: Return to main menu button

    @IBAction func backToMainMenu(_ sender: Any)
    {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: Reset Driver Payout -- used in case drivers switch
    
    @IBAction func resetDriverPay(_ sender: Any)
    {
        createAlert(title: "Confirm", message: "Really reset drivery payout?")
    }
    
    //MARK: Reset day
    
    @IBAction func resetDay(_ sender: Any)
    {
        createAlert_ResetDay(title: "Enter Password", message: "")
    }

    func separateTotals()
    {
        //Variables used to display totals
        
        //Pickup
        var amazonCredit = 0.0
        var amazonNum = 0
        var amazonCash = 0.0
        var amazonTotal = 0.0
        
        
        var caviarCredit = 0.0
        var caviarNum = 0
        var caviarCash = 0.0
        var caviarTotal = 0.0
        
        var doordashCredit = 0.0
        var doordashNum = 0
        var doordashCash = 0.0
        var doordashTotal = 0.0
        
        var eat24PickupCredit = 0.0
        var eat24PickupNum = 0
        var eat24PickupCash = 0.0
        var eat24PickupTotal = 0.0
        
        var grubhubPickupCredit = 0.0
        var grubhubPickupNum = 0
        var grubhubPickupCash = 0.0
        var grubhubPickupTotal = 0.0
        
        var postmatesCredit = 0.0
        var postmatesNum = 0
        var postmatesCash = 0.0
        var postmatesTotal = 0.0
        
        var uberCredit = 0.0
        var uberNum = 0
        var uberCash = 0.0
        var uberTotal = 0.0
        
        
        
        //Delivery
        var dcomCash = 0.0
        var dcomCredit = 0.0
        var dcomTotal = 0.0
        var dcomNum = 0
        
        var eat24DeliveryCash = 0.0
        var eat24DeliveryCredit = 0.0
        var eat24DeliveryTotal = 0.0
        var eat24DeliveryNum = 0
        
        var foodlerCash = 0.0
        var foodlerCredit = 0.0
        var foodlerTotal = 0.0
        var foodlerNum = 0
        
        //credit only
        var grouponCredit = 0.0
        var grouponTotal = 0.0
        var grouponNum = 0
        
        var grubhubCash = 0.0
        var grubhubCredit = 0.0
        var grubhubTotal = 0.0
        var grubhubNum = 0
        
        var seamlessCredit = 0.0
        var seamlessTotal = 0.0
        var seamlessNum = 0
        
        var sliceCredit = 0.0
        var sliceTotal = 0.0
        var sliceNum = 0
        
        //Final totals
        var pickupCredit = 0.0
        var pickupNum = 0
        
        var deliveryCredit = 0.0
        var deliveryCash = 0.0
        var deliveryTotal = 0.0
        var deliveryNum = 0
        
        var tips = 0.0
        var deliveryfees = 0.0
        var driverPay = 0.0
        
        var delivRefunds = 0.0
        var pickRefunds = 0.00
        
        let orderList = restaurantController.fetchOrders()
        
        
        for order in orderList
        {
            //get refund for each order regardless of pickup/delivery
            
            //Case 1: Order is a pickup
            if (order.getPickup())
            {
                pickRefunds += order.getRefund()
                
                pickupCredit += order.getPrice()
                pickupNum += 1
                
                if (order.getVendor() == "Amazon")
                {
                    if (order.getCash())
                    {
                        amazonCash += order.getPrice()
                    } else{
                        amazonCredit += order.getPrice()

                    }
                    amazonTotal += order.getPrice()
                    amazonNum += 1
                }
                else if (order.getVendor() == "Caviar")
                {
                    if (order.getCash())
                    {
                        caviarCash += order.getPrice()
                    } else{
                        caviarCredit += order.getPrice()

                    }
                    caviarTotal += order.getPrice()
                    caviarNum += 1
                }
                else if (order.getVendor() == "Doordash")
                {
                    if (order.getCash())
                    {
                        doordashCash += order.getPrice()
                    } else{
                        doordashCredit += order.getPrice()
                        
                    }
                    doordashTotal += order.getPrice()
                    doordashNum += 1
                }
                else if (order.getVendor() == "Eat24")
                {
                    if (order.getCash())
                    {
                        eat24PickupCash += order.getPrice()
                    } else{
                        eat24PickupCredit += order.getPrice()
                        
                    }
                    eat24PickupTotal += order.getPrice()
                    eat24PickupNum += 1
                }
                else if (order.getVendor() == "Grubhub")
                {
                    if (order.getCash())
                    {
                        grubhubPickupCash += order.getPrice()
                    } else{
                        grubhubPickupCredit += order.getPrice()

                    }
                    grubhubPickupTotal += order.getPrice()
                    grubhubPickupNum += 1
                }
                else if (order.getVendor() == "Postmates")
                {
                    if (order.getCash())
                    {
                        postmatesCash += order.getPrice()
                    } else{
                        postmatesCredit += order.getPrice()

                    }
                    postmatesTotal += order.getPrice()
                    postmatesNum += 1
                }
                else if (order.getVendor() == "Uber")
                {
                    if (order.getCash())
                    {
                        uberCash += order.getPrice()
                    } else{
                        uberCredit += order.getPrice()

                    }
                    uberTotal += order.getPrice()
                    uberNum += 1
                }
            } //end order = pickup
                
            //Case 2: Order is a delivery
            else if (order.getPickup() == false)
            {
                delivRefunds += order.getRefund()
                
                //driver gets paid each delivery fee and tip for deliveries
                driverPay += order.getDeliveryFee()
                driverPay += order.getTip()
                
                tips += order.getTip()
                deliveryfees += order.getDeliveryFee()
                
                //increase # deliveries for each delivery order, add to total price
                deliveryNum += 1
                deliveryTotal += order.getPrice()
                
                if (order.getCash())
                {
                    deliveryCash += order.getPrice()
                }else{
                    deliveryCredit += order.getPrice()
                }
        
                
                if (order.getVendor() == "Delivery.com")
                {
                    if (order.getCash())
                    {
                        dcomCash += order.getPrice()
                        
                    }else{
                        dcomCredit += order.getPrice()
                    }
                    
                    dcomTotal += order.getPrice()
                    dcomNum += 1
                }
                else if (order.getVendor() == "Eat24")
                {
                    if (order.getCash())
                    {
                        eat24DeliveryCash += order.getPrice()
                    }else{
                        eat24DeliveryCredit += order.getPrice()
                    }
                    
                    eat24DeliveryTotal += order.getPrice()
                    eat24DeliveryNum += 1
                }
                else if (order.getVendor() == "Foodler")
                {
                    if (order.getCash())
                    {
                        foodlerCash += order.getPrice()
                    }else{
                        foodlerCredit += order.getPrice()
                    }
                    
                    foodlerTotal += order.getPrice()
                    foodlerNum += 1
                }
                else if (order.getVendor() == "Groupon")
                {
                    grouponCredit += order.getPrice()
                    grouponTotal += order.getPrice()
                    grouponNum += 1
                }
                else if (order.getVendor() == "Grubhub")
                {
                    if (order.getCash())
                    {
                        grubhubCash += order.getPrice()
                    }else{
                        grubhubCredit += order.getPrice()
                    }
                    
                    grubhubTotal += order.getPrice()
                    grubhubNum += 1
                }
                else if (order.getVendor() == "Seamless")
                {
                    seamlessCredit += order.getPrice()
                    seamlessTotal += order.getPrice()
                    seamlessNum += 1
                }
                else if (order.getVendor() == "SLICE")
                {
                    sliceCredit += order.getPrice()
                    sliceTotal += order.getPrice()
                    sliceNum += 1
                }
                
                
            }//end order = delivery
            

            
        } //end for each loop
        
        //Pickup
        amazonCreditLabel.text = amazonCredit.description
        amazonNumLabel.text = amazonNum.description
        amazonCashLabel.text = amazonCash.description
        amazonTotalLabel.text = amazonTotal.description
        
        caviarCreditLabel.text = caviarCredit.description
        caviarNumLabel.text = caviarNum.description
        caviarCashLabel.text = caviarCash.description
        caviarTotalLabel.text = caviarTotal.description
        
        doordashCreditLabel.text = doordashCredit.description
        doordashNumLabel.text = doordashNum.description
        doordashCashLabel.text = doordashCash.description
        doordashTotalLabel.text = doordashTotal.description
        
        eat24CreditLabel.text = eat24PickupCredit.description
        eat24NumLabel.text = eat24PickupNum.description
        eat24CashLabel.text = eat24PickupCash.description
        eat24TotalLabel.text = eat24PickupTotal.description
        
        grubhubCreditLabel.text = grubhubPickupCredit.description
        grubhubNumLabel.text = grubhubPickupNum.description
        grubhubCashLabel.text = grubhubPickupCash.description
        grubhubTotalLabel.text = grubhubPickupTotal.description
        
        postmatesCreditLabel.text = postmatesCredit.description
        postmatesNumLabel.text = postmatesNum.description
        postmatesCashLabel.text = postmatesCash.description
        postmatesTotalLabel.text = postmatesTotal.description
        
        uberCreditLabel.text = uberCredit.description
        uberNumLabel.text = uberNum.description
        uberCashLabel.text = uberCash.description
        uberTotalLabel.text = uberTotal.description
        
        //Delivery
        dcomCashLabel.text = dcomCash.description
        dcomCreditLabel.text = dcomCredit.description
        dcomTotalLabel.text = dcomTotal.description
        dcomNumLabel.text = dcomNum.description
        
        eat24CashDeliveryLabel.text = eat24DeliveryCash.description
        eat24CreditDeliveryLabel.text = eat24DeliveryCredit.description
        eat24TotalDeliveryLabel.text = eat24DeliveryTotal.description
        eat24NumDeliveryLabel.text = eat24DeliveryNum.description
        
        foodlerCashLabel.text = foodlerCash.description
        foodlerCreditLabel.text = foodlerCredit.description
        foodlerTotalLabel.text = foodlerTotal.description
        foodlerNumLabel.text = foodlerNum.description
        
        grouponCreditLabel.text = grouponCredit.description
        grouponTotalLabel.text = grouponTotal.description
        grouponNumLabel.text = grouponNum.description
        
        grubhubCashDeliveryLabel.text = grubhubCash.description
        grubhubCreditDeliveryLabel.text = grubhubCredit.description
        grubhubTotalDeliveryLabel.text = grubhubTotal.description
        grubhubNumDeliveryLabel.text = grubhubNum.description
        
        seamlessCreditLabel.text = seamlessCredit.description
        seamlessTotalLabel.text = seamlessTotal.description
        seamlessNumLabel.text = seamlessNum.description
        
        sliceCreditLabel.text = sliceCredit.description
        sliceTotalLabel.text = sliceTotal.description
        sliceNumLabel.text = sliceNum.description
        
        totalPickupCredit.text = pickupCredit.description
        totalPickupNum.text = pickupNum.description
        
        totalDeliveryCredit.text = deliveryCredit.description
        totalDeliveryCash.text = deliveryCash.description
        totalDelivery.text = deliveryTotal.description
        totalDeliveryNum.text = deliveryNum.description
        
        totalTips.text = tips.description
        totalDeliveryFees.text = deliveryfees.description
        
        //Driver Payout is equal to total tips and delivery fees MINUS any cash deliveries
        driverPay -= deliveryCash
        driverPayout.text = driverPay.description
        
        deliveryRefunds.text = delivRefunds.description
        pickupRefunds.text = pickRefunds.description
        
    } //end separateTotals()
    
    func createAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func createAlert_ResetDay(title: String, message: String)
    {
        
        //create alert controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //create cancel action
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //craete ok action
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) -> Void in print("OK")
            
            let inputPassword = alert.textFields?[0].text
            
            if (inputPassword != "0000")
            {
                
                self.createAlert(title: "Incorrect", message: "Try again")
                
            }
                
            else
            {
                restaurantController.clean_ALL_CoreData()
                self.createAlert(title: "Confirmed", message: "The day has been reset.")
                
                
            }
            
            
            
        })
        
        alert.addAction(cancel)
        
        alert.addAction(ok)
        
        alert.addTextField(configurationHandler: { (textField: UITextField) -> Void in textField.placeholder = "Password"})
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        separateTotals()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}