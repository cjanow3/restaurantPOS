//
//  EOD_ViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 5/17/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit


class OrderStatsViewController: UIViewController {

    //MARK: Labels used for cash/credit/total$/total#
    
    //delivery & pickup header for view
    @IBOutlet weak var deliveryHeader: UILabel!
    @IBOutlet weak var pickupHeader: UILabel!
    
    
    //Identifiers for pickups
    @IBOutlet weak var amazonIdentifier: UILabel!
    @IBOutlet weak var caviarIdentifier: UILabel!
    @IBOutlet weak var doordashIdentifier: UILabel!
    @IBOutlet weak var grouponIdentifier: UILabel!
    @IBOutlet weak var uberIdentifier: UILabel!
    @IBOutlet weak var postmatesIdentifier: UILabel!
    @IBOutlet weak var eat24PickupIdentifier: UILabel!
    //End identifiers for pickups
    
    //Identifiers for delivery
    
    @IBOutlet weak var dcomIdentifier: UILabel!
    @IBOutlet weak var eat24DeliveryIdentifier: UILabel!
    @IBOutlet weak var foodlerIdentifier: UILabel!
    @IBOutlet weak var seamlessIdentifier: UILabel!
    @IBOutlet weak var sliceIdentifier: UILabel!
    
    @IBOutlet weak var instoreIdentifier: UILabel!
    //End identifiers for delivery
    
    //Identifiers for both pickup/delivery
    @IBOutlet weak var grubhubIdentifier: UILabel!
    //End identifiers for both pickup/delivery
    
    //Column Header Identifiers
    @IBOutlet weak var creditIdentifier: UILabel!
    @IBOutlet weak var totalMoneyIdentifier: UILabel!
    @IBOutlet weak var totalNumIdentifier: UILabel!
    @IBOutlet weak var cashIdentifier: UILabel!
    //End column header identifiers
    
    //Driver info Indentifiers
    
    
    
    //End driver info identifiers
    
    
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
    
    @IBOutlet weak var instoreCashLabel: UILabel!
    @IBOutlet weak var instoreCreditLabel: UILabel!
    @IBOutlet weak var instoreTotalLabel: UILabel!
    @IBOutlet weak var instoreNumLabel: UILabel!
    
    
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
    
    //Identifiers for totals
    //Pickup
    @IBOutlet weak var totalPickupCreditIdentifier: UILabel!
    @IBOutlet weak var totalPickupNumIdentifier: UILabel!
    @IBOutlet weak var totalPickupRefundsIdentifier: UILabel!
    
    //Delivery
    
    @IBOutlet weak var totalDeliveryCreditIdentifier: UILabel!
    @IBOutlet weak var totalDeliveryCashIdentifier: UILabel!
    @IBOutlet weak var totalDeliveryIdentifier: UILabel!
    
    @IBOutlet weak var totalDeliveryNumIdentifier: UILabel!
    @IBOutlet weak var totalDeliveryRefundsIdentifier: UILabel!
    
    //Totals for driver (still identifiers)
    @IBOutlet weak var totalTipsIdentifier: UILabel!
    @IBOutlet weak var totalDeliveryFeesIdentifier: UILabel!
    @IBOutlet weak var driverPayoutIdentifier: UILabel!
    //End identifiers for totals
    
    @IBOutlet weak var totalPickupCredit: UILabel!
    @IBOutlet weak var totalPickupNum: UILabel!
    
    @IBOutlet weak var totalDeliveryCredit: UILabel!
    @IBOutlet weak var totalDeliveryCash: UILabel!
    @IBOutlet weak var totalDelivery: UILabel!
    @IBOutlet weak var totalDeliveryNum: UILabel!

    @IBOutlet weak var totalTips: UILabel!
    @IBOutlet weak var totalDeliveryFees: UILabel!
    @IBOutlet weak var driverPayout: UILabel!
    @IBOutlet weak var driverAlreadyPaidOut: UILabel!
    
