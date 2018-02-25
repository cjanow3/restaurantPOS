//
//  TimeClockViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 10/8/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TimeClockViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var timeclockHeader: UILabel!
    @IBOutlet weak var newEmployeeButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var mainMenuButton: UIButton!
    
    var ref:DatabaseReference!
    var uid:String = ""

    var userID:String?
    var newNameTF: UITextField?
    var newEmailTF: UITextField?
    var newPhoneNumTF: UITextField?

    var employeelist = [newEmployee]()
    
    var editIndex = 0
    var currentlyEditing = false
    
    //
    // Table view and functions
    //
    
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeelist.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeClockCell", for: indexPath) as! EmployeeTableViewCell
        
        let isIndexValid = self.employeelist.indices.contains(indexPath.row)
        
        if (isIndexValid) {
            cell.employeeName.text = employeelist[indexPath.row].getName()
            
            return cell
        } else {
            cell.employeeName.text = "nil"
            
            return cell
        }
    }
    

    //
    // Grabs all employees from FirebaseDatabase
    //
    
    func getEmployees() {
        
        self.employeelist.removeAll()
        
        ref.child("employees").observe(.childAdded, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                let employee = newEmployee()
                
                
                employee.setName(NAME: dictionary["name"] as! String)
                employee.setEmail(EMAIL: dictionary["email"] as! String)
                employee.setPhoneNum(PHONENUM:dictionary["phoneNum"] as! String)
                employee.setHoursWorked(HOURS: dictionary["hours"] as! Double)
                employee.setID(ID: dictionary["id"] as! String)
                employee.setClockedIn(ONTHECLOCK: dictionary["clockedin"] as! Bool)
                employee.setStartTime(TIME: dictionary["starttime"] as! String)
                employee.setStopTime(TIME: dictionary["stoptime"] as! String)

                
                var beenAdded = false
                
                for e in self.employeelist {
                    if e.getID() == employee.getID() {
                        beenAdded = true
                    }
                }
                
                if (!beenAdded) {
                    self.employeelist.append(employee)
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
        
    } //end getemployees
    
    //
    // Resets pay period with UI Alert if password is correct
    //
    
    @IBAction func resetPayPeriod(_ sender: Any) {
        createAlertResetPay(title: "Reset Pay", message: "")
    }
    
    
    //
    // Adds new employee with UI Alert
    //
    
    @IBAction func addNewEmployee(_ sender: Any) {
        currentlyEditing = false
        createAlertAddEmployee(title: "Enter Info", message: "")
    }
    
    func createAlertResetPay(title: String, message: String)
    {
        //
        //create alert controller
        //
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        //
        //create cancel action
        //
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //
        //create ok action
        //
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) -> Void in print("OK")
            
            
            let inputPassword = alert.textFields?[0].text
            
            if (inputPassword != "0000") {
                
                self.createSimpleAlert(title: "Incorrect", message: "Try again.")
                
            }
                
            else {
                self.zeroOutPayData()
                self.createSimpleAlert(title: "Confirmed", message: "The hours have been reset.")
            }
            
        })
        
        alert.addAction(cancel)
        
        alert.addAction(ok)
        
        alert.addTextField(configurationHandler: { (textField: UITextField) -> Void in textField.placeholder = "Password"})
        
        alert.textFields?[0].isSecureTextEntry = true

        self.present(alert, animated: true, completion: nil)
        
    } //end createalert
    
    //
    // Create ui alert with header and message
    //
    
    func createSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func createAlertAddEmployee(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nameTFSetup)
        alert.addTextField(configurationHandler: emailTFSetup)
        alert.addTextField(configurationHandler: phoneNumTFSetup)

        let ok = UIAlertAction(title: "Add", style: .default, handler: { (action: UIAlertAction) -> Void in print("OK")
            
            guard let name = self.newNameTF?.text!, let email = self.newEmailTF?.text!, let phoneNum = self.newPhoneNumTF?.text else {
                self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                return
            }
            
            //
            // Checks for arbitrary amount of spaces
            //
            
            let tempName = name.trimmingCharacters(in: .whitespaces)
            let tempPhoneNum = self.extractPhoneNumberFromString(phoneNumber: phoneNum)
            
            if tempName != "" && tempPhoneNum != "Invalid phone number" {
                let idRef = self.ref.child("employees").childByAutoId()
                let id = idRef.key
                
                let employeeInfo = [
                    "name":          name,
                    "email":         email,
                    "hours":         0.0,
                    "phoneNum":      phoneNum,
                    "id":            id,
                    "clockedin":     false,
                    "starttime":     "00:00",
                    "stoptime":      "00:00"
                    ] as [String : Any]
                
                self.ref.child("employees").child(id).setValue(employeeInfo)
                
                self.getEmployees()
            } else {
                self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
            }

        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
        
        
    } //end createalert
    
    func nameTFSetup(textfield: UITextField!) {
        newNameTF = textfield

        if currentlyEditing {
            newNameTF?.text! = employeelist[editIndex].getName()
        } else {
            newNameTF?.placeholder = "Name"
        }
        
    }
    
    func phoneNumTFSetup(textfield: UITextField!) {
        newPhoneNumTF = textfield
        newPhoneNumTF?.keyboardType = UIKeyboardType.phonePad
        
        if currentlyEditing {
            newPhoneNumTF?.text! = employeelist[editIndex].getPhoneNum()
        } else {
            newPhoneNumTF?.placeholder = "Phone Number"
        }
        
    }
    
    func emailTFSetup(textfield: UITextField!) {
        newEmailTF = textfield
        newEmailTF?.keyboardType = UIKeyboardType.emailAddress

        if currentlyEditing {
            newEmailTF?.text! = employeelist[editIndex].getEmail()
        } else {
            newEmailTF?.placeholder = "Email"
        }
        
        
    }
    
    //
    // Zeros out all hours worked for employees in FirebaseDatabase
    //
    
    func zeroOutPayData() {
        
        
        for e in self.employeelist {
            e.setHoursWorked(HOURS: 0.0)
        }
        

        ref.child("employees").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                let id = dictionary["id"] as? String
                
                let employeeInfo = [
                    "hours":  0.0,
                    ] as [String : Any]
                
                self.ref.child("employees").child(id!).updateChildValues(employeeInfo)
                
            }
        })
        
        
    } //end zero out pay data
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "empseg") {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let destVC = segue.destination as! EmployeeCellViewController
                destVC.uid = uid

                for e in self.employeelist {
                    destVC.employeelist.append(e)
                }
                
                destVC.employeeIndex = indexPath.row
                
            } // end indexPath -- should not ever be null -- however gets information for selected cell
        }
    }
    
    func initView() {
        newEmployeeButton.layer.cornerRadius = 10
        newEmployeeButton.layer.masksToBounds = true
        newEmployeeButton.layer.borderColor = UIColor.black.cgColor
        newEmployeeButton.layer.borderWidth = 0.5
        newEmployeeButton.layer.shadowColor = UIColor.black.cgColor
        newEmployeeButton.layer.shadowOffset = CGSize.zero
        newEmployeeButton.layer.shadowRadius = 5.0
        newEmployeeButton.layer.shadowOpacity = 0.5
        newEmployeeButton.clipsToBounds = false
        
        resetButton.layer.cornerRadius = 10
        resetButton.layer.masksToBounds = true
        resetButton.layer.borderColor = UIColor.black.cgColor
        resetButton.layer.borderWidth = 0.5
        resetButton.layer.shadowColor = UIColor.black.cgColor
        resetButton.layer.shadowOffset = CGSize.zero
        resetButton.layer.shadowRadius = 5.0
        resetButton.layer.shadowOpacity = 0.5
        resetButton.clipsToBounds = false
        
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
        
        timeclockHeader.attributedText = NSAttributedString(string: "Time Clock", attributes: strokeTextAttributes)
        
    }
    
    @IBAction func unwindToTimeClock(segue: UIStoryboardSegue) {
        getEmployees()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        ref = Database.database().reference().child("users").child(uid)

        
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            
            //
            // Create alert to edit that contact
            //
            
            self.editIndex = editActionsForRowAt.row
            self.currentlyEditing = true
            self.createAlertEditEmployee(Title: "Edit Employee")
            
        }
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            
            //
            // Delete contact and refresh
            //
            
            let tempEmployeeName = self.employeelist[editActionsForRowAt.row].getName()
            let alert = UIAlertController(title: "Confirm Deletion", message: "Really delete '" + tempEmployeeName + "'?", preferredStyle: .alert)
            let vc = UIViewController()
            vc.preferredContentSize = CGSize(width: 250,height: 30)

            alert.setValue(vc, forKey: "contentViewController")
            
            let ok = UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction) -> Void in
                
                let id = self.employeelist[editActionsForRowAt.row].getID()
                self.ref.child("employees").child(id).removeValue()
                self.getEmployees()
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
    // Creates a UIAlert that has text fields to edit a contact
    //
    
    func createAlertEditEmployee(Title:String) {
        
        let alert = UIAlertController(title: Title, message: "", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nameTFSetup)
        alert.addTextField(configurationHandler: emailTFSetup)
        alert.addTextField(configurationHandler: phoneNumTFSetup)
        
        let ok = UIAlertAction(title: "Save", style: .default, handler: { (action: UIAlertAction) -> Void in
            
            guard let name = self.newNameTF?.text!, let phoneNum = self.newPhoneNumTF?.text, let email = self.newEmailTF?.text!  else {
                self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                return
            }

            
            //
            // Checks for arbitrary amount of spaces
            //
            
            let tempName = name.trimmingCharacters(in: .whitespaces)
            let tempPhoneNumber = self.extractPhoneNumberFromString(phoneNumber: phoneNum)
            
            if tempName != "" && tempPhoneNumber != "Invalid phone number" {
                let tempID = self.employeelist[self.editIndex].getID()
                let tempHours = self.employeelist[self.editIndex].getHoursWorked()
                
                let employeeInfo = [
                    "name":          name,
                    "email":         email,
                    "phoneNum":      phoneNum,
                    "hours":         tempHours,
                    "id":            tempID,
                    "clockedin":     false,
                    "starttime":     "00:00",
                    "stoptime":      "00:00"
                    ] as [String : Any]
                
                self.ref.child("employees").child(tempID).setValue(employeeInfo)
                
                self.getEmployees()
                
                self.createSimpleAlert(title: "Success!", message: name + " has been successfully updated.")

                
            } else {
                self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
            }
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
}
