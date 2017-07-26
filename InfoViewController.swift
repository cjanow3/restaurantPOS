//
//  InfoViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 7/24/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //Mark: Text fields
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var relationshipTF: UITextField!
    @IBOutlet weak var phoneNumTF: UITextField!
    
    
    //MARK: Table view
    @IBOutlet weak var tableView: UITableView!
    var refresher: UIRefreshControl!
    var list = restaurantController.fetchContacts()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! InfoTableViewCell
        
        cell.nameLabel.text = list[indexPath.row].getName()
        cell.relationshipLabel.text = list[indexPath.row].getRelationship()
        cell.phoneNumLabel.text = list[indexPath.row].getPhoneNum()
        
        return cell
    }
    
    func populate() {
        
        list = restaurantController.fetchContacts()
        
        refresher.endRefreshing()
        tableView.reloadData()
    }
    
    @IBAction func saveContact(_ sender: Any) {
        
        guard let contactName = nameTF.text, let contactRelation = relationshipTF.text, let contactPhoneNum = phoneNumTF.text else
        {
            createSimpleAlert(title: "Check Input", message: "At least one field was missing")
            return
        }
        
        let aContact = restaurantController.ContactItem(NAME: contactName, RELATIONSHIP: contactRelation, PHONENUM: contactPhoneNum)
        
        
        createAlert(title: "Is this correct?", message: "\(contactName)\n\(contactRelation)\n\(contactPhoneNum)", theContact: aContact)
        
        
    }
    
    func clearFieldsAfterEntry()
    {
        nameTF.text = ""
        relationshipTF.text = ""
        phoneNumTF.text = ""
    }
    
    //MARK: UIAlert functions
    func createSimpleAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func createAlert(title: String, message: String, theContact:restaurantController.ContactItem) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //create cancel action
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //create ok action
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) -> Void in print("OK")
            
            restaurantController.storeOrder_OBJECT(newContact: theContact)
            self.clearFieldsAfterEntry()
            
                   })
 
 
        
        alert.addAction(cancel)
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    //end alert functions


    

    override func viewDidLoad() {
        super.viewDidLoad()

        //adding a refresher to table view
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Updating...")
        refresher.addTarget(self, action: #selector(InfoViewController.populate), for: .valueChanged)
        tableView.addSubview(refresher)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
