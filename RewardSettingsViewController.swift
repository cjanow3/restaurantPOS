//
//  RewardSettingsViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 11/19/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RewardSettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var ref:DatabaseReference!
    var uid:String = ""

    @IBOutlet weak var rewardsSettingsHeader: UILabel!
    var rewardsitemslist = [newRewardItem]()
    var rewardsuserslist = [newRewardUser]()
    //var rewardspromoslist = [newRewardPromo]()

    
    //
    // Text fields for reward item
    //
    
    var newNameTF: UITextField?
    var newPhoneNumTF: UITextField?
    var newPointsTF: UITextField?
    
    var editWhat = 0
    
    //
    // edit item
    //
    
    var editPointsTF: UITextField?
    var editPhoneNumTF: UITextField?
    var editNameTF: UITextField?
    
    //
    // edit user
    //
    
    //
    // TODO: edit promo
    //

    
    //
    // Add/edit/remove/back buttons
    //
    
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var editItemButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    //
    // Items components
    //
    
    @IBOutlet weak var itemsHeader: UILabel!
    @IBOutlet weak var itemsDescription: UILabel!
    
    //
    // Users components
    //
    
    @IBOutlet weak var usersHeader: UILabel!
    @IBOutlet weak var usersDescription: UILabel!
    
    //
    // Promos components
    //
    
    @IBOutlet weak var promosHeader: UILabel!
    @IBOutlet weak var promosDescription: UILabel!
    
    //
    // Picker View to display each reward component's data
    //
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    //
    // Returns respective string but changes font color to white
    //
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        switch segControl.selectedSegmentIndex {
        case 0:
            //
            // Return item
            //
            let titleData = rewardsitemslist[row].getName() + " - " + rewardsitemslist[row].getPoints().description + " pts"
            let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 15.0)!,NSAttributedStringKey.foregroundColor:UIColor.white])
            return myTitle
        case 1:
            //
            // Return user
            //
            let displayNumber = extractPhoneNumberFromString(phoneNumber: rewardsuserslist[row].getPhoneNum())
            let titleData = rewardsuserslist[row].getName() + "  " + displayNumber
            let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 15.0)!,NSAttributedStringKey.foregroundColor:UIColor.white])
            return myTitle
        case 2:
            //
            // Return promo
            //
            
            //return rewardspromoslist[row].getName()
            
            let titleData = "replace me with promolist"
            let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 15.0)!,NSAttributedStringKey.foregroundColor:UIColor.white])
            return myTitle
            
        default:
            let titleData = "nil"
            let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 15.0)!,NSAttributedStringKey.foregroundColor:UIColor.white])
            return myTitle
            
        }
    }
    
    
    //
    // Returns number of components inside of picker view
    //
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch segControl.selectedSegmentIndex {
        case 0:
            //
            // Return item
            //
            return rewardsitemslist.count
            
      case 1:
            //
            // Return user
            //
            return rewardsuserslist.count
            
        case 2:
            //
            // Return promo
            //
            
            //return rewardspromoslist.count
            return 0
        default:
            return 0
            
        }
    }
    

    
    
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBAction func changeSegIndex(_ sender: Any) {

        //
        // Items, users, promos
        //
        
        switch segControl.selectedSegmentIndex {
        case 0:
            DisplayItemsView()
            getRewardsItems()
            editWhat = 0
        case 1:
            DisplayUsersView()
            getRewardsUsers()
            editWhat = 1
        case 2:
            DisplayPromosView()
            print("Need to get promos")
            //getRewardsPromos()
            editWhat = 2
        default:
            break
        }
        
    }
    
    //
    // Remove Button
    //
    
    @IBAction func removeSomething(_ sender: Any) {
        switch segControl.selectedSegmentIndex {
            
            case 0:
                //
                // Remove item
                //
                if rewardsitemslist.count > 0 {
                    createAlertRemoveSomething(title: "Remove Item", option: 0)
                } else {
                    createSimpleAlert(title: "Error", message: "You need to have an item first before you remove one!")
            }
            case 1:
                //
                // Remove user
                //
                if rewardsuserslist.count > 0 {
                    createAlertRemoveSomething(title: "Remove User", option: 1)
                } else {
                    createSimpleAlert(title: "Error", message: "You need to have a user first before you remove one!")
                }
            
            case 2:
                //
                // Remove promo
                //
                createSimpleAlert(title: "Not ready!", message: "Sorry about that.")
                break
            default:
                break
        }
    }
    

    
    //
    // Add Button
    //
    
    @IBAction func addSomething(_ sender: Any) {
        switch segControl.selectedSegmentIndex {
        case 0:
            //
            // Add item
            //
            createAlertAddItem(title: "New Item", message: "")
            break
        case 1:
            //
            // Add user
            //
            
            createAlertAddUser(title: "New User", message: "")
            break
        case 2:
            //
            // Add promo
            //
            createSimpleAlert(title: "Not ready!", message: "Sorry about that.")
            break
        default:
            break
            
        }
    }
    
    
    //
    // Edit Button
    //
    
    
    @IBAction func editSomething(_ sender: Any) {
        switch segControl.selectedSegmentIndex {
        case 0:
            //
            // Edit Item
            //
            if rewardsitemslist.count < 0 {
                createAlertEditSomething(option: 0)
            } else {
                createSimpleAlert(title: "Error", message: "You need to have an item first before you edit one!")
            }
            break
        case 1:
            //
            // Edit User
            //
            if rewardsuserslist.count > 0 {
                createAlertEditSomething(option: 1)
            } else {
                createSimpleAlert(title: "Error", message: "You need to have a user first before you edit one!")
            }

            break
        case 2:
            //
            // Edit Promo
            //
            createSimpleAlert(title: "Not ready!", message: "Sorry about that.")

            break
        default:
            break
        }
    }
    
    //
    // Creates a UIAlert that has text fields to add a new item
    //
    
    func createAlertEditSomething(option: Int) {
        
        if option == 0 {
            //
            // Edit an item
            //

            let alert = UIAlertController(title: "Edit Item", message: "", preferredStyle: .alert)
            alert.addTextField(configurationHandler: editNameSetup)
            alert.addTextField(configurationHandler: editPointsSetup)
            
            let ok = UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction) -> Void in
                
                guard let name = self.editNameTF?.text!, let points = Int((self.editPointsTF?.text!)!) else {
                    self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                    return
                }
                
                //
                // Checks for arbitrary amount of spaces
                //
                
                let tempName = name.trimmingCharacters(in: .whitespaces)
                
                if tempName != "" {
                    
                    let id = self.rewardsitemslist[self.pickerView.selectedRow(inComponent: 0)].getID()

                    let itemInfo = [
                        "name":          name,
                        "id":            id,
                        "points":        points
                        ] as [String : Any]
                    
                    self.ref.child("rewards").child("items").child(id).setValue(itemInfo)
                    self.getRewardsItems()
                    
                } else {
                    self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                }
                
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(cancel)
            
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
            
        } else if option == 1 {
            //
            // Edit a user
            //
   
            let alert = UIAlertController(title: "Edit User", message: "", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: editNameSetup)
            alert.addTextField(configurationHandler: editPhoneNumSetup)
            alert.addTextField(configurationHandler: editPointsSetup)

            
            let ok = UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction) -> Void in
                
                guard let name = self.editNameTF?.text!, let phoneNum = self.editPhoneNumTF?.text!, let points = Int((self.editPointsTF?.text!)!) else {
                    self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                    return
                }
                
                
                //
                // Checks for arbitrary amount of spaces
                //
                
                let tempName = name.trimmingCharacters(in: .whitespaces)
                let tempPhoneNum = self.extractPhoneNumberFromString(phoneNumber: phoneNum)
                
                if tempName != "" && tempPhoneNum != "Invalid phone number" {
                    
                    let id = self.rewardsuserslist[self.pickerView.selectedRow(inComponent: 0)].getID()
                    
                    
                    let userInfo = [
                        "name":          name,
                        "points":        points,
                        "phoneNum":      phoneNum,
                        "id":            id
                        ] as [String : Any]
                    
                    
                    self.ref.child("rewards").child("users").child(id).setValue(userInfo)
                    
                    self.getRewardsUsers()
                } else {
                    self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                    
                }
                
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(cancel)
            
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
        } else {
            //
            // Edit a promo
            //
        }
        
        
    }
    
    //
    // Shows view that needs to be reflected depending
    // on which index seg control is on
    //
    
    func DisplayItemsView() {
        //
        // Items components
        //
        
        itemsHeader.isHidden = false
        itemsDescription.isHidden = false

        usersHeader.isHidden = true
        usersDescription.isHidden = true
        
        promosHeader.isHidden = true
        promosDescription.isHidden = true

    }
    
    func DisplayUsersView() {
        //
        // Items components
        //
        itemsHeader.isHidden = true
        itemsDescription.isHidden = true
        
        usersHeader.isHidden = false
        usersDescription.isHidden = false
        
        promosHeader.isHidden = true
        promosDescription.isHidden = true
    }
    
    func DisplayPromosView() {
        //
        // Items components
        //
        itemsHeader.isHidden = true
        itemsDescription.isHidden = true

        //
        // Users components
        //
        
        usersHeader.isHidden = true
        usersDescription.isHidden = true
        
        //
        // Promos components
        //
        
        promosHeader.isHidden = false
        promosDescription.isHidden = false
    }
    
    //
    // Setting up design for VC
    //
    
    func initView() {
        addItemButton.layer.cornerRadius = 10
        addItemButton.layer.masksToBounds = true
        addItemButton.layer.borderColor = UIColor.black.cgColor
        addItemButton.layer.borderWidth = 0.5
        addItemButton.layer.shadowColor = UIColor.black.cgColor
        addItemButton.layer.shadowOffset = CGSize.zero
        addItemButton.layer.shadowRadius = 5.0
        addItemButton.layer.shadowOpacity = 0.5
        addItemButton.clipsToBounds = false
        
        editItemButton.layer.cornerRadius = 10
        editItemButton.layer.masksToBounds = true
        editItemButton.layer.borderColor = UIColor.black.cgColor
        editItemButton.layer.borderWidth = 0.5
        editItemButton.layer.shadowColor = UIColor.black.cgColor
        editItemButton.layer.shadowOffset = CGSize.zero
        editItemButton.layer.shadowRadius = 5.0
        editItemButton.layer.shadowOpacity = 0.5
        editItemButton.clipsToBounds = false
        
        removeButton.layer.cornerRadius = 10
        removeButton.layer.masksToBounds = true
        removeButton.layer.borderColor = UIColor.black.cgColor
        removeButton.layer.borderWidth = 0.5
        removeButton.layer.shadowColor = UIColor.black.cgColor
        removeButton.layer.shadowOffset = CGSize.zero
        removeButton.layer.shadowRadius = 5.0
        removeButton.layer.shadowOpacity = 0.5
        removeButton.clipsToBounds = false
        
        backButton.layer.cornerRadius = 10
        backButton.layer.masksToBounds = true
        backButton.layer.borderColor = UIColor.black.cgColor
        backButton.layer.borderWidth = 0.5
        backButton.layer.shadowColor = UIColor.black.cgColor
        backButton.layer.shadowOffset = CGSize.zero
        backButton.layer.shadowRadius = 5.0
        backButton.layer.shadowOpacity = 0.5
        backButton.clipsToBounds = false
        
        segControl.layer.borderColor = UIColor.black.cgColor
        segControl.layer.borderWidth = 1.0
        
        let strokeTextAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.strokeColor : UIColor.black,
            NSAttributedStringKey.foregroundColor : UIColor.white,
            NSAttributedStringKey.strokeWidth : -2.0,
            ]
        
        rewardsSettingsHeader.attributedText = NSAttributedString(string: "Rewards Settings", attributes: strokeTextAttributes)

    }
    
    //
    // UIAlert functions
    //
    
    func createSimpleAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //
    // Functions used to set up text fields in alerts
    //
    
    //
    // New user/item/promo
    //
    
    func phoneNumTFSetup(textfield: UITextField!) {
        newPhoneNumTF = textfield
        newPhoneNumTF?.keyboardType = UIKeyboardType.phonePad
        newPhoneNumTF?.placeholder = "Phone Number"
    }
        
    func nameTFSetup(textfield: UITextField!) {
        newNameTF = textfield
        newNameTF?.placeholder = "Name"
    }
    
    func pointsTFSetup(textfield: UITextField!) {
        newPointsTF = textfield
        newPointsTF?.keyboardType = UIKeyboardType.phonePad
        newPointsTF?.placeholder = "Points"
    }
    
    //
    // Edit Something
    //
    
    func editNameSetup(textfield: UITextField!) {
        
        editNameTF = textfield

        if editWhat == 0 {
            editNameTF?.text = self.rewardsitemslist[self.pickerView.selectedRow(inComponent: 0)].getName()
        } else if editWhat == 1 {
            editNameTF?.text = self.rewardsuserslist[self.pickerView.selectedRow(inComponent: 0)].getName()
        } else {
            //editNameTF?.text = self.rewardspromoslist[self.pickerView.selectedRow(inComponent: 0)].getName()
            editNameTF?.text = "not done"
        }
    }
    
    func editPointsSetup(textfield: UITextField!) {
        editPointsTF = textfield

        if editWhat == 0 {
            editPointsTF?.text = self.rewardsitemslist[self.pickerView.selectedRow(inComponent: 0)].getPoints().description
            editPointsTF?.keyboardType = UIKeyboardType.numberPad
            
        } else if editWhat == 1 {
            editPointsTF?.text = self.rewardsuserslist[self.pickerView.selectedRow(inComponent: 0)].getPoints().description
            editPointsTF?.keyboardType = UIKeyboardType.numberPad
        } else {
            //editPointsTF?.text = self.rewardsitemslist[self.pickerView.selectedRow(inComponent: 0)].getPoints().description
            editPointsTF?.keyboardType = UIKeyboardType.numberPad
            editPointsTF?.text = "not done"
        }
    }
    
    func editPhoneNumSetup(textfield: UITextField!) {
        editPhoneNumTF = textfield
        editPhoneNumTF?.text = self.rewardsuserslist[self.pickerView.selectedRow(inComponent: 0)].getPhoneNum()
        editPhoneNumTF?.keyboardType = UIKeyboardType.numberPad
    }
    
    

    
    //
    // Creates a UIAlert that has text fields to remove something (i.e. remove user, item, or promo)
    //
    // 0 = item, 1 = user, 2 = promo
    //
    
    func createAlertRemoveSomething(title: String,option:Int) {
        
        if option == 0 {
            //
            // Remove an item
            //
            
            let id = self.rewardsitemslist[self.pickerView.selectedRow(inComponent: 0)].getID()
            let name = self.rewardsitemslist[self.pickerView.selectedRow(inComponent: 0)].getName()
            
            let alert = UIAlertController(title: title, message: "Really remove '" + name + "'?", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Remove", style: .default, handler: { (action: UIAlertAction) -> Void in
                
                //
                // Checks for arbitrary amount of spaces
                //

                self.ref.child("rewards").child("items").child(id).removeValue()
                
                self.getRewardsItems()
                
                self.createSimpleAlert(title: "Success!", message: "'" + name + "' deleted!")
                
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(cancel)
            
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
            
        } else if option == 1 {
            //
            // Remove a user
            //
            
            let id = self.rewardsuserslist[self.pickerView.selectedRow(inComponent: 0)].getID()
            let user = self.rewardsuserslist[self.pickerView.selectedRow(inComponent: 0)].getName()
            
            let alert = UIAlertController(title: title, message: "Really remove '" + user + "'?", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Remove", style: .default, handler: { (action: UIAlertAction) -> Void in
                
                //
                // Checks for arbitrary amount of spaces
                //
                
                self.ref.child("rewards").child("users").child(id).removeValue()
                
                self.getRewardsUsers()
                
                self.createSimpleAlert(title: "Success!", message: "'" + user + "' deleted!")
                
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(cancel)
            
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
        } else {
            //
            // Remove a promo
            //
        }

        
    }

    
    //
    // Creates an alert to input info about a new user
    //
    
    func createAlertAddUser(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nameTFSetup)
        alert.addTextField(configurationHandler: phoneNumTFSetup)

        
        let ok = UIAlertAction(title: "Add", style: .default, handler: { (action: UIAlertAction) -> Void in
            
            guard var name = self.newNameTF?.text!, let phoneNum = self.newPhoneNumTF?.text else {
                self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                return
            }
            
            //
            // Checks for arbitrary amount of spaces
            //
            
            let tempName = name.trimmingCharacters(in: .whitespaces)
            let tempPhoneNum = self.extractPhoneNumberFromString(phoneNumber: phoneNum)

            if tempName != "" && tempPhoneNum != "Invalid phone number" {
                let idRef = self.ref.child("rewards").child("users").childByAutoId()
                let id = idRef.key
                
                name = name.capitalizeFirstLetter()
                
                let userInfo = [
                    "name":          name,
                    "points":        0,
                    "phoneNum":      phoneNum,
                    "id":            id
                    ] as [String : Any]
                
                
                
                self.ref.child("rewards").child("users").child(id).setValue(userInfo)
                
                self.getRewardsUsers()
            } else {
                self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
        
        
    } //end createalert
    
    //
    // Creates a UIAlert that has text fields to add a new item
    //
    
    func createAlertAddItem(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nameTFSetup)
        alert.addTextField(configurationHandler: pointsTFSetup)

        let ok = UIAlertAction(title: "Add", style: .default, handler: { (action: UIAlertAction) -> Void in
            
            guard var name = self.newNameTF?.text!, let pointsString = self.newPointsTF?.text else {
                self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                return
            }
            
            //
            // Checks for arbitrary amount of spaces
            //
            
            let tempName = name.trimmingCharacters(in: .whitespaces)
            let points = Int(pointsString)
            
            
            if tempName != "" {
                
                let idRef = self.ref.child("rewards").child("items").childByAutoId()
                let id = idRef.key
                
                name = name.capitalizeFirstLetter()
                
                let pointsInfo = [
                    "name":          name,
                    "points":      points!,
                    "id":            id
                    ] as [String : Any]
                
                self.ref.child("rewards").child("items").child(id).setValue(pointsInfo)
                
                self.getRewardsItems()

            } else {
                self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
            }
            
            
            
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //
    // Take string and modify it with chars to make it
    // into a more readable string. Returns invalid if
    // conditions aren't met.
    //
    
    func extractPhoneNumberFromString(phoneNumber: String) -> String {
        
        let length = phoneNumber.count
        let hasLeadingOne = phoneNumber.hasPrefix("+11")
        let hasLeading = phoneNumber.hasPrefix("+1")
        
        
        guard (length == 13 && hasLeadingOne) || (length == 12 && hasLeading) else {
            return "Invalid phone number"
        }
        
        
        //
        // 12 digits == +1 630 479 1928
        //
        // 13 digits == +1 1 630 479 1928
        //
        
        var areaCode:String.SubSequence
        var newAreaCode = ""
        
        if length == 12 {
            areaCode = phoneNumber.prefix(5)
            areaCode = areaCode.suffix(3)
            newAreaCode = "(" + areaCode + ")"
        } else if length == 13 && hasLeadingOne {
            areaCode = phoneNumber.prefix(6)
            areaCode = areaCode.suffix(3)
            newAreaCode = "(" + areaCode.suffix(3) + ")"
        }
        
        let coreNumbers = phoneNumber.suffix(7)
        
        let startCoreNumbers = coreNumbers.prefix(3)
        let endCoreNumbers   = coreNumbers.suffix(4)
        
        let finalNumber = newAreaCode + "-" + startCoreNumbers + "-" + endCoreNumbers
        
        return finalNumber
    }
    
    //
    // Grabs all rewards users from FirebaseDatabase
    //
    
    func getRewardsUsers() {
        
        self.rewardsuserslist.removeAll()
        
        ref.child("rewards").child("users").observe(.childAdded, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                let reward = newRewardUser()
                
                
                reward.setName(NAME: dictionary["name"] as! String)
                reward.setPhoneNum(NUM:dictionary["phoneNum"] as! String)
                reward.setPoints(POINTS: dictionary["points"] as! Int)
                reward.setID(ID: dictionary["id"] as! String)
                
                var beenAdded = false
                
                for r in self.rewardsuserslist {
                    if r.getID() == reward.getID() {
                        beenAdded = true
                    }
                }
                
                if (!beenAdded) {
                    self.rewardsuserslist.append(reward)
                }
                
            } //end dictionary
            
            //
            // Reload picker view
            //
            
            DispatchQueue.main.async {
                self.pickerView.reloadAllComponents()
            }
        })
        
        //
        // Reload picker view
        //
        
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
        }

        
    } //end getRewardsUsers
    
    //
    // Grabs all rewards items from FirebaseDatabase
    //
    
    func getRewardsItems() {
        
        self.rewardsitemslist.removeAll()
        
        ref.child("rewards").child("items").observe(.childAdded, with: { (snapshot) in

            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                let item = newRewardItem()
                
                item.setName(NAME: dictionary["name"] as! String)
                item.setPoints(POINTS: dictionary["points"] as! Int)
                item.setID(ID: dictionary["id"] as! String)
                
                var beenAdded = false
                
                for i in self.rewardsitemslist {
                    if i.getID() == item.getID() {
                        beenAdded = true
                    }
                }
                
                if (!beenAdded) {
                    self.rewardsitemslist.append(item)
                }
            } //end dictionary
            
            //
            // Reload picker view
            //
            
            DispatchQueue.main.async {
                self.pickerView.reloadAllComponents()
            }  
        })
        
        //
        // Reload picker view
        //
        
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
        }
    } //end getrewardsitems
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //
        // Give view a design then display items first
        //
        
        initView()
        
        DisplayItemsView()

        //
        // Init database reference
        //
        
        ref = Database.database().reference().child("users").child(uid)

        pickerView.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
