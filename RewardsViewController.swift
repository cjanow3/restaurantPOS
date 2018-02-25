//
//  RewardsViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 11/12/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class RewardsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource,UIActionSheetDelegate {
   
    @IBOutlet weak var newRewardUserButton: UIButton!
    @IBOutlet weak var mainMenuButton: UIButton!
    
    @IBOutlet weak var rewardsHeader: UILabel!
    
    var ref:DatabaseReference!
    var uid:String = ""

    var showPointPicker = true
    
    //
    // Initializing rewards lists
    //
    
    var rewardsuserslist = [newRewardUser]()
    var rewardsitemslist = [newRewardItem]()
    
    var nameTF: UITextField?
    var phoneNumTF: UITextField?
    var verificationCodeTF: UITextField?
    
    var points = [Int]()
    var newPoints = 0
    
    var pointsWorth = 0
    var newItem = ""
    //
    // Initialize points array with values 1 ... 100
    //
    
    func initiatePointsArray() {
        var localindex = 1
        
        while localindex < 101 {
            self.points.append(localindex)
            localindex += 1
        }
    }
    
    //
    // Action sheet for redeem/add
    //
    
    func showActionSheet(index: Int) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let addPoints = UIAlertAction(title: "Add Points", style: .default) { action in
            self.showPointPicker = true
            self.addPointsViaAlert(index: index)
            print("add points")
        }
        
        let redeemItem = UIAlertAction(title: "Redeem Item", style: .default) { action in
            self.showPointPicker = false
            self.redeemItemViaAlert(index: index)
            print("redeem item")

        }
        
        actionSheet.addAction(addPoints)
        actionSheet.addAction(redeemItem)
        actionSheet.addAction(cancel)
        
        actionSheet.popoverPresentationController?.sourceView = self.view
        actionSheet.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        
        present(actionSheet,animated: true,completion: nil)
    }
    

    //
    // Settings image view
    //
    
    @IBOutlet weak var image: UIImageView!
    
    //
    // Picker view functions
    //
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if showPointPicker {
            return points.count
        } else {
            return rewardsitemslist.count
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if showPointPicker {
            newPoints = points[row]
            return points[row].description
        } else {
            newItem = rewardsitemslist[row].getName()
            pointsWorth = rewardsitemslist[row].getPoints()
            return rewardsitemslist[row].getName() + " - " + rewardsitemslist[row].getPoints().description
        }
    }


    //
    // TableView functions
    //
    
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rewardsuserslist.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        self.showActionSheet(index: indexPath.row)

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "rewardscell", for: indexPath) as! RewardsTableViewCell
        
        let isIndexValid = self.rewardsuserslist.indices.contains(indexPath.row)
        
        if (isIndexValid) {
            cell.nameLabel.text = rewardsuserslist[indexPath.row].getName()
            
            cell.pointsLabel.text = rewardsuserslist[indexPath.row].getPoints().description
            
            let phoneNum = rewardsuserslist[indexPath.row].getPhoneNum()
            let numWithoutLeading = String(phoneNum.dropFirst(2))
            let displayNum = extractPhoneNumberFromString(phoneNumber: numWithoutLeading)
            cell.phoneNumberLabel.text = displayNum

            return cell
            
        } else {
            cell.nameLabel.text = "nil"
            cell.phoneNumberLabel.text = "nil"
            cell.pointsLabel.text = "nil"
  
            return cell
        }
    }
    

    
    //
    // Button that adds new user via UIAlert
    //
    
    @IBAction func addUser(_ sender: Any) {
        createAlertAddUser(title: "Enter Info", message: "")
    }
    
    //
    // MARK: Alert functions
    //
    // Many alert functions used here used to determine
    // if the user wants to add points or redeem something,
    //
    // Add Points - Go to another alert with picker view
    // that has values 1 ... 100 with confirmation alert
    // after points are added
    //
    // Redeem Item - Go to another alert with picker view
    // that has items that are redeemable with confirmation
    // alert, then if yes is clicked, go to another alert
    // that states if points were removed (i.e. success)
    //
    
    
    //
    // Creates an alert to input info about a new user
    //
    
    func createAlertAddUser(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nameTFSetup)
        alert.addTextField(configurationHandler: phoneNumTFSetup)
        
        
        let ok = UIAlertAction(title: "Add", style: .default, handler: { (action: UIAlertAction) -> Void in
            
            guard let name = self.nameTF?.text!, let phoneNum = self.phoneNumTF?.text else {
                self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                return
            }
            
            //
            // Checks for arbitrary amount of spaces
            //
            
            let tempName = name.trimmingCharacters(in: .whitespaces)
            
            if tempName != "" {
                
                //
                // Get number into proper format
                //
                
                
                let displayNum = self.extractPhoneNumberFromString(phoneNumber: phoneNum)
                
                if displayNum == "Invalid phone number" {
                    
                    self.createSimpleAlert(title: "Invalid Phone Number", message: "Please re-enter the phone number")

                } else {
                    
                    //
                    // Create actual number message is sent to
                    //
                    
                    var finalNumber = phoneNum
                    if finalNumber.hasPrefix("1") {
                        finalNumber = "+" + finalNumber
                    } else {
                        finalNumber = "+1" + finalNumber
                    }
                    
                    let idRef = self.ref.child("rewards").child("users").childByAutoId()
                    let id = idRef.key

                    //
                    // Save real number to temp user
                    //
                    
                    let tempUser = newRewardUser(NAME: name, PHONENUM: finalNumber, POINTS: 0, ID: id)
                    
                    self.createAlertSendMessage(user: tempUser, displayNum: displayNum)
                }
                
                
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
        
        
    } //end createalert
    
    //
    // Creates an alert to input info about a new user
    //
    
    func createAlertSendMessage(user: newRewardUser, displayNum: String) {
        
        let alert = UIAlertController(title: "Is this correct?", message: "Send verification text message to: " + displayNum, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction) -> Void in
            let sendMessageToNumber = user.getPhoneNum()
            
            PhoneAuthProvider.provider().verifyPhoneNumber(sendMessageToNumber, uiDelegate: nil) { (verificationID, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                //
                // Sign in using the verificationID and the code sent to the user
                //
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")

                self.createAlertVerifyCode(user: user)

            }
        })
        
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
        
        
    } //end createalert
    
    func createAlertVerifyCode(user: newRewardUser) {
        let alert = UIAlertController(title: "Enter Code", message: "" , preferredStyle: .alert)
        
        let tempuser = user
        alert.addTextField(configurationHandler: phoneNumTFSetup)

        let ok = UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction) -> Void in
            guard let verificationCode = self.phoneNumTF?.text! else {
                print("error")
                return
            }
            
            let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")

            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID!,
                verificationCode: verificationCode)
            
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                let userInfo = [
                    "name":          tempuser.getName(),
                    "points":        0,
                    "phoneNum":      tempuser.getPhoneNum(),
                    "id":            tempuser.getID()
                    ] as [String : Any]
                
                self.ref.child("rewards").child("users").child(tempuser.getID()).setValue(userInfo)
                
                self.getRewardsUsers()
                
            }
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
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
    
    //
    // Creates alert that has picker view and
    // determines how many pts to add to a user
    //
    
    func addPointsViaAlert(index:Int) {
        
        //
        // Creating picker view and alert
        //
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 250)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        vc.view.addSubview(pickerView)
        
        let alert = UIAlertController(title: "Add Points", message: "", preferredStyle: .alert)
        alert.setValue(vc, forKey: "contentViewController")
        
        //
        // OK action
        //
        
        let ok = UIAlertAction(title: "Add", style: .default, handler: { (action: UIAlertAction) -> Void in
            
            self.newPoints = self.points[pickerView.selectedRow(inComponent: 0)]

            self.confirmAddPoints(index: index)
            
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(ok)
        self.present(alert, animated: true)
        
        
    } //end addpointsviaalert
    
    //
    // Confirmation alert for adding points
    //
    
    func confirmAddPoints(index:Int) {
        var message = ""
        var title = ""
        
        if self.newPoints == 1 {
            message = "Really add " + self.newPoints.description + " point?"
            title = "Confirm point"
        } else {
            message = "Really add " + self.newPoints.description + " points?"
            title = "Confirm points"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Add", style: .default, handler: { (action: UIAlertAction) -> Void in
            
            let prevPoints = self.rewardsuserslist[index].getPoints()
            let tempID = self.rewardsuserslist[index].getID()
            
            
            self.rewardsuserslist[index].addToPoints(POINTS: self.newPoints)
            let tempNewPoints = self.rewardsuserslist[index].getPoints()
            
            let employeeInfo = [
                "points":  tempNewPoints,
                ] as [String : Any]
            
            self.ref.child("rewards").child("users").child(tempID).updateChildValues(employeeInfo)
            self.createSimpleAlert(title: "Points updated!", message: "Points updated from " + prevPoints.description + " to " + tempNewPoints.description )
            
            self.getRewardsUsers()
            
            self.newPoints = 0
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //
    // Confirmation alert for redeeming an item
    //
    
    func confirmRedeemItem(index:Int) {
        
        let alert = UIAlertController(title: "Confirm item", message: "Really redeem '" + self.newItem + "' for " + pointsWorth.description + " points?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Add", style: .default, handler: { (action: UIAlertAction) -> Void in
            
            let differenceOfPoints = self.rewardsuserslist[index].getPoints() - self.pointsWorth

            //
            // Determine if user has a sufficient
            // amount of points to redeem item chosen
            //
            
            if differenceOfPoints < 0 {
                
                let morePoints = -1 * differenceOfPoints
                
                self.createSimpleAlert(title: "Insufficient Points", message: "You only need " + morePoints.description + " more points to redeem this item!")
                
            } else {
                
                let tempID = self.rewardsuserslist[index].getID()
                
                let userInfo = [
                    "points":  differenceOfPoints,
                    ] as [String : Any]
                
                self.ref.child("rewards").child("users").child(tempID).updateChildValues(userInfo)
                self.createSimpleAlert(title: "Item Redeemed!", message: "Enjoy your free " + self.newItem + "!")
                
                self.getRewardsUsers()
            }
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //
    // Creates alert that has picker view and
    // determines which item to redeem
    //
    
    func redeemItemViaAlert(index:Int) {
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 250)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        vc.view.addSubview(pickerView)
        
        let pointBalance = self.rewardsuserslist[index].getPoints()
        
        let alert = UIAlertController(title: "Redeem Item", message: "Points available: " + pointBalance.description, preferredStyle: .alert)
        alert.setValue(vc, forKey: "contentViewController")
        let ok = UIAlertAction(title: "Redeem", style: .default, handler: { (action: UIAlertAction) -> Void in

            self.confirmRedeemItem(index: index)
  
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(ok)
        self.present(alert, animated: true)
        
        
    }
    
    //
    // Create ui alert with header and message
    //
    
    func createSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func codeTFSetup(textfield: UITextField!) {
        verificationCodeTF = textfield
    }
    
    func nameTFSetup(textfield: UITextField!) {
        nameTF = textfield
        nameTF?.placeholder = "Name"
    }
    
    func phoneNumTFSetup(textfield: UITextField!) {
        phoneNumTF = textfield
        phoneNumTF?.keyboardType = UIKeyboardType.phonePad
        phoneNumTF?.placeholder = "Phone Number"
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
                
                //
                // Refresh Tableview
                //
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } //end dictionary
            
        })
        
        //
        // Refresh Tableview
        //
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    } //end getRewardsUsers
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "settingseg") {
            
            let destVC = segue.destination as! RewardSettingsViewController
            destVC.uid = uid

            for u in self.rewardsuserslist {
                destVC.rewardsuserslist.append(u)
            }
            for i in self.rewardsitemslist {
                destVC.rewardsitemslist.append(i)
            }
            
        }
    }
    
    
    @IBAction func unwindToRewardsView(segue: UIStoryboardSegue) {
        
        getRewardsUsers()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        performSegue(withIdentifier: "settingseg", sender: nil)
        
    }
    
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
            
        })
    } //end getrewardsitems
    
    func initView() {
        newRewardUserButton.layer.cornerRadius = 10
        newRewardUserButton.layer.masksToBounds = true
        newRewardUserButton.layer.borderColor = UIColor.black.cgColor
        newRewardUserButton.layer.borderWidth = 0.5
        newRewardUserButton.layer.shadowColor = UIColor.black.cgColor
        newRewardUserButton.layer.shadowOffset = CGSize.zero
        newRewardUserButton.layer.shadowRadius = 5.0
        newRewardUserButton.layer.shadowOpacity = 0.5
        newRewardUserButton.clipsToBounds = false
        
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
        
        rewardsHeader.attributedText = NSAttributedString(string: "Rewards", attributes: strokeTextAttributes)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // Initialize reference to database
        //
        
        ref = Database.database().reference().child("users").child(uid)

        initView()
        //
        // Create points array for adding points to user's account
        //
        
        initiatePointsArray()

        //
        // Initialize tap gesture for settings image
        //
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tapGestureRecognizer)
        
        //
        // Pre-load other rewards items for settings view
        //
        
        getRewardsItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
