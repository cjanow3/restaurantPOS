//
//  EndOfDayVieController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 6/7/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit


class EndOfDayViewController: UIViewController {
    
    
    //MARK: Reset day

    @IBAction func resetDay(_ sender: Any)
    {
        createAlert_ResetDay(title: "Enter Password", message: "")
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
