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
    
    
    @IBOutlet weak var endOfDayCash: UITextField!
    @IBOutlet weak var endOfDayCredit: UITextField!
    @IBOutlet weak var endOfDayTips: UITextField!
    @IBOutlet weak var endOfDayXFactor: UITextField!
    
    @IBOutlet weak var foodaCateringTotal: UITextField!
    @IBOutlet weak var foodaPopup: UITextField!
    @IBOutlet weak var foodaCateringTips: UITextField!
    //
    //MARK: Reset day -- prompts user with password before clearing out core data
    //
    
    @IBAction func resetDay(_ sender: Any)
    {
        createAlert_ResetDay(title: "Enter Password", message: "")
    }
    
    //
    //MARK: Email -- takes current orders and ultimately creates a .csv file along with xfactor, store credit/cash/tips, etc.
    //
    
    @IBAction func emailCurrentData(_ sender: Any)
    {
        guard let endCash = Double(endOfDayCash.text!), let endCredit = Double(endOfDayCredit.text!), let endTip = Double(endOfDayTips.text!), let endXFactor = endOfDayXFactor.text, let endFoodaCateringTotal = Double(foodaCateringTotal.text!), let endFoodaCateringTips = Double(foodaCateringTips.text!), let endFoodaPopup = Double(foodaPopup.text!) else {
            createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
            return
        }
        
        //
        // displayed in column in email
        //
        
        let endTotalCreditCard = endCredit + endTip
        
        //
        //fetch data that will be emailed
        //
        
        let orders = restaurantController.fetchOrders()
        
        //
        //format current date so we know what day the orders are from
        //
        
        let date = Date()
        let formatter = DateFormatter()
        let filenameEnding = "_TaylorOrderData.csv"
    
        formatter.dateFormat = "MM.dd.yyyy"
        formatter.timeZone = NSTimeZone(name:"CT")! as TimeZone
        var filename = formatter.string(from: date)
        
        filename.append(filenameEnding)
        
        
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)
        
    
        //
        //create text for csv file -- Pickup then Delivery
        //
        
        var csvText = "XFactor,Store Cash,Store Credit Card,Store Card Tip,Credit Card Total,FOODA - Popup,FOODA - Catering Total,FOODA - Catering Tips,"
        
        //
        // Get pickup/delviery vendors and the last element in that list
        // to determine if to append '\n' or ',' to maintain format
        //
        
        let deliveryOrders = restaurantController.fetchDeliveryOrders()
        var totDF = 0.0
        var totTip = 0.0
        var totEarned = 0.0
        
        let pickupVendors = restaurantController.fetchPickupVendors()
        let lastPickupVendor = pickupVendors.last
        
        let deliveryVendors = restaurantController.fetchDeliveryVendors()
        let lastDeliveryVendor = deliveryVendors.last
        
        var pickupLine = ""
        var deliveryLine = ""
        
        var totalSales = 0.0
        var totalPickupSales = 0.0
        var totalDeliverySales = 0.0
        

        
         //
         // Retrieve driver's payout, then subtract it from
         // delivery totals to record accurate restaurant sales
         //
        
         for res in deliveryOrders {
            totDF += res.getDeliveryFee()
            totTip += res.getTip()
         }
         
         totEarned = totDF + totTip
 
        
        
        //
        // Add each pickup vendor's name to a string that is
        // appended to the csv text
        //
        
        for v in pickupVendors {
            
            pickupLine.append(v.getName() + ",")

        }
        
        csvText.append(pickupLine)
        
        //
        // - Add each delivery vendor's name to a string that is
        // appended to the csv text
        //
        // - Get total $ of sale from delivery vendors
        //
        
        for v in deliveryVendors {
            totalDeliverySales += v.getTotal()
            deliveryLine.append(v.getName() + " Credit," + v.getName() + " Cash," + v.getName() + " Total," + v.getName() + " # Deliveries,")
        }
        
        csvText.append(deliveryLine)

    

        csvText.append("Total Delivery Sales, Total Delivery #, Total Delivery Fees\n")
        
        //
        // - Calculate final totals before appending to csv text
        //
        // - Add actual numbers into the second row of the .csv file
        //   preFigures, pickup, delivery, totals
        //
        
        
        totalDeliverySales -= totEarned
        
        
        //
        // Adding pre figures
        //
        let secondRowPreFigures = (endXFactor + "," + endCash.description + "," + endCredit.description + "," + endTip.description  + "," + endTotalCreditCard.description + "," + endFoodaPopup.description + "," + endFoodaCateringTotal.description + "," + endFoodaCateringTips.description + ",")
        
        csvText.append(secondRowPreFigures)
    
 
        //
        // Adding pickup numbers
        //
 
        for v in pickupVendors {
            csvText.append(v.getTotal().description + ",")
 
        }
         
        
        //
        // Adding delivery numbers
        //
        
         for v in deliveryVendors {
         
         csvText.append(v.getCredit().description + "," + v.getCash().description + "," + v.getTotal().description + "," + v.getNum().description + ",")
         
         }
 
        //
        // Adding final totals
        //
        
        csvText.append(totalDeliverySales.description + "," + deliveryOrders.count.description + "," + totDF.description)

        //
        // attempt to create file
        //
 
        do {
            
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            
        } catch {
            
            print("Failed to create file")
            print("\(error)")
            return
        }
        
        
        if MFMailComposeViewController.canSendMail() {              //checking to see if it is possible to send mail
            let emailController = MFMailComposeViewController()     //email view controller init
            emailController.mailComposeDelegate = self              //setting delegate to self
            emailController.setToRecipients(["chrisjanowski@hotmail.com","jgaytan@uwalumni.com","emeraldmillan@gmail.com"])
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
    
    
    func createSimpleAlert(title: String, message: String)
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
                
                self.createSimpleAlert(title: "Incorrect", message: "Try again")
                
            }
                
            else
            {
                restaurantController.cleanAllOrdersCoreData()
                restaurantController.zeroOutVendors()
                
                self.createSimpleAlert(title: "Confirmed", message: "The day has been reset.")
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
