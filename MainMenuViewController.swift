//
//  MainMenuViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 7/7/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class MainMenuViewController: UIViewController {
    
    //
    // Reference to Firebase Database
    //
    
    var ref:DatabaseReference!
    var uid:String = ""
    
    //
    // Various lists used to hold local copies of data
    // that populate various table views, picker views, etc.
    //
    
    var orderslist = [newOrder]()
    var deliveryvendorslist = [newVendor]()
    var pickupvendorslist = [newVendor]()
    var contactlist = [newContact]()
    var employeelist = [newEmployee]()
    var notelist = [newNote]()
    var eodlist = [newEOD]()
    var rewardsuserslist = [newRewardUser]()
 
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
            }
            
        })
    } //end getEOD()
    
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
            
        })
    } //end getRewardsUsers
    
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
                
            } //end dictionary
            
            // sort employees alphabetically for convenience
            self.employeelist.sort(by: {$0.getName() < $1.getName()})
        })
    } //end getemployees


    //
    // Grabs all contacts from FirebaseDatabase
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
                
            } //end dictionary
            
        })
 
    } //end getContacts

    //
    // Grabs all orders from FirebaseDatabase
    //
    
    func getOrders() {
        ref.child("orders").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                let order = newOrder()
                
                order.setName(NAME: (dictionary["name"] as? String)!)
                order.setAddress(ADDRESS: (dictionary["address"] as? String)!)
                order.setVendor(VENDOR: (dictionary["vendor"] as? String)!)
                order.setNotes(NOTES: (dictionary["notes"] as? String)!)
                order.setPrice(PRICE: (dictionary["price"] as? Double)!)
                order.setTip(TIP: (dictionary["tip"] as? Double)!)
                order.setDeliveryFee(DFEE: (dictionary["delivery fee"] as? Double)!)
                order.setRefund(REFUND: (dictionary["refund"] as? Double)!)
                order.setPickup(PICKUP: dictionary["pickup"] as! Bool)
                order.setCash(CASH: dictionary["cash"] as! Bool)
                order.setID(ID:  (dictionary["id"] as? String)!)
                
                var beenAdded = false
                
                for o in self.orderslist {
                    if (o.getID() == order.getID()) {
                        beenAdded = true
                    }
                }
                
                if (!beenAdded) {
                    self.orderslist.append(order)
                }
                
                
                
            }
        })
        
        
    } //end getOrders()
    
    
    //
    // Grabs all vendors from FirebaseDatabase
    //
    
    func getVendors() {
        
        self.deliveryvendorslist.removeAll()
        self.pickupvendorslist.removeAll()
        
        ref.child("vendors").child("delivery vendors").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                let isAPickupVendor = dictionary["pickup"] as! Bool
                
                //
                // Determine if vendor is a delivery vendor
                //
                
                if (!isAPickupVendor) {
                    
                    let vendorName = dictionary["name"] as? String

                    let vendor = newVendor(NAME: vendorName!, CASH: 0.0, CREDIT: 0.0, TOTAL: 0.0, NUM: 0, PICKUP: false, REFUND: 0.0)
                
                    
                    //
                    // Determines if item has already been added to the array
                    //
                    
                    var beenAdded = false
                    for v in self.deliveryvendorslist {
                        if v.getName() == vendor.getName() {
                            beenAdded = true
                        }
                    }
                    
                    if (!beenAdded) {
                        self.deliveryvendorslist.append(vendor)
                    }
                }
                
            }
            
        })
        
        
        
        
        ref.child("vendors").child("pickup vendors").observe(.childAdded, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                let isAPickupVendor = dictionary["pickup"] as! Bool
                
                //
                // Determine if vendor is a pickup vendor
                //
                
                if (isAPickupVendor) {
                    
                    let vendorName = dictionary["name"] as? String

                    let vendor = newVendor(NAME: vendorName!, CASH: 0.0, CREDIT: 0.0, TOTAL: 0.0, NUM: 0, PICKUP: true, REFUND: 0.0)
                    
                    var beenAdded = false
                    
                    for v in self.pickupvendorslist {
                        if v.getName() == vendor.getName() {
                            beenAdded = true
                        }
                    }
                    
                    if (!beenAdded) {
                        self.pickupvendorslist.append(vendor)

                    }
                }
            }
        })
    } //end getVendors()
    
    //
    // Grabs all notes from FirebaseDatabase
    //
    
    func getNotes() {
        
        self.notelist.removeAll()
        
       ref.child("notes").observe(.childAdded, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                let note = newNote()
                
                
                
                note.setNote(NOTE: dictionary["note"] as! String)
                note.setDate(DATE: dictionary["date"] as! String)
                note.setID(ID: dictionary["id"] as! String)
                
                
                
                
                var beenAdded = false
                
                for n in self.notelist {
                    if n.getID() == note.getID() {
                        beenAdded = true
                    }
                }
                
                if (!beenAdded) {
                    self.notelist.append(note)
                }

            }
            
        })
        
    } //end getNotes
    
    //
    // Populate lists in their respective subsequent views
    //
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ordersseg" {
            let destVC = segue.destination as! OrdersViewController
            destVC.uid = uid

            for v in self.deliveryvendorslist {
                destVC.deliveryvendorslist.append(v)
            }
            
            for v in self.pickupvendorslist {
                destVC.pickupvendorslist.append(v)
            }
            
            for e in self.eodlist {
                destVC.eodlist.append(e)
            }
            
        } else if (segue.identifier == "contactseg") {
            let destVC = segue.destination as! ContactViewController
            destVC.uid = uid

            for c in self.contactlist {
                destVC.contactlist.append(c)
            }
            
        } else if (segue.identifier == "vendorsseg") {
            let destVC = segue.destination as! VendorsViewController
            destVC.uid = uid
            
        } else if (segue.identifier == "timeclockseg") {
            let destVC = segue.destination as! TimeClockViewController
            destVC.uid = uid

            for e in self.employeelist {
                destVC.employeelist.append(e)
            }
            
        } else if (segue.identifier == "noteseg") {
            let destVC = segue.destination as! NotesViewController
            destVC.uid = uid

            for n in self.notelist {
                destVC.notelist.append(n)
            }
        } else if (segue.identifier == "rewardseg") {
            let destVC = segue.destination as! RewardsViewController
            destVC.uid = uid

            for r in self.rewardsuserslist {
                destVC.rewardsuserslist.append(r)
            }
        }
    } //end segue
    
    //
    // Zeros out all vendors in FirebaseDatabase
    //
    
    func zeroOutVendorData() {
        for v in self.pickupvendorslist {

            v.setCredit(CREDIT: 0.0)
            v.setCash(CASH: 0.0)
            v.setNum(NUM: 0)
            v.setTotal(TOTAL: 0.0)
            v.setRefund(REFUND: 0.0)
            
        }
        
        for v in self.deliveryvendorslist {
            v.setCredit(CREDIT: 0.0)
            v.setCash(CASH: 0.0)
            v.setNum(NUM: 0)
            v.setTotal(TOTAL: 0.0)
            v.setRefund(REFUND: 0.0)
        }

        ref.child("vendors").child("pickup vendors").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                let vendorName = dictionary["name"] as? String
                                
                let vendorInfo = [
                    "cash":    0.0,
                    "credit":  0.0,
                    "total":   0.0,
                    "num":     0,
                    "refund":  0.0
                    ] as [String : Any]
                
                self.ref.child("vendors").child("pickup vendors").child(vendorName!).updateChildValues(vendorInfo)
                
            }
        })
        
        ref.child("vendors").child("delivery vendors").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                let vendorName = dictionary["name"] as? String
                
                let vendorInfo = [
                    "cash":    0.0,
                    "credit":  0.0,
                    "total":   0.0,
                    "num":     0,
                    "refund":  0.0
                    ] as [String : Any]
                
                self.ref.child("vendors").child("delivery vendors").child(vendorName!).updateChildValues(vendorInfo)
                
            }
        })
        
        
    } //end zero out data

    override func viewDidLoad() {
        super.viewDidLoad()

        //
        // Initialize
        ref = Database.database().reference().child("users").child(uid)

        //
        // Populate lists
        //

        getVendors()
        getOrders()
        getContacts()
        getEmployees()
        getNotes()
        getEOD()
        getRewardsUsers()
        
        //
        // Give design to VC
        //
        
        initView()


    }
    
    //
    // Button outlets
    //
    
    @IBOutlet weak var ordersButton: UIButton!
    @IBOutlet weak var notesButton: UIButton!
    @IBOutlet weak var vendorsButton: UIButton!
    @IBOutlet weak var rewardsButton: UIButton!
    @IBOutlet weak var timeClockButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var logOutButton: UIButton!
    
    //
    // Give design to VC
    //
    
    func initView() {
        ordersButton.layer.cornerRadius = 10
        ordersButton.layer.masksToBounds = true
        ordersButton.layer.borderColor = UIColor.black.cgColor
        ordersButton.layer.borderWidth = 0.5
        ordersButton.layer.shadowColor = UIColor.black.cgColor
        ordersButton.layer.shadowOffset = CGSize.zero
        ordersButton.layer.shadowRadius = 5.0
        ordersButton.layer.shadowOpacity = 0.5
        ordersButton.clipsToBounds = false
        
        notesButton.layer.cornerRadius = 10
        notesButton.layer.masksToBounds = true
        notesButton.layer.borderColor = UIColor.black.cgColor
        notesButton.layer.borderWidth = 0.5
        notesButton.layer.shadowColor = UIColor.black.cgColor
        notesButton.layer.shadowOffset = CGSize.zero
        notesButton.layer.shadowRadius = 5.0
        notesButton.layer.shadowOpacity = 0.5
        notesButton.clipsToBounds = false
        
        vendorsButton.layer.cornerRadius = 10
        vendorsButton.layer.masksToBounds = true
        vendorsButton.layer.borderColor = UIColor.black.cgColor
        vendorsButton.layer.borderWidth = 0.5
        vendorsButton.layer.shadowColor = UIColor.black.cgColor
        vendorsButton.layer.shadowOffset = CGSize.zero
        vendorsButton.layer.shadowRadius = 5.0
        vendorsButton.layer.shadowOpacity = 0.5
        vendorsButton.clipsToBounds = false
        
        infoButton.layer.cornerRadius = 10
        infoButton.layer.masksToBounds = true
        infoButton.layer.borderColor = UIColor.black.cgColor
        infoButton.layer.borderWidth = 0.5
        infoButton.layer.shadowColor = UIColor.black.cgColor
        infoButton.layer.shadowOffset = CGSize.zero
        infoButton.layer.shadowRadius = 5.0
        infoButton.layer.shadowOpacity = 0.5
        infoButton.clipsToBounds = false
        
        rewardsButton.layer.cornerRadius = 10
        rewardsButton.layer.masksToBounds = true
        rewardsButton.layer.borderColor = UIColor.black.cgColor
        rewardsButton.layer.borderWidth = 0.5
        rewardsButton.layer.shadowColor = UIColor.black.cgColor
        rewardsButton.layer.shadowOffset = CGSize.zero
        rewardsButton.layer.shadowRadius = 5.0
        rewardsButton.layer.shadowOpacity = 0.5
        rewardsButton.clipsToBounds = false
        
        timeClockButton.layer.cornerRadius = 10
        timeClockButton.layer.masksToBounds = true
        timeClockButton.layer.borderColor = UIColor.black.cgColor
        timeClockButton.layer.borderWidth = 0.5
        timeClockButton.layer.shadowColor = UIColor.black.cgColor
        timeClockButton.layer.shadowOffset = CGSize.zero
        timeClockButton.layer.shadowRadius = 5.0
        timeClockButton.layer.shadowOpacity = 0.5
        timeClockButton.clipsToBounds = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        zeroOutVendorData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    
    @IBAction func logOutUser(_ sender: Any) {
        print("logged out")
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        dismiss(animated: true, completion: nil)
    }
    

    //
    // Get latest version of each list
    //
    
    @IBAction func unwindToMainView(segue: UIStoryboardSegue) {
        getVendors()
        getContacts()
        getEmployees()
        getNotes()
        getEOD()
        getRewardsUsers()
    }
    
    
    
    /*
 
     func handleSignOut() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDeafults.standard.synchronize()
     }
 
 
    */
    
}
