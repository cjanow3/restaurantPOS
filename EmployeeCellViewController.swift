//
//  EmployeeCellViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 11/7/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit
import FirebaseDatabase
//, UIPickerViewDelegate, UIPickerViewDataSource

class EmployeeCellViewController: UIViewController {
    
    var newHoursWorked = 0
    var newMinutesWorked = 0
    
    @IBOutlet weak var clockInButton: UIButton!
    @IBOutlet weak var mainMenuButton: UIButton!
    
    var ref:DatabaseReference!
    var uid:String = ""

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumLabel: UILabel!
    @IBOutlet weak var hoursWorkedLabel: UILabel!
    
    var name:String?
    var email:String?
    var phoneNum:String?
    var hoursWorked:Double?
    
    var employeelist = [newEmployee]()
    var employeeIndex:Int?
    var employeeInQuestion = newEmployee()
    
    func initLabels(employee:newEmployee) {
        nameLabel.text = employee.getName()
        emailLabel.text = employee.getEmail()
        let displayNum = extractPhoneNumberFromString(phoneNumber: employee.getPhoneNum())
        phoneNumLabel.text = displayNum
        hoursWorkedLabel.text = employee.getHoursWorked().description
        
        if employee.checkIfClockedIn() {
            //
            // Employee is currently clocked in
            //
            
            clockInButton.setTitle("Out", for: .normal)
            
        } else {
            //
            // Employee is not currently clocked in
            //
            clockInButton.setTitle("In", for: .normal)

        }
        
        
    }
    
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //
    // Choose time for shift start with a picker view in an alert
    //
    
    func clockInViaAlert() {
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 250)
        let pickerView = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        pickerView.datePickerMode = .time
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "US_en")
        dateFormatter.dateFormat = "HH:mm"

        vc.view.addSubview(pickerView)
        
        let alert = UIAlertController(title: "Clock In", message: "", preferredStyle: .alert)
        alert.setValue(vc, forKey: "contentViewController")
        let ok = UIAlertAction(title: "Done", style: .default, handler: { (action: UIAlertAction) -> Void in
            

            
            let startTime = dateFormatter.string(from: pickerView.date)

            self.confirmClockInTime(startTime: startTime)
            
            //
            // Automatically unwind here to main time clock view
            //
            
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(ok)
        self.present(alert, animated: true)

        
    }
    
    //
    // Confirmation alert for clocking in time
    //
    
    func confirmClockInTime(startTime:String) {
        let message = "Really clock in at " + startTime + "?"

        let title = "Confirm time"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Add", style: .default, handler: { (action: UIAlertAction) -> Void in
            
            self.employeeInQuestion.setStartTime(TIME: startTime)
            self.employeeInQuestion.setClockedIn(ONTHECLOCK: true)
            self.initLabels(employee: self.employeeInQuestion)
            
            let clockInInfo = [
                "clockedin": true,
                "starttime": startTime
                ] as [String : Any]
            
            let id = self.employeeInQuestion.getID()
            self.ref.child("employees").child(id).updateChildValues(clockInInfo)
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //
    // Choose time for shift end with a picker view in an alert
    //
    
    func clockOutViaAlert() {
       
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 250)
        let pickerView = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        pickerView.datePickerMode = .time
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "US_en")
        dateFormatter.dateFormat = "HH:mm"
        
        vc.view.addSubview(pickerView)
        
        let alert = UIAlertController(title: "Clock Out", message: "", preferredStyle: .alert)
        alert.setValue(vc, forKey: "contentViewController")
        let ok = UIAlertAction(title: "Done", style: .default, handler: { (action: UIAlertAction) -> Void in
            
            
            let stopTime = dateFormatter.string(from: pickerView.date)
            
            self.confirmClockOutTime(stopTime: stopTime)
            
            //
            // Automatically unwind here to main time clock view
            //
            
            
            
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    //
    // Confirmation alert for clocking out time
    //
    
    func confirmClockOutTime(stopTime:String) {
        let message = "Really clock out at " + stopTime + "?"
        
        let title = "Confirm time"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Add", style: .default, handler: { (action: UIAlertAction) -> Void in
            
            self.employeeInQuestion.setStopTime(TIME: stopTime)
            self.employeeInQuestion.setClockedIn(ONTHECLOCK: false)
            
            var hoursWorked = self.employeeInQuestion.getHoursFromTimes()
            hoursWorked = Double(round(100 * hoursWorked) / 100)
            self.employeeInQuestion.addToHoursWorked(shiftHours: hoursWorked)
            
            let newHours = self.employeeInQuestion.getHoursWorked()
            let tempID = self.employeeInQuestion.getID()
            self.initLabels(employee: self.employeeInQuestion)
            
            let employeeInfo = [
                "hours":     newHours,
                "stoptime":  stopTime,
                "clockedin": false
                ] as [String : Any]
            
            
            self.ref.child("employees").child(tempID).updateChildValues(employeeInfo)
            
            self.createAlert(title: "Hours Worked", message: "Clocked in for a total of " + hoursWorked.description + " hours.")
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }


    @IBAction func addHours(_ sender: Any) {
        
        if self.employeeInQuestion.checkIfClockedIn() {
            clockOutViaAlert()
        } else {
            clockInViaAlert()
        }
    }
    
    func initView() {
        mainView.layer.cornerRadius = 10;
        mainView.layer.masksToBounds = true;
        
        mainView.layer.borderColor = UIColor.black.cgColor
        mainView.layer.borderWidth = 0.5
        
        mainView.layer.contentsScale = UIScreen.main.scale
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOffset = CGSize.zero
        mainView.layer.shadowRadius = 5.0
        mainView.layer.shadowOpacity = 0.5
        mainView.layer.masksToBounds = false
        mainView.clipsToBounds = false
        
        clockInButton.layer.cornerRadius = 10
        clockInButton.layer.masksToBounds = true
        clockInButton.layer.borderColor = UIColor.black.cgColor
        clockInButton.layer.borderWidth = 0.5
        clockInButton.layer.shadowColor = UIColor.black.cgColor
        clockInButton.layer.shadowOffset = CGSize.zero
        clockInButton.layer.shadowRadius = 5.0
        clockInButton.layer.shadowOpacity = 0.5
        clockInButton.clipsToBounds = false
        
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
        
        nameLabel.attributedText = NSAttributedString(string: employeeInQuestion.getName() , attributes: strokeTextAttributes)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference().child("users").child(uid)

        //
        // Get employee in question and determine if they are clocked in
        //
        
        employeeInQuestion = employeelist[employeeIndex!]
        
        //
        // Init view
        //
        
        initLabels(employee: employeeInQuestion)
        
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

    

}