    @IBOutlet weak var deliveryRefunds: UILabel!
    @IBOutlet weak var pickupRefunds: UILabel!
    
    
    //seg control to control which
    
    @IBOutlet weak var pdtViewSeg: UISegmentedControl!
    
    @IBAction func changeView(_ sender: Any)
    {
        switch pdtViewSeg.selectedSegmentIndex
        {
        case 0: //display pickup labels and hide delivery
            
            displayPickup()
            
        case 1: //display delivery
            
            displayDelivery()
            
            
        case 2: //display totals
            
            displayTotals()
            
        default:
            break
            
        }
        
    }
    
    
    //MARK: Return to main menu button

    @IBAction func backToMainMenu(_ sender: Any)
    {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: Reset Driver Payout -- used in case drivers switch
    
    
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
        
        var inStoreCash = 0.0
        var inStoreCredit = 0.0
        var inStoreTotal = 0.0
        var inStoreNum = 0
        
        var grouponCredit = 0.0         //credit only
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
                pickupCredit -= order.getRefund()
                pickupNum += 1
                
                if (order.getVendor() == "Amazon")
                {
                    if (order.getCash())
                    {
                        amazonCash += order.getPrice()
                        amazonCash -= order.getRefund()
                    } else{
                        amazonCredit += order.getPrice()
                        amazonCredit -= order.getRefund()

                    }
                    amazonTotal += order.getPrice()
                    amazonTotal -= order.getRefund()
                    amazonNum += 1
                }
                else if (order.getVendor() == "Caviar")
                {
                    if (order.getCash())
                    {
                        caviarCash += order.getPrice()
                        caviarCash -= order.getRefund()
                    } else{
                        caviarCredit += order.getPrice()
                        caviarCredit -= order.getRefund()

                    }
                    caviarTotal += order.getPrice()
                    caviarTotal -= order.getRefund()
                    caviarNum += 1
                }
                else if (order.getVendor() == "Doordash")
                {
                    if (order.getCash())
                    {
                        doordashCash += order.getPrice()
                        doordashCash -= order.getRefund()
                    } else{
                        doordashCredit += order.getPrice()
                        doordashCredit -= order.getRefund()
                    }
                    doordashTotal += order.getPrice()
                    doordashTotal -= order.getRefund()
                    doordashNum += 1
                }
                else if (order.getVendor() == "Eat24")
                {
                    if (order.getCash())
                    {
                        eat24PickupCash += order.getPrice()
                        eat24PickupCash -= order.getRefund()
                    } else{
                        eat24PickupCredit += order.getPrice()
                        eat24PickupCredit -= order.getRefund()
                        
                    }
                    eat24PickupTotal += order.getPrice()
                    eat24PickupTotal -= order.getRefund()
                    eat24PickupNum += 1
                }
                else if (order.getVendor() == "Grubhub")
                {
                    if (order.getCash())
                    {
                        grubhubPickupCash += order.getPrice()
                        grubhubPickupCash -= order.getRefund()
                    } else{
                        grubhubPickupCredit += order.getPrice()
                        grubhubPickupCredit -= order.getRefund()

                    }
                    grubhubPickupTotal += order.getPrice()
                    grubhubPickupTotal -= order.getRefund()
                    grubhubPickupNum += 1
                }
                else if (order.getVendor() == "Postmates")
                {
                    if (order.getCash())
                    {
                        postmatesCash += order.getPrice()
                        postmatesCash -= order.getRefund()
                    } else{
                        postmatesCredit += order.getPrice()
                        postmatesCredit -= order.getRefund()

                    }
                    postmatesTotal += order.getPrice()
                    postmatesTotal -= order.getRefund()
                    postmatesNum += 1
                }
                else if (order.getVendor() == "Uber")
                {
                    if (order.getCash())
                    {
                        uberCash += order.getPrice()
                        uberCash -= order.getRefund()
                    } else{
                        uberCredit += order.getPrice()
                        uberCredit -= order.getRefund()

                    }
                    uberTotal += order.getPrice()
                    uberTotal -= order.getRefund()
                    uberNum += 1
                }
            } //end order = pickup
                
