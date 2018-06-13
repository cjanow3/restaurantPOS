//
//  EndOfDayVieController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 6/7/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

//
// NOTE: Type field is not really used yet...
//       saves value into database as String always
//       Perhaps in future do something that allows
//       custom values in cells to interact
//
import UIKit
import MessageUI
import FirebaseDatabase

class EndOfDayViewController: UIViewController, MFMailComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var eodHeader: UILabel!
    @IBOutlet weak var newButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    
    var newNameTF: UITextField?
    var newDefaultValueTF: UITextField?
    var newEntryTF: UITextField?

    
    var ref:DatabaseReference!
    var uid:String = ""

    var editIndex = 0
    var currentlyEditing = false

    var pickupvendorslist = [newVendor]()
    var deliveryvendorslist = [newVendor]()
    var deliveryorderslist = [newOrder]()
    var eodlist = [newEOD]()
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            self.editIndex = editActionsForRowAt.row
            
            //
            // Create alert to edit that eod entry
            //
            
            let alert = UIAlertController(title: "Edit EOD #" + (editActionsForRowAt.row+1).description, message: "", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: self.entryTFSetup)
            
            let ok = UIAlertAction(title: "Save", style: .default, handler: { (action: UIAlertAction) -> Void in
                
                guard let entry = self.newEntryTF?.text! else {
                    self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                    return
                }
                
                //
                // Checks for arbitrary amount of spaces
                //
                
                let tempEntry = entry.trimmingCharacters(in: .whitespaces)
                
                if tempEntry != "" {
                    let eod = self.eodlist[editActionsForRowAt.row]
                    
                    let eodInfo = [
                        "name":           eod.getName(),
                        "type":           eod.getType(),
                        "default value":  eod.getDefaultValue(),
                        "entry":          entry,
                        "id":             eod.getID()
                        ] as [String : Any]
                    
                    self.ref.child("end of day").child(eod.getID()).setValue(eodInfo)
                    
                    self.getEOD()
                    
                    self.createSimpleAlert(title: "Success!", message: eod.getName() + " has been successfully updated.")
                } else {
                    self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                }
                
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            //
            // Delete note and refresh with confirmation alert
            //
            
            let eodname = self.eodlist[editActionsForRowAt.row].getName()

            let alert = UIAlertController(title: "Confirm Deletion", message: "Really delete '" + eodname + "'?", preferredStyle: .alert)
            let vc = UIViewController()
            vc.preferredContentSize = CGSize(width: 250,height: 30)
            
            alert.setValue(vc, forKey: "contentViewController")
            
            let ok = UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction) -> Void in
                
                let id = self.eodlist[editActionsForRowAt.row].getID()
                self.ref.child("end of day").child(id).removeValue()
                self.getEOD()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eodlist.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        self.createSimpleAlert(title: eodlist[indexPath.row].getName(), message: eodlist[indexPath.row].getEntry())
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryFieldCell", for: indexPath) as! entryFieldTableViewCell
        
        cell.entryLabel.text = eodlist[indexPath.row].getEntry()
        cell.fieldLabel.text = eodlist[indexPath.row].getName()
        
        return cell
    }
    
    func nameTFSetup(textfield: UITextField!) {
        newNameTF = textfield

        if currentlyEditing {
            newNameTF?.text! = eodlist[editIndex].getEntry()
        } else {
            newNameTF?.placeholder = "Field Name"
        }
    }
    
    func entryTFSetup(textfield: UITextField!) {
        newEntryTF = textfield
        newEntryTF?.text! = eodlist[editIndex].getEntry()

    }
    
    func defaultValueTFSetup(textfield: UITextField!) {
        newDefaultValueTF = textfield
        if currentlyEditing {
            newNameTF?.text! = eodlist[self.editIndex].getDefaultValue()
        } else {
            newDefaultValueTF?.placeholder = "Default Value"
        }
        
    }
    
    //
    //  Reset day -- prompts user with password before clearing out core data
    //
    
    @IBAction func resetDay(_ sender: Any) {
        createAlertResetDay(title: "Enter Password", message: "")
    }
    
    
    @IBAction func newEODField(_ sender: Any) {
        currentlyEditing = false
        createAlertAddEOD()
    }
    
    //
    // Create inital alert to add a new field to EOD TableView and .csv file
    // then call ..choseType() to get type of values it will hold, then confirm
    //
    
    func createAlertAddEOD() {
        let alert = UIAlertController(title: "Add Field", message: "", preferredStyle: .alert)

        alert.addTextField(configurationHandler: nameTFSetup)
        alert.addTextField(configurationHandler: defaultValueTFSetup)

        let ok = UIAlertAction(title: "Next", style: .default, handler: { (action: UIAlertAction) -> Void in
                
            guard let name = self.newNameTF?.text!, let defaultValue = self.newDefaultValueTF?.text! else {
                self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                return
            }
            //
            // Checks for arbitrary amount of spaces
            //
                
            let tempName = name.trimmingCharacters(in: .whitespaces)
            
                
            if tempName != "" {
                
                self.createAlertChooseType(name: name, defaultValue: defaultValue)
                
            } else {
                self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
            }
        })
        
        alert.addAction(ok)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func createAlertChooseType(name: String, defaultValue: String) {
        var valueType = ""
        let alert = UIAlertController(title: "Choose Data Type", message: "", preferredStyle: .alert)

        let textButton = UIAlertAction(title: "Text", style: .default, handler: { (action: UIAlertAction) -> Void in
            
            valueType = "String"
            
            let eod = newEOD(NAME: name, TYPE: valueType, ENTRY: defaultValue, DEFAULTVALUE: defaultValue, ID: "")
                
            self.createAlertConfirmEOD(eod: eod)
            
        })
        
        let integerButton = UIAlertAction(title: "Integer", style: .default, handler: { (action: UIAlertAction) -> Void in
            
            valueType = "Int"
            
            let eod = newEOD(NAME: name, TYPE: valueType, ENTRY: defaultValue, DEFAULTVALUE: defaultValue, ID: "")

            self.createAlertConfirmEOD(eod: eod)
            
            
        })
        
        let decimalButton = UIAlertAction(title: "Decimal", style: .default, handler: { (action: UIAlertAction) -> Void in
            
            valueType = "Double"
            
            let eod = newEOD(NAME: name, TYPE: valueType, ENTRY: defaultValue, DEFAULTVALUE: defaultValue, ID: "")

            self.createAlertConfirmEOD(eod: eod)
            
            
        })
        
        let bothButton = UIAlertAction(title: "Numbers and text", style: .default, handler: { (action: UIAlertAction) -> Void in
            
            valueType = "String"
            
            let eod = newEOD(NAME: name, TYPE: valueType, ENTRY: defaultValue, DEFAULTVALUE: defaultValue, ID: "")

            self.createAlertConfirmEOD(eod: eod)
            
            
        })
        
        alert.addAction(integerButton)
        alert.addAction(decimalButton)
        alert.addAction(textButton)
        alert.addAction(bothButton)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func createAlertConfirmEOD(eod: newEOD) {
        
        let message = "Field Name: " + eod.getName() + "\n" + "Type: " + eod.getType() + "\n" + "Default Value: " + eod.getDefaultValue()
        
        
        let alert = UIAlertController(title: "Confirm", message: message, preferredStyle: .alert)
        
        
        let ok = UIAlertAction(title: "Add", style: .default, handler: { (action: UIAlertAction) -> Void in
            let idRef = self.ref.child("end of day").childByAutoId()
            let id = idRef.key
            
            eod.setID(ID: id)
            
            let eodInfo = [
                "name":           eod.getName(),
                "type":           eod.getType(),
                "default value":  eod.getDefaultValue(),
                "entry":          eod.getEntry(),
                "id":             eod.getID()
                ] as [String : Any]
            
            self.ref.child("end of day").child(id).setValue(eodInfo)
            
            self.getEOD()

        })
        
        alert.addAction(ok)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    

    //
    // Grabs all eod fields from FirebaseDatabase
    //
    
    func getEOD() {
        
        self.eodlist.removeAll()
        
        ref.child("end of day").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                let eod = newEOD()
                
                eod.setName(NAME: dictionary["name"] as! String)
                eod.setType(TYPE: dictionary["type"] as! String)
                eod.setEntry(ENTRY: dictionary["entry"] as! String)
                eod.setDefaultValue(DEFVAL: dictionary["default value"] as! String)
                eod.setID(ID: dictionary["id"] as! String)
                
                var beenAdded = false
                
                for e in self.eodlist {
                    if e.getID() == eod.getID() {
                        beenAdded = true
                    }
                }
                
                if (!beenAdded) {
                    self.eodlist.append(eod)
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
    } //end getEOD()
    
    
    //
    // MARK: Email -- takes current orders and ultimately creates a .csv file along with xfactor, store credit/cash/tips, etc.
    //
    
    @IBAction func emailCurrentData(_ sender: Any) {
        //
        // NOTE: This is specific for BIG G'S
        //
        // Take field names end credit/tip and add them
        // for email purposes... Find general solution
        //
        
        var endCredit = 0.0
        var endTip = 0.0
        
        for e in eodlist {
            
            if e.getName() == "End Credit" {
                endCredit = Double(e.getEntry())!
            } else if e.getName() == "End Tip" {
                endTip = Double(e.getEntry())!
            }
            
        }
        
        let endTotalCreditCard = endCredit + endTip

        print("end cc = " + endTotalCreditCard.description)
        //
        // format current date so we know what day the orders are from
        //
        
        let date = Date()
        let formatter = DateFormatter()
        let filenameEnding = "_TaylorOrderData.csv"
    
        formatter.dateFormat = "dd-MM-yyyy"
        
        var filename = formatter.string(from: date)
        
        filename.append(filenameEnding)
        
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)
    
        //
        // create text for csv file -- Pickup then Delivery
        //
        var csvText = ""
        
        for e in eodlist {
            if e.getName() != "End Credit" && e.getName() != "End Tip" {
                csvText.append(e.getName() + ",")
            }
        }
        
        csvText.append("Store Credit Card,Store Credit Card Tip,Store Credit Card Total,")
        
        //
        // Get pickup/delviery vendors and the last element in that list
        // to determine if to append '\n' or ',' to maintain format
        //
        
        var totDF = 0.0
        var totTip = 0.0
        var totEarned = 0.0
        
        var pickupLine = ""
        var deliveryLine = ""
        
        var totalSales = 0.0
        var totalPickupSales = 0.0
        var totalDeliverySales = 0.0
        
        

        
         //
         // Retrieve driver's payout, then subtract it from
         // delivery totals to record accurate restaurant sales
         //
        
         for res in self.deliveryorderslist {
            totDF += res.getDeliveryFee()
            totTip += res.getTip()
         }
         
         totEarned = totDF + totTip
 
        
        
        //
        // Add each pickup vendor's name to a string that is
        // appended to the csv text
        //
        
        for v in self.pickupvendorslist {
            
            pickupLine.append(v.getName() + ",")

        }
        
        csvText.append(pickupLine)
        
        //
        // - Add each delivery vendor's name to a string that is
        // appended to the csv text
        //
        // - Get total $ of sale from delivery vendors
        //
        
        for v in self.deliveryvendorslist {
            totalDeliverySales += v.getTotal()

            deliveryLine.append(v.getName() + " Credit," + v.getName() + " Cash," + v.getName() + " Total," + v.getName() + " # Deliveries,")
        }
        
        csvText.append(deliveryLine)
        
        csvText.append("Total Delivery Sales,Total Delivery #,Total Delivery Fees\n")
        
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
        
        var secondRowPreFigures = ""
        
        for e in eodlist {
            if e.getName() != "End Credit" && e.getName() != "End Tip" {
                secondRowPreFigures.append(e.getEntry() + ",")
            }
        }
        
        //let secondRowPreFigures = (endXFactor + "," + endCash.description + "," + endCredit.description + "," + endTip.description  + "," + endTotalCreditCard.description + "," + endFoodaPopup.description + "," + endFoodaCateringTotal.description + "," + endFoodaCateringTips.description + ",")
        
        secondRowPreFigures.append(endCredit.description + "," + endTip.description + "," + endTotalCreditCard.description + ",")
        csvText.append(secondRowPreFigures)

    
 
        //
        // Adding pickup numbers
        //
 
        for v in self.pickupvendorslist {
            csvText.append(v.getTotal().description + ",")
 
        }
         
        
        //
        // Adding delivery numbers
        //
        
         for v in self.deliveryvendorslist {
         
         csvText.append(v.getCredit().description + "," + v.getCash().description + "," + v.getTotal().description + "," + v.getNum().description + ",")
         
         }
 
        //
        // Adding final totals
        //
        
        csvText.append(totalDeliverySales.description + "," + deliveryorderslist.count.description + "," + totDF.description)

        //
        // attempt to create file
        //
 
        do {
            
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            
        } catch {
            createSimpleAlert(title: "Failed to create file", message: error.localizedDescription)
            print("Failed to create file")
            print("\(error)")
            return
        }
        
        
        if MFMailComposeViewController.canSendMail() {              //checking to see if it is possible to send mail
            let emailController = MFMailComposeViewController()     //email view controller init
            emailController.mailComposeDelegate = self              //setting delegate to self
           
            emailController.setToRecipients(["chrisjanowski@hotmail.com","jgaytan@uwalumni.com","emeraldmillan@gmail.com"])
            
            //
            // TODO: Emails are hardcoded in, create settings page for EOD to allow x amount of users to receive emails
            //
            
            emailController.setSubject("BIG G'S TAYLOR - Email data for \(date)")
            emailController.setMessageBody("<p>See attached .csv file for the taylor street data</p>", isHTML: true)
            
            emailController.addAttachmentData(NSData(contentsOf: path!)! as Data, mimeType: "text/csv", fileName: "Orders.csv")
            
            present(emailController, animated: true, completion: nil)
            
            func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
                
                emailController.dismiss(animated: true, completion: nil)
            }
        }
        
        
    
        
        
       
    } //end email data
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
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
    
    //
    // Creates alert with password to reset day
    //
    
    func createAlertResetDay(title: String, message: String) {
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
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) -> Void in
            
            let inputPassword = alert.textFields?[0].text
            
            if (inputPassword != "0000") {
                self.createSimpleAlert(title: "Incorrect", message: "Try again")
            } else {
                
                //
                // Go through each entry in eodlist and
                // reset its value for default value
                //
            
                for e in self.eodlist {
                    
                    self.ref.child("end of day").child(e.getID()).updateChildValues(["entry": e.getDefaultValue()])
                }
                
                self.ref.child("orders").removeValue()
                
                self.createSimpleAlert(title: "Confirmed", message: "The totals have been reset.")
                
                self.getEOD()
            }
 
        })
        
        alert.addAction(cancel)
        
        alert.addAction(ok)
        
        alert.addTextField(configurationHandler: { (textField: UITextField) -> Void in textField.placeholder = "Password"})
        
        alert.textFields?[0].isSecureTextEntry = true

        self.present(alert, animated: true, completion: nil)
        
    } //end createalert
    
    func initView() {
        resetButton.layer.cornerRadius = 10
        resetButton.layer.masksToBounds = true
        resetButton.layer.borderColor = UIColor.black.cgColor
        resetButton.layer.borderWidth = 0.5
        resetButton.layer.shadowColor = UIColor.black.cgColor
        resetButton.layer.shadowOffset = CGSize.zero
        resetButton.layer.shadowRadius = 5.0
        resetButton.layer.shadowOpacity = 0.5
        resetButton.clipsToBounds = false
        
        returnButton.layer.cornerRadius = 10
        returnButton.layer.masksToBounds = true
        returnButton.layer.borderColor = UIColor.black.cgColor
        returnButton.layer.borderWidth = 0.5
        returnButton.layer.shadowColor = UIColor.black.cgColor
        returnButton.layer.shadowOffset = CGSize.zero
        returnButton.layer.shadowRadius = 5.0
        returnButton.layer.shadowOpacity = 0.5
        returnButton.clipsToBounds = false
        
        emailButton.layer.cornerRadius = 10
        emailButton.layer.masksToBounds = true
        emailButton.layer.borderColor = UIColor.black.cgColor
        emailButton.layer.borderWidth = 0.5
        emailButton.layer.shadowColor = UIColor.black.cgColor
        emailButton.layer.shadowOffset = CGSize.zero
        emailButton.layer.shadowRadius = 5.0
        emailButton.layer.shadowOpacity = 0.5
        emailButton.clipsToBounds = false
        
        newButton.layer.cornerRadius = 10
        newButton.layer.masksToBounds = true
        newButton.layer.borderColor = UIColor.black.cgColor
        newButton.layer.borderWidth = 0.5
        newButton.layer.shadowColor = UIColor.black.cgColor
        newButton.layer.shadowOffset = CGSize.zero
        newButton.layer.shadowRadius = 5.0
        newButton.layer.shadowOpacity = 0.5
        newButton.clipsToBounds = false
        
        let strokeTextAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.strokeColor : UIColor.black,
            NSAttributedStringKey.foregroundColor : UIColor.white,
            NSAttributedStringKey.strokeWidth : -2.0,
            ]
        
        eodHeader.attributedText = NSAttributedString(string: "End of Day" , attributes: strokeTextAttributes)
    }
    
    //
    // used to dismiss keyboards
    //
    
    @objc func doneClicked() {
        view.endEditing(true)
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        //
        // Initialize database reference
        //
        
        ref = Database.database().reference().child("users").child(uid)

        //
        // Init view for VC
        //
        
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }




}
