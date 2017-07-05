//
//  EndOfDayVieController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 6/7/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit
import MessageUI

class EndOfDayViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    
    //MARK: Reset day -- prompts user with password before clearing out core data
    @IBAction func resetDay(_ sender: Any)
    {
        createAlert_ResetDay(title: "Enter Password", message: "")
    }
    
    
    //MARK: Email -- takes current 
    @IBAction func emailCurrentData(_ sender: Any)
    {
        //fetch data that will be emailed
        let orders = restaurantController.fetchOrders()
        
        //format current date so we know what day the orders are from
        let date = Date()
        let formatter = DateFormatter()
        let filenameEnding = "_TaylorOrderData.csv"
    
        formatter.dateFormat = "MM.dd.yyyy"
        var filename = formatter.string(from: date)
        
        filename.append(filenameEnding)
        
        //print (filename)
        
        
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)
        
        

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
        
        var inStoreCash = 0.0
        var inStoreCredit = 0.0
        var inStoreTotal = 0.0
        var inStoreNum = 0
        
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
        
        //separate totals
        for order in orders
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
                
                //driver gets paid each delivery fee and tip for deliveries
                
                driverPay += order.getDeliveryFee()
                driverPay += order.getTip()
                
                tips += order.getTip()
                deliveryfees += order.getDeliveryFee()
                
                //increase # deliveries for each delivery order, add to total price
                deliveryNum += 1
                
                deliveryTotal += order.getPrice()
                deliveryTotal -= order.getRefund()
                
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
        
        //create text for csv file -- Pickup then Delivery
        
        var csvText = "Pickups\n"
        
        csvText.append("Amazon Credit,Amazon Cash,Amazon Total,Caviar Credit,Caviar Cash,Caviar Total,Doordash Credit,Doordash Cash,Doordash Total,Eat24 Credit,Eat24 Cash,Eat24 Total,Grubhub Credit,Grubhub Cash,Grubhub Total,Postmates Credit,Postmates Cash,Postmates Total,Uber Credit,Uber Cash,Uber Total\n")

        let pickupLine = "\(amazonCredit),\(amazonCash),\(amazonTotal),\(caviarCredit),\(caviarCash),\(caviarTotal),\(doordashCredit),\(doordashCash),\(doordashTotal),\(eat24PickupCredit),\(eat24PickupCash),\(eat24PickupTotal),\(grubhubPickupCredit),\(grubhubPickupCash),\(grubhubPickupTotal),\(postmatesCredit),\(postmatesCash),\(postmatesTotal),\(uberCredit),\(uberCash),\(uberTotal)\n"
        

        
        csvText.append(pickupLine)
        
        csvText.append("Deliveries\n")
        
        csvText.append("Delivery.com Credit,Delivery.com Cash,Delivery.com Total,Eat24 Credit,Eat24 Cash,Eat24 Total,Foodler Credit,Foodler Cash,Foodler Total,Groupon Credit,Groupon Cash,Groupon Total,Grubhub Credit,Grubhub Cash,Grubhub Total,In Store Credit,In Store Cash,In Store Total,Seamless Credit,Seamless Cash,Seamless Total,SLICE Credit,SLICE Cash,SLICE Total\n")
        
        
        //Hardcode in 0 for 3 vendors becuase they are credit only, want to keep format the same
        let deliveryLine = "\(dcomCredit),\(dcomCash),\(dcomTotal),\(eat24DeliveryCredit),\(eat24DeliveryCash),\(eat24DeliveryTotal),\(foodlerCredit),\(foodlerCash),\(foodlerTotal),\(grouponCredit),0,\(grouponTotal),\(grubhubCredit),\(grubhubCash),\(grubhubTotal),\(inStoreCredit),\(inStoreCash),\(inStoreTotal),\(seamlessCredit),0,\(seamlessTotal),\(sliceCredit),0,\(sliceTotal)\n"
        
        csvText.append(deliveryLine)
        
        csvText.append("Totals\n")
        
        csvText.append("$ Online Pickup,# Online Pickup,$ Deliveries,# Deliveries\n")
        
        let totalLine = "\(pickupCredit),\(pickupNum),\(deliveryTotal),\(deliveryNum)\n"
        
        csvText.append(totalLine)
        
        csvText.append("Driver\n")
        
        csvText.append("Tips,Delivery Fees,Earned,Payout\n")
        
        let earned = tips + deliveryfees
        
        let driverLine = "\(tips),\(deliveryfees),\(driverPay),\(earned)\n"
        
        csvText.append(driverLine)
        
        
        //attempt to create file
        do {
            
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            
        } catch {
            
            print("Failed to create file")
            print("\(error)")
        }
        
        
        if MFMailComposeViewController.canSendMail() {              //checking to see if it is possible to send mail
            let emailController = MFMailComposeViewController()     //email view controller init
            emailController.mailComposeDelegate = self              //setting delegate to self
            emailController.setToRecipients(["chrisjanowski@hotmail.com"])          //add emeraldmillan@gmail.com , jgaytan@uwalumni.com
            emailController.setSubject("BIG G'S TAYLOR - Email data for \(date)")
            emailController.setMessageBody("<p>See attached .csv file for the taylor street data</p>", isHTML: true)
            
            emailController.addAttachmentData(NSData(contentsOf: path!)! as Data, mimeType: "text/csv", fileName: "Orders.csv")
            
            present(emailController, animated: true, completion: nil)
            
            func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
                
                emailController.dismiss(animated: true, completion: nil)
            }
        }
        
    
        
        
       
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