            //Case 2: Order is a delivery
            else if (order.getPickup() == false)
            {
                delivRefunds += order.getRefund()
                
                //driver gets paid each delivery fee and tip for deliveries (even if they are in store))
                
                driverPay += order.getDeliveryFee()
                driverPay += order.getTip()
                
                tips += order.getTip()
                deliveryfees += order.getDeliveryFee()
                

                
                //we do not want in store totals to be added b/c they are considered a sale made by us
                
                if (order.getVendor() != "In Store")
                {
                    //increase # deliveries for each delivery order, add to total price
                    deliveryNum += 1
                    
                    deliveryTotal += order.getPrice()
                    deliveryTotal -= order.getRefund()
                }
                
                
                if (order.getCash())
                {
                    deliveryCash += order.getPrice()
                    deliveryCash -= order.getRefund()
                }else{
                    deliveryCredit += order.getPrice()
                    deliveryCredit -= order.getRefund()
                }
        
                
                if (order.getVendor() == "Delivery.com")
                {
                    if (order.getCash())
                    {
                        dcomCash += order.getPrice()
                        dcomCash -= order.getRefund()
                        
                    }else{
                        dcomCredit += order.getPrice()
                        dcomCredit -= order.getRefund()
                    }
                    
                    dcomTotal += order.getPrice()
                    dcomTotal -= order.getRefund()
                    dcomNum += 1
                }
                    
                else if (order.getVendor() == "In Store")
                {
                    if (order.getCash())
                    {
                        inStoreCash += order.getPrice()
                        inStoreCash -= order.getRefund()
                    } else {
                        inStoreCredit += order.getPrice()
                        inStoreCredit -= order.getRefund()
                    }
                    
                    inStoreTotal += order.getPrice()
                    inStoreTotal -= order.getRefund()
                    inStoreNum += 1
                }
                else if (order.getVendor() == "Eat24")
                {
                    if (order.getCash())
                    {
                        eat24DeliveryCash += order.getPrice()
                        eat24DeliveryCash -= order.getRefund()
                    }else{
                        eat24DeliveryCredit += order.getPrice()
                        eat24DeliveryCredit -= order.getRefund()
                    }
                    
                    eat24DeliveryTotal += order.getPrice()
                    eat24DeliveryTotal -= order.getRefund()
                    eat24DeliveryNum += 1
                }
                else if (order.getVendor() == "Foodler")
                {
                    if (order.getCash())
                    {
                        foodlerCash += order.getPrice()
                        foodlerCash -= order.getRefund()
                    }else{
                        foodlerCredit += order.getPrice()
                        foodlerCredit -= order.getRefund()
                    }
                    
                    foodlerTotal += order.getPrice()
                    foodlerTotal -= order.getRefund()
                    foodlerNum += 1
                    
                }
                else if (order.getVendor() == "Groupon")
                {
                    grouponCredit += order.getPrice()
                    grouponCredit -= order.getRefund()
                    
                    grouponTotal += order.getPrice()
                    grouponTotal -= order.getRefund()
                    
                    grouponNum += 1
                }
                else if (order.getVendor() == "Grubhub")
                {
                    if (order.getCash())
                    {
                        grubhubCash += order.getPrice()
                        grubhubCash -= order.getRefund()
                    }else{
                        grubhubCredit += order.getPrice()
                        grubhubCredit -= order.getRefund()
                    }
                    
                    grubhubTotal += order.getPrice()
                    grubhubTotal -= order.getRefund()
                    grubhubNum += 1
                }
                else if (order.getVendor() == "Seamless")
                {
                    seamlessCredit += order.getPrice()
                    seamlessCredit -= order.getRefund()
                    
                    seamlessTotal += order.getPrice()
                    seamlessTotal -= order.getRefund()
                    
                    seamlessNum += 1
                }
                else if (order.getVendor() == "SLICE")
                {
                    sliceCredit += order.getPrice()
                    sliceCredit -= order.getRefund()
                    
                    sliceTotal += order.getPrice()
                    sliceTotal -= order.getRefund()
                    
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
        
        instoreCashLabel.text = inStoreCash.description
        instoreCreditLabel.text = inStoreCredit.description
        instoreNumLabel.text = inStoreNum.description
        instoreTotalLabel.text = inStoreTotal.description
        
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayPickup()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        separateTotals()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayTotals()
    {
        //hide pickup header and show delivery
        pickupHeader.isHidden = true
        deliveryHeader.isHidden = true
        
        //hide delivery # and $ labels
        dcomCashLabel.isHidden = true
        dcomCreditLabel.isHidden = true
        dcomTotalLabel.isHidden = true
        dcomNumLabel.isHidden = true
        
        instoreCreditLabel.isHidden = true
        instoreCashLabel.isHidden = true
        instoreTotalLabel.isHidden = true
        instoreNumLabel.isHidden = true
        
        eat24CashDeliveryLabel.isHidden = true
        eat24CreditDeliveryLabel.isHidden = true
        eat24TotalDeliveryLabel.isHidden = true
        eat24NumDeliveryLabel.isHidden = true
        
        foodlerCashLabel.isHidden = true
        foodlerCreditLabel.isHidden = true
        foodlerTotalLabel.isHidden = true
        foodlerNumLabel.isHidden = true
        
        grouponCreditLabel.isHidden = true
        grouponTotalLabel.isHidden = true
        grouponNumLabel.isHidden = true
        
        grubhubCashDeliveryLabel.isHidden = true
        grubhubCreditDeliveryLabel.isHidden = true
        grubhubTotalDeliveryLabel.isHidden = true
        grubhubNumDeliveryLabel.isHidden = true
        
        seamlessCreditLabel.isHidden = true
        seamlessTotalLabel.isHidden = true
        seamlessNumLabel.isHidden = true
        
        sliceCreditLabel.isHidden = true
        sliceTotalLabel.isHidden = true
        sliceNumLabel.isHidden = true
        
        //hide pickup identifiers
        amazonIdentifier.isHidden = true
        caviarIdentifier.isHidden = true
        doordashIdentifier.isHidden = true
        eat24PickupIdentifier.isHidden = true
        postmatesIdentifier.isHidden = true
        uberIdentifier.isHidden = true
        grubhubIdentifier.isHidden = true
        
        //hide delivery identifiers (excluding grubhub)
        dcomIdentifier.isHidden = true
        eat24DeliveryIdentifier.isHidden = true
        foodlerIdentifier.isHidden = true
        grouponIdentifier.isHidden = true
        seamlessIdentifier.isHidden = true
        sliceIdentifier.isHidden = true
        instoreIdentifier.isHidden = true
        
        //hide pickup # and $ labels
        amazonCreditLabel.isHidden = true              //future -- use function to set to true/false? -- try it
        amazonCashLabel.isHidden = true
        amazonTotalLabel.isHidden = true
        amazonNumLabel.isHidden = true
        
        caviarCreditLabel.isHidden = true
        caviarCashLabel.isHidden = true
        caviarTotalLabel.isHidden = true
        caviarNumLabel.isHidden = true
        
        doordashCreditLabel.isHidden = true
        doordashNumLabel.isHidden = true
        doordashCashLabel.isHidden = true
        doordashTotalLabel.isHidden = true
        
        eat24CreditLabel.isHidden = true
        eat24NumLabel.isHidden = true
        eat24CashLabel.isHidden = true
        eat24TotalLabel.isHidden = true
        
        grubhubCreditLabel.isHidden = true
        grubhubNumLabel.isHidden = true
        grubhubCashLabel.isHidden = true
        grubhubTotalLabel.isHidden = true
        
        
        postmatesCreditLabel.isHidden = true
        postmatesNumLabel.isHidden = true
        postmatesCashLabel.isHidden = true
        postmatesTotalLabel.isHidden = true
        
        uberCreditLabel.isHidden = true
        uberNumLabel.isHidden = true
        uberCashLabel.isHidden = true
        uberTotalLabel.isHidden = true
        
        //show column headers
        cashIdentifier.isHidden = true
        creditIdentifier.isHidden = true
        totalMoneyIdentifier.isHidden = true
        totalNumIdentifier.isHidden = true
        
        //show pickup identifiers and totals
        totalPickupCreditIdentifier.isHidden = false
        totalPickupNumIdentifier.isHidden = false
        totalPickupRefundsIdentifier.isHidden = false
        
        totalPickupCredit.isHidden = false
        totalPickupNum.isHidden = false
        pickupRefunds.isHidden = false
        
        
        //show delivery identifiers and totals
        totalDeliveryIdentifier.isHidden = false
        totalDeliveryNumIdentifier.isHidden = false
        totalDeliveryCashIdentifier.isHidden = false
        totalDeliveryCreditIdentifier.isHidden = false
        totalDeliveryRefundsIdentifier.isHidden = false
        
        deliveryRefunds.isHidden = false
        totalDeliveryCredit.isHidden = false
        totalDeliveryCash.isHidden = false
        totalDelivery.isHidden = false
        totalDeliveryNum.isHidden = false
        
        //show driver identifiers and totals
        totalTipsIdentifier.isHidden = false
        totalTips.isHidden = false
        
        totalDeliveryFees.isHidden = false
        totalDeliveryFeesIdentifier.isHidden = false
        
        driverPayout.isHidden = false
        driverPayoutIdentifier.isHidden = false
    }
    
    func displayDelivery()
    {
        //hide pickup header and show delivery
        pickupHeader.isHidden = true
        deliveryHeader.isHidden = false
        
        //hide pickup identifiers
        amazonIdentifier.isHidden = true
        caviarIdentifier.isHidden = true
        doordashIdentifier.isHidden = true
        eat24PickupIdentifier.isHidden = true
        postmatesIdentifier.isHidden = true
        uberIdentifier.isHidden = true
        
        //Identifier for both
        grubhubIdentifier.isHidden = false
        
        //show delivery identifiers (excluding grubhub)
        dcomIdentifier.isHidden = false
        eat24DeliveryIdentifier.isHidden = false
        foodlerIdentifier.isHidden = false
        grouponIdentifier.isHidden = false
        seamlessIdentifier.isHidden = false
        sliceIdentifier.isHidden = false
        instoreIdentifier.isHidden = false
        
        //hide pickup # and $ labels
        amazonCreditLabel.isHidden = true              //future -- use function to set to true/false? -- try it
        amazonCashLabel.isHidden = true
        amazonTotalLabel.isHidden = true
        amazonNumLabel.isHidden = true
        
        caviarCreditLabel.isHidden = true
        caviarCashLabel.isHidden = true
        caviarTotalLabel.isHidden = true
        caviarNumLabel.isHidden = true
        
        doordashCreditLabel.isHidden = true
        doordashNumLabel.isHidden = true
        doordashCashLabel.isHidden = true
        doordashTotalLabel.isHidden = true
        
        eat24CreditLabel.isHidden = true
        eat24NumLabel.isHidden = true
        eat24CashLabel.isHidden = true
        eat24TotalLabel.isHidden = true
        
        grubhubCreditLabel.isHidden = true
        grubhubNumLabel.isHidden = true
        grubhubCashLabel.isHidden = true
        grubhubTotalLabel.isHidden = true
        
        postmatesCreditLabel.isHidden = true
        postmatesNumLabel.isHidden = true
        postmatesCashLabel.isHidden = true
        postmatesTotalLabel.isHidden = true
        
        uberCreditLabel.isHidden = true
        uberNumLabel.isHidden = true
        uberCashLabel.isHidden = true
        uberTotalLabel.isHidden = true
        
        //show delivery # and $ labels
        dcomCashLabel.isHidden = false
        dcomCreditLabel.isHidden = false
        dcomTotalLabel.isHidden = false
        dcomNumLabel.isHidden = false
        
        eat24CashDeliveryLabel.isHidden = false
        eat24CreditDeliveryLabel.isHidden = false
        eat24TotalDeliveryLabel.isHidden = false
        eat24NumDeliveryLabel.isHidden = false
        
        foodlerCashLabel.isHidden = false
        foodlerCreditLabel.isHidden = false
        foodlerTotalLabel.isHidden = false
        foodlerNumLabel.isHidden = false
        
        grouponCreditLabel.isHidden = false
        grouponTotalLabel.isHidden = false
        grouponNumLabel.isHidden = false
        
        grubhubCashDeliveryLabel.isHidden = false
        grubhubCreditDeliveryLabel.isHidden = false
        grubhubTotalDeliveryLabel.isHidden = false
        grubhubNumDeliveryLabel.isHidden = false
        
        instoreCreditLabel.isHidden = false
        instoreCashLabel.isHidden = false
        instoreTotalLabel.isHidden = false
        instoreNumLabel.isHidden = false
        
        seamlessCreditLabel.isHidden = false
        seamlessTotalLabel.isHidden = false
        seamlessNumLabel.isHidden = false
        
        sliceCreditLabel.isHidden = false
        sliceTotalLabel.isHidden = false
        sliceNumLabel.isHidden = false
        
        //show column headers
        cashIdentifier.isHidden = false
        creditIdentifier.isHidden = false
        totalMoneyIdentifier.isHidden = false
        totalNumIdentifier.isHidden = false
        
        //hide pickup identifiers and totals
        totalPickupCreditIdentifier.isHidden = true
        totalPickupNumIdentifier.isHidden = true
        totalPickupRefundsIdentifier.isHidden = true
        
        totalPickupCredit.isHidden = true
        totalPickupNum.isHidden = true
        pickupRefunds.isHidden = true
        
        
        //show delivery identifiers and totals
        totalDeliveryIdentifier.isHidden = false
        totalDeliveryNumIdentifier.isHidden = false
        totalDeliveryCashIdentifier.isHidden = false
        totalDeliveryCreditIdentifier.isHidden = false
        totalDeliveryRefundsIdentifier.isHidden = false
        
        deliveryRefunds.isHidden = false
        totalDeliveryCredit.isHidden = false
        totalDeliveryCash.isHidden = false
        totalDelivery.isHidden = false
        totalDeliveryNum.isHidden = false
        
        //hide driver identifiers and totals
        totalTipsIdentifier.isHidden = false
        totalTips.isHidden = false
        
        totalDeliveryFees.isHidden = false
        totalDeliveryFeesIdentifier.isHidden = false
        
        driverPayout.isHidden = false
        driverPayoutIdentifier.isHidden = false
    }
    
    func displayPickup()
    {
        //show pickup header and hide delivery
        pickupHeader.isHidden = false
        deliveryHeader.isHidden = true
        
        //show pickup identifiers
        amazonIdentifier.isHidden = false
        caviarIdentifier.isHidden = false
        doordashIdentifier.isHidden = false
        eat24PickupIdentifier.isHidden = false
        postmatesIdentifier.isHidden = false
        uberIdentifier.isHidden = false
        
        //Identifier for both
        grubhubIdentifier.isHidden = false
        
        //hide delivery identifiers (excluding grubhub)
        dcomIdentifier.isHidden = true
        eat24DeliveryIdentifier.isHidden = true
        foodlerIdentifier.isHidden = true
        grouponIdentifier.isHidden = true
        seamlessIdentifier.isHidden = true
        sliceIdentifier.isHidden = true
        instoreIdentifier.isHidden = true
        
        //show pickup # and $ labels
        amazonCreditLabel.isHidden = false              //future -- use function to set to true/false? -- try it
        amazonCashLabel.isHidden = false
        amazonTotalLabel.isHidden = false
        amazonNumLabel.isHidden = false
        
        caviarCreditLabel.isHidden = false
        caviarCashLabel.isHidden = false
        caviarTotalLabel.isHidden = false
        caviarNumLabel.isHidden = false
        
        doordashCreditLabel.isHidden = false
        doordashNumLabel.isHidden = false
        doordashCashLabel.isHidden = false
        doordashTotalLabel.isHidden = false
        
        eat24CreditLabel.isHidden = false
        eat24NumLabel.isHidden = false
        eat24CashLabel.isHidden = false
        eat24TotalLabel.isHidden = false
        
        grubhubCreditLabel.isHidden = false
        grubhubNumLabel.isHidden = false
        grubhubCashLabel.isHidden = false
        grubhubTotalLabel.isHidden = false
        
        postmatesCreditLabel.isHidden = false
        postmatesNumLabel.isHidden = false
        postmatesCashLabel.isHidden = false
        postmatesTotalLabel.isHidden = false
        
        uberCreditLabel.isHidden = false
        uberNumLabel.isHidden = false
        uberCashLabel.isHidden = false
        uberTotalLabel.isHidden = false
        
        //hide delivery # and $ labels
        dcomCashLabel.isHidden = true
        dcomCreditLabel.isHidden = true
        dcomTotalLabel.isHidden = true
        dcomNumLabel.isHidden = true
        
        eat24CashDeliveryLabel.isHidden = true
        eat24CreditDeliveryLabel.isHidden = true
        eat24TotalDeliveryLabel.isHidden = true
        eat24NumDeliveryLabel.isHidden = true
        
        foodlerCashLabel.isHidden = true
        foodlerCreditLabel.isHidden = true
        foodlerTotalLabel.isHidden = true
        foodlerNumLabel.isHidden = true
        
        grouponCreditLabel.isHidden = true
        grouponTotalLabel.isHidden = true
        grouponNumLabel.isHidden = true
        
        instoreCreditLabel.isHidden = true
        instoreCashLabel.isHidden = true
        instoreTotalLabel.isHidden = true
        instoreNumLabel.isHidden = true
        
        grubhubCashDeliveryLabel.isHidden = true
        grubhubCreditDeliveryLabel.isHidden = true
        grubhubTotalDeliveryLabel.isHidden = true
        grubhubNumDeliveryLabel.isHidden = true
        
        seamlessCreditLabel.isHidden = true
        seamlessTotalLabel.isHidden = true
        seamlessNumLabel.isHidden = true
        
        sliceCreditLabel.isHidden = true
        sliceTotalLabel.isHidden = true
        sliceNumLabel.isHidden = true
        
        //show column headers
        cashIdentifier.isHidden = false
        creditIdentifier.isHidden = false
        totalMoneyIdentifier.isHidden = false
        totalNumIdentifier.isHidden = false
        
        //show pickup identifiers and totals
        totalPickupCreditIdentifier.isHidden = false
        totalPickupNumIdentifier.isHidden = false
        totalPickupRefundsIdentifier.isHidden = false
        
        totalPickupCredit.isHidden = false
        totalPickupNum.isHidden = false
        pickupRefunds.isHidden = false
        
        
        //hide delivery identifiers and totals
        totalDeliveryIdentifier.isHidden = true
        totalDeliveryNumIdentifier.isHidden = true
        totalDeliveryCashIdentifier.isHidden = true
        totalDeliveryCreditIdentifier.isHidden = true
        totalDeliveryRefundsIdentifier.isHidden = true
        
        deliveryRefunds.isHidden = true
        totalDeliveryCredit.isHidden = true
        totalDeliveryCash.isHidden = true
        totalDelivery.isHidden = true
        totalDeliveryNum.isHidden = true
        
        //hide driver identifiers and totals
        totalTipsIdentifier.isHidden = true
        totalTips.isHidden = true
        
        totalDeliveryFees.isHidden = true
        totalDeliveryFeesIdentifier.isHidden = true
        
        driverPayout.isHidden = true
        driverPayoutIdentifier.isHidden = true
    }
    



}
