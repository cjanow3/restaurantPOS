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
    
    
    //MARK: Reset day

    @IBAction func resetDay(_ sender: Any)
    {
        createAlert_ResetDay(title: "Enter Password", message: "")
    }
    
    
    
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
        
        var csvText = "Num Deliveries, Total $ Deliveries, Num Pickups, Total $ Pickups\n"
        
        var numD = 0
        var numP = 0
        var monD = 0.0
        var monP = 0.0
        
        for ord in orders
        {
            if (ord.pickup)
            {
                numP += 1
                monP += ord.getPrice()
            } else {
                
                numD += 1
                monD += ord.getPrice()
            }
        
        }
        
        let newLine = "\(numD), \(monD), \(numP), \(monP)"
        csvText.append(newLine)
        
        //print(csvText)
        
        do {
            
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            
        } catch {
            
            print("Failed to create file")
            print("\(error)")
        }
        
        
        if MFMailComposeViewController.canSendMail() {              //checking to see if it is possible to check mail
            let emailController = MFMailComposeViewController()     //email view controller init
            emailController.mailComposeDelegate = self              //setting delegate to self
            emailController.setToRecipients(["chrisjanowski@hotmail.com"])
            emailController.setSubject("Email data for \(date)")
            emailController.setMessageBody("See attached .csv file for the excel data", isHTML: false)
            
            emailController.addAttachmentData(NSData(contentsOf: path!)! as Data, mimeType: "text/csv", fileName: "Orders.csv")
            
            present(emailController, animated: true, completion: nil)
        }
        
        
        func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
            controller.dismiss(animated: true, completion: nil)
        }
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
