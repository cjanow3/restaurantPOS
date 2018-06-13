//
//  InfoViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 7/24/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit
import FirebaseDatabase


class ContactViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return getRelationships().count
    }
    
    //
    // Returns value that will be displayed in the picker view
    //
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let list = getRelationships()
        
        return list[row]
    }
    
    @IBOutlet weak var contactHeader: UILabel!
    
    @IBOutlet weak var newContactButton: UIButton!
    @IBOutlet weak var mainMenuButton: UIButton!
    @IBOutlet weak var fliterButton: UIButton!
    
    
    //
    // Create FirebaseDatabase reference
    //
    
    @IBOutlet weak var mainView: UIView!
    var ref:DatabaseReference!
    var uid:String = ""

    //
    // Text fields
    //
    
    var newNameTF: UITextField?
    var newRelationshipTF: UITextField?
    var newPhoneNumTF: UITextField?
    var newEmailTF: UITextField!
    
    var currentlyEditing = false
    var editIndex = 0
    
    //
    // Table view
    //
    
    @IBOutlet weak var tableView: UITableView!
    var contactlist = [newContact]()
    var tableviewlist = [newContact]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableviewlist.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let contact = tableviewlist[indexPath.row]
        let message = "Name: " + contact.getName() + "\n" + "Email: " + contact.getEmail() + "\n" + "Phone Number: " + contact.getPhoneNum() + "\n" + "Relationship: " + contact.getRelationship()
        
        self.createSimpleAlert(title: "Contact #" + (indexPath.row+1).description, message: message)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! InfoTableViewCell
        
        let isIndexValid = self.tableviewlist.indices.contains(indexPath.row)

        if (isIndexValid) {
            
            cell.nameLabel.text = tableviewlist[indexPath.row].getName()
            
            //
            // Return modified way to display phone numbers
            // e.g. (012)-345-6789
            //
            
            let displayNumber = extractPhoneNumberFromString(phoneNumber: tableviewlist[indexPath.row].getPhoneNum())
            cell.phoneNumLabel.text = displayNumber
            
            return cell
        } else {
            cell.nameLabel.text = "nil"
            cell.phoneNumLabel.text = "nil"
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete)
        {
            
            let id = self.tableviewlist[indexPath.row].getID()
            
            ref.child("contacts").child(id).removeValue()
            
            getContacts()
            
        }
    }
    
    //
    // Grabs all contacts from FirebaseDatabase and refreshes table view
    //
    
    func getContacts() {
        
        self.contactlist.removeAll()
        
        ref.child("contacts").observe(.childAdded, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String : AnyObject] {

                let contact = newContact()

                contact.setName(NAME: dictionary["name"] as! String)
                contact.setEmail(EMAIL: dictionary["email"] as! String)
                contact.setRelationship(RELATIONSHIP: dictionary["relationship"] as! String)
                contact.setPhoneNum(NUM:dictionary["phoneNum"] as! String)
                contact.setID(ID: dictionary["id"] as! String)

                
                var beenAdded = false
                
                for c in self.contactlist {
                    if c.getID() == contact.getID() {
                        beenAdded = true
                    }
                }
                
                if (!beenAdded) {
                    self.contactlist.append(contact)
                }
                
                //
                // Refresh Tableview
                //
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        })
        
        //
        // Refresh Tableview
        //
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    } //end getContacts
    
    func nameTFSetup(textfield: UITextField!) {
        
        if currentlyEditing {
            newNameTF = textfield
            newNameTF?.text = self.contactlist[editIndex].getName()
        } else {
            newNameTF = textfield
            newNameTF?.placeholder = "Name"
        }
        
        
    }
    
    func phoneNumTFSetup(textfield: UITextField!) {
        
        if currentlyEditing {
            newPhoneNumTF = textfield
            newPhoneNumTF?.keyboardType = UIKeyboardType.phonePad
            newPhoneNumTF?.text = self.contactlist[editIndex].getPhoneNum()
        } else {
            newPhoneNumTF = textfield
            newPhoneNumTF?.keyboardType = UIKeyboardType.phonePad
            newPhoneNumTF?.placeholder = "Phone Number"
        }
        
    }
    
    func emailTFSetup(textfield: UITextField!) {
        if currentlyEditing {
            newEmailTF = textfield
            newEmailTF?.keyboardType = UIKeyboardType.emailAddress
            newEmailTF?.text = self.contactlist[editIndex].getEmail()
        } else {
            newEmailTF = textfield
            newEmailTF?.keyboardType = UIKeyboardType.emailAddress
            newEmailTF?.placeholder = "Email"
        }
        
    }
    
    func relationTFSetup(textfield: UITextField!) {
        if currentlyEditing {
            newRelationshipTF = textfield
            newRelationshipTF?.text = self.contactlist[editIndex].getRelationship()
        } else {
            newRelationshipTF = textfield
            newRelationshipTF?.placeholder = "Relationship"
        }
    }
    
    //
    // filters table view by relationship
    //
    
    @IBAction func filterByRelationship(_ sender: Any) {
        let relationships = getRelationships()
        self.tableviewlist.removeAll()
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 150)
        let filterPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 150))
        
        filterPicker.delegate = self
        filterPicker.dataSource = self
        
        vc.view.addSubview(filterPicker)
        
        let alert = UIAlertController(title: "Choose Filter", message: "", preferredStyle: .alert)
        alert.setValue(vc, forKey: "contentViewController")
        
        let createFilter = UIAlertAction(title: "Filter", style: .default, handler: { (action: UIAlertAction) -> Void in
            
            //
            // Get user's choice
            //
            // currentRow = contact relationship
            //
            
            let filterChoice = relationships[filterPicker.selectedRow(inComponent: 0)]
            self.tableviewlist = self.contactlist.filter { $0.getRelationship() == filterChoice }
            
            //
            // Refresh Tableview
            //
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
           
            
        })
        
        let resetFilter = UIAlertAction(title: "Reset", style: .default, handler: { (action: UIAlertAction) -> Void in
            
            self.tableviewlist = self.contactlist

            
            //
            // Refresh Tableview
            //
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
            
        })
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(createFilter)
        alert.addAction(resetFilter)
        self.present(alert, animated: true)
        
    
    }
        
    
    
    //
    // Returns list of strings of all relationships
    //
    
    func getRelationships() -> [String] {
        
        var relationshipList = [String]()
        
        for c in self.contactlist {
            relationshipList.append(c.getRelationship())
        }
        
        relationshipList = Array(Set(relationshipList))
        
        return relationshipList
    }

    
    //
    // creates new contact
    //
    func createAlertAddContact(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nameTFSetup)
        alert.addTextField(configurationHandler: emailTFSetup)
        alert.addTextField(configurationHandler: phoneNumTFSetup)
        alert.addTextField(configurationHandler: relationTFSetup)
        
        let ok = UIAlertAction(title: "Add", style: .default, handler: { (action: UIAlertAction) -> Void in 
            
            var email = "N/A"
            var relationship = "N/A"
            
            guard var name = self.newNameTF?.text!, let phoneNum = self.newPhoneNumTF?.text else {
                self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                return
            }
            
            //
            // Checks for arbitrary amount of spaces and proper format for phone number
            // because name and a phone number must be provided, other fields are optional.
            // Then, save info if conditions are met. Otherwise, show alert stating failure.
            //
            
            let tempName = name.trimmingCharacters(in: .whitespaces)
            let tempPhoneNum = self.extractPhoneNumberFromString(phoneNumber: phoneNum)
            
            if self.newEmailTF?.text! != "" {
                email = (self.newEmailTF?.text!)!
            }
            
            if self.newRelationshipTF?.text! != "" {
                relationship = (self.newRelationshipTF?.text!)!
            }

            
            
            if tempName != "" && tempPhoneNum != "Invalid phone number" {
                
                let idRef = self.ref.child("contacts").childByAutoId()
                let id = idRef.key
                
                name = name.capitalizeFirstLetter()
                
                let contactInfo = [
                    "name":          name,
                    "email":         email,
                    "relationship":  relationship,
                    "phoneNum":      phoneNum,
                    "id":            id
                    ] as [String : Any]
                
                self.ref.child("contacts").child(id).setValue(contactInfo)
                
                self.getContacts()
                
            } else {
                //
                // TODO: More descriptive error alerts
                //
                self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func saveContact(_ sender: Any) {
        
        currentlyEditing = false
        createAlertAddContact(title: "Enter Info", message: "")
    }

    //
    // UIAlert functions
    //
    
    func createSimpleAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    } //end alert functions
    
    func initView() {
        fliterButton.layer.cornerRadius = 10
        fliterButton.layer.masksToBounds = true
        fliterButton.layer.borderColor = UIColor.black.cgColor
        fliterButton.layer.borderWidth = 0.5
        fliterButton.layer.shadowColor = UIColor.black.cgColor
        fliterButton.layer.shadowOffset = CGSize.zero
        fliterButton.layer.shadowRadius = 5.0
        fliterButton.layer.shadowOpacity = 0.5
        fliterButton.clipsToBounds = false
        
        newContactButton.layer.cornerRadius = 10
        newContactButton.layer.masksToBounds = true
        newContactButton.layer.borderColor = UIColor.black.cgColor
        newContactButton.layer.borderWidth = 0.5
        newContactButton.layer.shadowColor = UIColor.black.cgColor
        newContactButton.layer.shadowOffset = CGSize.zero
        newContactButton.layer.shadowRadius = 5.0
        newContactButton.layer.shadowOpacity = 0.5
        newContactButton.clipsToBounds = false
        
        mainMenuButton.layer.cornerRadius = 10
        mainMenuButton.layer.masksToBounds = true
        mainMenuButton.layer.borderColor = UIColor.black.cgColor
        mainMenuButton.layer.borderWidth = 0.5
        mainMenuButton.layer.shadowColor = UIColor.black.cgColor
        mainMenuButton.layer.shadowOffset = CGSize.zero
        mainMenuButton.layer.shadowRadius = 5.0
        mainMenuButton.layer.shadowOpacity = 0.5
        mainMenuButton.clipsToBounds = false

        let strokeTextAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.strokeColor : UIColor.black,
            NSAttributedStringKey.foregroundColor : UIColor.white,
            NSAttributedStringKey.strokeWidth : -2.0,
            ]
        
        contactHeader.attributedText = NSAttributedString(string: "Contacts", attributes: strokeTextAttributes)
        
    }


    //used to dismiss keyboards
    @objc func doneClicked() {
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        tableviewlist = contactlist
        

        ref = Database.database().reference().child("users").child(uid)
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //
    // Creates a UIAlert that has text fields to edit a contact
    //
    
    func createAlertEditContact(Title:String) {
        
        let alert = UIAlertController(title: Title, message: "", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nameTFSetup)
        alert.addTextField(configurationHandler: emailTFSetup)
        alert.addTextField(configurationHandler: phoneNumTFSetup)
        alert.addTextField(configurationHandler: relationTFSetup)

        let ok = UIAlertAction(title: "Save", style: .default, handler: { (action: UIAlertAction) -> Void in
            var email = "N/A"
            var relationship = "N/A"
            
            guard var name = self.newNameTF?.text!, let phoneNum = self.newPhoneNumTF?.text  else {
                self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                return
            }
            
            //
            // Checks for arbitrary amount of spaces and proper format for phone number
            // because name and a phone number must be provided, other fields are optional.
            // Then, save info if conditions are met. Otherwise, show alert stating failure.
            //

            if self.newEmailTF?.text! != "" {
                email = (self.newEmailTF?.text!)!
            }
            
            if self.newRelationshipTF?.text! != "" {
                relationship = (self.newRelationshipTF?.text!)!
            }

            
            // Checks for arbitrary amount of spaces
            //
            
            let tempName = name.trimmingCharacters(in: .whitespaces)
            let tempPhoneNumber = self.extractPhoneNumberFromString(phoneNumber: phoneNum)
            
            if tempName != "" && tempPhoneNumber != "Invalid phone number" {
                let tempID = self.contactlist[self.editIndex].getID()
                
                name = name.capitalizeFirstLetter()

                let contactInfo = [
                    "name":          name,
                    "email":         email,
                    "relationship":  relationship,
                    "phoneNum":      phoneNum,
                    "id":            tempID
                    ] as [String : Any]
                
                self.ref.child("contacts").child(tempID).setValue(contactInfo)
                
                self.getContacts()
                
            } else {
                self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
            }
            
            self.createSimpleAlert(title: "Success!", message: "Contact has been successfully updated.")
        })

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    

 
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
    
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
    
            //
            // Create alert to edit that contact
            //
            
            self.editIndex = editActionsForRowAt.row
            self.currentlyEditing = true
            self.createAlertEditContact(Title: "Edit Contact")
         
        }
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            //
            // Delete note and refresh with confirmation alert
            //
            
            let contactname = self.contactlist[editActionsForRowAt.row].getName()
            
            let alert = UIAlertController(title: "Confirm Deletion", message: "Really delete '" + contactname + "'?", preferredStyle: .alert)
            let vc = UIViewController()
            vc.preferredContentSize = CGSize(width: 250,height: 30)
            
            alert.setValue(vc, forKey: "contentViewController")
            
            let ok = UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction) -> Void in
                let id = self.contactlist[editActionsForRowAt.row].getID()
                self.ref.child("contacts").child(id).removeValue()
                self.getContacts()
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
            


        }
    
        edit.backgroundColor = .orange
        delete.backgroundColor = .red
        
        return [edit,delete]
    
    }
    
    //
    // Take string and modify it with chars to make it
    // into a more readable string. Returns invalid if
    // conditions aren't met.
    //
    
    func extractPhoneNumberFromString(phoneNumber: String) -> String {
        
        let length = phoneNumber.count
        let hasLeadingOne = phoneNumber.hasPrefix("1")
        
        guard length == 10 || (length == 11 && hasLeadingOne) else {
            return "Invalid phone number"
        }
        
        //
        // 10 digits == 6304791928
        //
        // 11 digits with leading 1 == 16304791928
        //
        
        var areaCode:String.SubSequence
        var newAreaCode = ""
        
        if length == 10 {
            areaCode = phoneNumber.prefix(3)
            newAreaCode = "(" + areaCode + ")"
        } else if length == 11 && hasLeadingOne {
            areaCode = phoneNumber.prefix(4)
            newAreaCode = "(" + areaCode.suffix(3) + ")"
        }
        
        let coreNumbers = phoneNumber.suffix(7)
        
        let startCoreNumbers = coreNumbers.prefix(3)
        let endCoreNumbers   = coreNumbers.suffix(4)
        
        let finalNumber = newAreaCode + "-" + startCoreNumbers + "-" + endCoreNumbers
        
        return finalNumber
    }
 
 
}
