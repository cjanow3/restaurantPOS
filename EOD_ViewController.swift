//
//  EOD_ViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 5/17/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit

class EOD_ViewController: UIViewController {

    //MARK: Return to main menu button
    
    @IBAction func returnmainmenu(_ sender: Any)
    {
        performSegue(withIdentifier: "mainmenuseg", sender: self)
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
