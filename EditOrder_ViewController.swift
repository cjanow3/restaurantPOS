//
//  EditOrder_ViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 5/25/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit
import CoreData

class EditOrder_ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = restaurantController.getContext()
    
    @IBOutlet weak var editSegControl: UISegmentedControl!
    
    //labels with respective text fields
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var vendorTF: UITextField!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressTF: UITextField!
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var tipTF: UITextField!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceTF: UITextField!
    
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    @IBOutlet weak var deliveryFeeTF: UITextField!
    
    @IBOutlet weak var refundLabel: UILabel!
    @IBOutlet weak var refundTF: UITextField!
    
    @IBOutlet weak var pickupDeliveryLabel: UILabel!
    @IBOutlet weak var pickupDeliveryTF: UITextField!
    
    @IBOutlet weak var cashCreditLabel: UILabel!
    @IBOutlet weak var cashCreditTF: UITextField!
    
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var currentEditLabel: UILabel!
    
    //MARK: Picker View -- PickupDelivery & Cash/credit & Vendor
    @IBOutlet weak var pickupDeliveryPicker: UIPickerView!
    @IBOutlet weak var cashCreditPicker: UIPickerView!
    @IBOutlet weak var vendorPicker: UIPickerView!
    

    
    let cashCredit = ["Cash", "Credit"]
    let pickupDelivery = ["Pickup", "Delivery"]
    let vendors = ["Amazon", "Caviar", "Doordash", "Eat24", "Grubhub", "Postmates", "Uber" , "Delivery.com", "Eat24", "Foodler", "Groupon", "Grubhub", "Seamless", "SLICE"]
    

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == pickupDeliveryPicker
        {
            return pickupDelivery[row]
        }
        
        else if pickerView == cashCreditPicker
        {
            return cashCredit[row]
        }
            
        else if pickerView == vendorPicker
        {
            return vendors[row]
        }
        
        else
        {
            return ""
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == pickupDeliveryPicker
        {
            return pickupDelivery.count
        }
            
        else if pickerView == cashCreditPicker
        {
            return cashCredit.count
        }

        else if pickerView == vendorPicker
        {
            return vendors.count
        }
            
        else
        {
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == pickupDeliveryPicker
        {
            pickupDeliveryTF.text = pickupDelivery[row]
        }
            
        else if pickerView == cashCreditPicker
        {
            cashCreditTF.text = cashCredit[row]
        }
        
        else if pickerView == vendorPicker
        {
            vendorTF.text = vendors[row]
        }
    }
    
    var cName:String?
    var cVendor:String?
    var cAddress:String?
    var cCashCredit:String?
    var cPickupDelivery:String?
    
    var cTip:Double?
    var cDeliveryFee:Double?
    var cPrice:Double?
    var cRefund:Double?
    
    var cPickup:Bool?
    var cCash:Bool?

    @IBAction func changeEdit(_ sender: Any) {
        
        switch editSegControl.selectedSegmentIndex
        {
        case 0:
            nameLabel.isHidden = false
            nameTF.isHidden = false
            
            vendorLabel.isHidden = true
            vendorTF.isHidden = true
            
            addressLabel.isHidden = true
            addressTF.isHidden = true
            
            tipLabel.isHidden = true
            tipTF.isHidden = true
            
            priceLabel.isHidden = true
            priceTF.isHidden = true
            
            deliveryFeeLabel.isHidden = true
            deliveryFeeTF.isHidden = true
            
            refundLabel.isHidden = true
            refundTF.isHidden = true
            
            cashCreditLabel.isHidden = true
            cashCreditTF.isHidden = true
            
            pickupDeliveryLabel.isHidden = true
            pickupDeliveryTF.isHidden = true
            
            cashCreditPicker.isHidden = true
            pickupDeliveryPicker.isHidden = true
            vendorPicker.isHidden = true
            
            currentEditLabel.text = cName
            
            

        case 1:
            vendorLabel.isHidden = false
            vendorTF.isHidden = false
            
            nameLabel.isHidden = true
            nameTF.isHidden = true
            
            addressLabel.isHidden = true
            addressTF.isHidden = true
            
            tipLabel.isHidden = true
            tipTF.isHidden = true
            
            priceLabel.isHidden = true
            priceTF.isHidden = true
            
            deliveryFeeLabel.isHidden = true
            deliveryFeeTF.isHidden = true
            
            refundLabel.isHidden = true
            refundTF.isHidden = true
            
            cashCreditLabel.isHidden = true
            cashCreditTF.isHidden = true
            
            pickupDeliveryLabel.isHidden = true
            pickupDeliveryTF.isHidden = true
            
            cashCreditPicker.isHidden = true
            pickupDeliveryPicker.isHidden = true
            vendorPicker.isHidden = false

            currentEditLabel.text = cVendor

            
        case 2:
            vendorLabel.isHidden = true
            vendorTF.isHidden = true
            
            nameLabel.isHidden = true
            nameTF.isHidden = true
            
            addressLabel.isHidden = false
            addressTF.isHidden = false
            
            tipLabel.isHidden = true
            tipTF.isHidden = true
            
            priceLabel.isHidden = true
            priceTF.isHidden = true
            
            deliveryFeeLabel.isHidden = true
            deliveryFeeTF.isHidden = true
            
            refundLabel.isHidden = true
            refundTF.isHidden = true
            
            cashCreditLabel.isHidden = true
            cashCreditTF.isHidden = true
            
            pickupDeliveryLabel.isHidden = true
            pickupDeliveryTF.isHidden = true
            
            cashCreditPicker.isHidden = true
            pickupDeliveryPicker.isHidden = true
            vendorPicker.isHidden = true

            currentEditLabel.text = cAddress
            
        case 3:
            vendorLabel.isHidden = true
            vendorTF.isHidden = true
            
            nameLabel.isHidden = true
            nameTF.isHidden = true
            
            addressLabel.isHidden = true
            addressTF.isHidden = true
            
            tipLabel.isHidden = true
            tipTF.isHidden = true
            
            priceLabel.isHidden = true
            priceTF.isHidden = true
            
            deliveryFeeLabel.isHidden = true
            deliveryFeeTF.isHidden = true
            
            refundLabel.isHidden = true
            refundTF.isHidden = true
            
            cashCreditLabel.isHidden = false
            cashCreditTF.isHidden = false
            
            pickupDeliveryLabel.isHidden = true
            pickupDeliveryTF.isHidden = true
            
            cashCreditPicker.isHidden = false
            pickupDeliveryPicker.isHidden = true
            vendorPicker.isHidden = true

            
            currentEditLabel.text = cCashCredit

        case 4:
            vendorLabel.isHidden = true
            vendorTF.isHidden = true
            
            nameLabel.isHidden = true
            nameTF.isHidden = true
            
            addressLabel.isHidden = true
            addressTF.isHidden = true
            
            tipLabel.isHidden = true
            tipTF.isHidden = true
            
            priceLabel.isHidden = true
            priceTF.isHidden = true
            
            deliveryFeeLabel.isHidden = true
            deliveryFeeTF.isHidden = true
            
            refundLabel.isHidden = true
            refundTF.isHidden = true
            
            cashCreditLabel.isHidden = true
            cashCreditTF.isHidden = true
            
            pickupDeliveryLabel.isHidden = false
            pickupDeliveryTF.isHidden = false
            
            cashCreditPicker.isHidden = true
            pickupDeliveryPicker.isHidden = false
            vendorPicker.isHidden = true

            currentEditLabel.text = cPickupDelivery
            
        case 5:
            vendorLabel.isHidden = true
            vendorTF.isHidden = true
        
            nameLabel.isHidden = true
            nameTF.isHidden = true
            
            addressLabel.isHidden = true
            addressTF.isHidden = true
            
            tipLabel.isHidden = false
            tipTF.isHidden = false
            
            priceLabel.isHidden = true
            priceTF.isHidden = true
            
            deliveryFeeLabel.isHidden = true
            deliveryFeeTF.isHidden = true
            
            refundLabel.isHidden = true
            refundTF.isHidden = true
            
            cashCreditLabel.isHidden = true
            cashCreditTF.isHidden = true
            
            pickupDeliveryLabel.isHidden = true
            pickupDeliveryTF.isHidden = true
            
            cashCreditPicker.isHidden = true
            pickupDeliveryPicker.isHidden = true
            vendorPicker.isHidden = true

            currentEditLabel.text = cTip?.description

            
        case 6:
            vendorLabel.isHidden = true
            vendorTF.isHidden = true
            
            nameLabel.isHidden = true
            nameTF.isHidden = true
            
            addressLabel.isHidden = true
            addressTF.isHidden = true
            
            tipLabel.isHidden = true
            tipTF.isHidden = true
            
            priceLabel.isHidden = false
            priceTF.isHidden = false
            
            deliveryFeeLabel.isHidden = true
            deliveryFeeTF.isHidden = true
            
            refundLabel.isHidden = true
            refundTF.isHidden = true
            
            cashCreditLabel.isHidden = true
            cashCreditTF.isHidden = true
            
            pickupDeliveryLabel.isHidden = true
            pickupDeliveryTF.isHidden = true
            
            cashCreditPicker.isHidden = true
            pickupDeliveryPicker.isHidden = true
            vendorPicker.isHidden = true

            currentEditLabel.text = cPrice?.description
            
        case 7:
            vendorLabel.isHidden = true
            vendorTF.isHidden = true
            
            nameLabel.isHidden = true
            nameTF.isHidden = true
            
            addressLabel.isHidden = true
            addressTF.isHidden = true
            
            tipLabel.isHidden = true
            tipTF.isHidden = true
            
            priceLabel.isHidden = true
            priceTF.isHidden = true
            
            deliveryFeeLabel.isHidden = false
            deliveryFeeTF.isHidden = false
            
            cashCreditLabel.isHidden = true
            cashCreditTF.isHidden = true
            
            pickupDeliveryLabel.isHidden = true
            pickupDeliveryTF.isHidden = true
            
            refundLabel.isHidden = true
            refundTF.isHidden = true
            
            cashCreditPicker.isHidden = true
            pickupDeliveryPicker.isHidden = true
            vendorPicker.isHidden = true

            currentEditLabel.text = cDeliveryFee?.description

        case 8:
            vendorLabel.isHidden = true
            vendorTF.isHidden = true
            
            nameLabel.isHidden = true
            nameTF.isHidden = true
            
            addressLabel.isHidden = true
            addressTF.isHidden = true
            
            tipLabel.isHidden = true
            tipTF.isHidden = true
            
            priceLabel.isHidden = true
            priceTF.isHidden = true
            
            deliveryFeeLabel.isHidden = true
            deliveryFeeTF.isHidden = true
            
            refundLabel.isHidden = false
            refundTF.isHidden = false
        
            cashCreditLabel.isHidden = true
            cashCreditTF.isHidden = true
            
            pickupDeliveryLabel.isHidden = true
            pickupDeliveryTF.isHidden = true
            
            
            cashCreditPicker.isHidden = true
            pickupDeliveryPicker.isHidden = true
            vendorPicker.isHidden = true
            
            currentEditLabel.text = cRefund?.description


            
        default:
            break
        }

        
    } //end seg control edit display options
    
    
    
    //MARK: Save button
    @IBAction func saveEditOrder(_ sender: Any) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
        
        
        if (editSegControl.selectedSegmentIndex == 0)
        {
            if nameTF.text != ""
            {
                guard let newName = nameTF.text else
                {
                    createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                    return
                }
                
                do {
                    
                    let results = try context.fetch(request)
                    
                    for result in results as! [NSManagedObject]
                    {
                        if ( (result.value(forKey: "name") as? String) != nil &&  (result.value(forKey: "name") as? String) == cName )
                        {
                            createSimpleAlert(title: "Name Edited", message: "Name changed from \(cName!) to \(newName)")
                            nameTF.text = ""
                            result.setValue(newName, forKey: "name")
                            restaurantController.saveContext()
                        }
                    }
                    
                } catch {
                    print(error.localizedDescription)
                    return
                }
                
            } else{
                createSimpleAlert(title: "Error", message: "Attemping to edit order without any entry")
            }
        }
        
            //Need to integrate picker view && disable text box
            
        else if (editSegControl.selectedSegmentIndex == 1)
        {
            if vendorTF.text != ""
            {
                guard let newVendor = vendorTF.text else
                {
                    createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                    return
                }
                
                do {
                    
                    let results = try context.fetch(request)
                    
                    for result in results as! [NSManagedObject]
                    {
                        if ( (result.value(forKey: "vendor") as? String) != nil &&  (result.value(forKey: "vendor") as? String) == cVendor && (result.value(forKey: "name") as? String) != nil &&  (result.value(forKey: "name") as? String) == cName)
                        {
                            createSimpleAlert(title: "Vendor Edited", message: "Vendor changed from \(cVendor!) to \(newVendor)")
                            vendorTF.text = ""

                            result.setValue(newVendor, forKey: "vendor")
                            restaurantController.saveContext()
                        }
                    }
                    
                } catch {
                    print(error.localizedDescription)
                    return
                }
                
            } else{
                createSimpleAlert(title: "Error", message: "Attemping to edit order without any entry")
            }
        }
        
        else if (editSegControl.selectedSegmentIndex == 2)
        {
            if addressTF.text != ""
            {
                guard let newAddress = addressTF.text else
                {
                    createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                    return
                }
                
                do {
                    
                    let results = try context.fetch(request)
                    
                    for result in results as! [NSManagedObject]
                    {
                        if ( (result.value(forKey: "address") as? String) != nil &&  (result.value(forKey: "address") as? String) == cAddress && (result.value(forKey: "name") as? String) != nil &&  (result.value(forKey: "name") as? String) == cName )
                        {
                            createSimpleAlert(title: "Address Edited", message: "Address changed from \(cAddress!) to \(newAddress)")
                            addressTF.text = ""

                            result.setValue(newAddress, forKey: "address")
                            restaurantController.saveContext()
                        }
                    }
                    
                } catch {
                    print(error.localizedDescription)
                    return
                }
            } else{
                createSimpleAlert(title: "Error", message: "Attemping to edit order without any entry")
            }
        }
        
            //Also needs picker view -- disable text box
        else if (editSegControl.selectedSegmentIndex == 3)
        {
            if cashCreditTF.text != ""
            {
                guard let newCashCreditString = cashCreditTF.text else
                {
                    createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                    return
                }
                
                var newCashCredit = true

                
                if (newCashCreditString == "Cash")
                {
                    newCashCredit = true
                } else {
                    newCashCredit = false
                }
                
                do {
                    
                    let results = try context.fetch(request)
                    
                    for result in results as! [NSManagedObject]
                    {
                        if ( (result.value(forKey: "cash") as? Bool) != nil &&  (result.value(forKey: "cash") as? Bool) == cCash && (result.value(forKey: "name") as? String) != nil &&  (result.value(forKey: "name") as? String) == cName )
                        {
                            createSimpleAlert(title: "Cash/Credit Edited", message: "Cash/Credit changed from \(cCashCredit!) to \(newCashCreditString)")
                            cashCreditTF.text = ""

                            result.setValue(newCashCredit, forKey: "cash")
                            restaurantController.saveContext()
                        }
                    }
                    
                } catch {
                    print(error.localizedDescription)
                    return
                }
                
                
            } else{
                createSimpleAlert(title: "Error", message: "Attemping to edit order without any entry")
            }
        }
        
            //needs picker
        else if (editSegControl.selectedSegmentIndex == 4)
        {
            
            var newPickupDelivery = true
            
            if pickupDeliveryTF.text != ""
            {
                guard let newPickupDeliveryString = pickupDeliveryTF.text else
                {
                    createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                    return
                }
                
                if (newPickupDeliveryString == "Pickup")
                {
                    newPickupDelivery = true
                } else {
                    newPickupDelivery = false
                }
                
                do {
                    
                    let results = try context.fetch(request)
                    
                    for result in results as! [NSManagedObject]
                    {
                        if ( (result.value(forKey: "pickup") as? Bool) != nil &&  (result.value(forKey: "pickup") as? Bool) == cPickup && (result.value(forKey: "name") as? String) != nil &&  (result.value(forKey: "name") as? String) == cName )                        {
                            createSimpleAlert(title: "Pickup/Delivery Edited", message: "Pickup/Delivery changed from \(cPickupDelivery!) to \(newPickupDeliveryString)")
                            pickupDeliveryTF.text = ""

                            result.setValue(newPickupDelivery, forKey: "pickup")
                            restaurantController.saveContext()
                        }
                    }
                    
                } catch {
                    print(error.localizedDescription)
                    return
                }
                
            } else{
                createSimpleAlert(title: "Error", message: "Attemping to edit order without any entry")
            }
        }
        
        else if (editSegControl.selectedSegmentIndex == 5)
        {
            if tipTF.text != ""
            {
                
                guard let newTip = Double(tipTF.text!) else
                {
                    createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                    return
                }
                
                
                do {
                    
                    let results = try context.fetch(request)
                    
                    for result in results as! [NSManagedObject]
                    {
                        if ( (result.value(forKey: "tip") as? Double) != nil &&  (result.value(forKey: "tip") as? Double) == cTip && (result.value(forKey: "name") as? String) != nil &&  (result.value(forKey: "name") as? String) == cName )
                        {
                            createSimpleAlert(title: "Tip Edited", message: "Tip changed from \(cTip!) to \(newTip)")
                            tipTF.text = ""
                            
                            result.setValue(newTip, forKey: "tip")
                            restaurantController.saveContext()
                        }
                    }
                    
                } catch {
                    print(error.localizedDescription)
                    return
                }

            } else{
                createSimpleAlert(title: "Error", message: "Attemping to edit order without any entry")
            }
        }
        
        else if (editSegControl.selectedSegmentIndex == 6)
        {
            if priceTF.text != ""
            {
                //let guard statement
                guard let newPrice = Double(priceTF.text!), let cPrice = cPrice else
                {
                    createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                    return
                }
                
                do {
                    
                    let results = try context.fetch(request)
                    
                    for result in results as! [NSManagedObject]
                    {
                        if ( (result.value(forKey: "price") as? Double) != nil &&  (result.value(forKey: "price") as? Double) == cPrice && (result.value(forKey: "name") as? String) != nil &&  (result.value(forKey: "name") as? String) == cName )
                        {
                            createSimpleAlert(title: "Price Edited", message: "Price changed from \(cPrice) to \(newPrice)")
                            priceTF.text = ""
                            
                            result.setValue(newPrice, forKey: "price")
                            restaurantController.saveContext()
                        }
                    }
                    
                } catch {
                    print(error.localizedDescription)
                    return
                }
                
            } else{
                createSimpleAlert(title: "Error", message: "Attemping to edit order without any entry")
            }
        }
        
        else if (editSegControl.selectedSegmentIndex == 7)
        {
            if deliveryFeeTF.text != ""
            {
                //let guard statement
                guard let newDeliveryFee = Double(deliveryFeeTF.text!) else
                {
                    createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                    return
                }
                
                do {
                    
                    let results = try context.fetch(request)
                    
                    for result in results as! [NSManagedObject]
                    {
                        if ( (result.value(forKey: "delivFee") as? Double) != nil &&  (result.value(forKey: "delivFee") as? Double) == cDeliveryFee && (result.value(forKey: "name") as? String) != nil &&  (result.value(forKey: "name") as? String) == cName )
                        {
                            createSimpleAlert(title: "Delivery Fee Edited", message: "Delivery Fee changed from \(cDeliveryFee!) to \(newDeliveryFee)")
                            deliveryFeeTF.text = ""
                            
                            result.setValue(newDeliveryFee, forKey: "delivFee")
                            restaurantController.saveContext()
                        }
                    }
                    
                } catch {
                    print(error.localizedDescription)
                    return
                }
                
            } else{
                createSimpleAlert(title: "Error", message: "Attemping to edit order without any entry")
            }
        }
        
        else if (editSegControl.selectedSegmentIndex == 8)
        {
            if refundTF.text != ""
            {
                guard let newRefund = Double(refundTF.text!), let cRefund = cRefund else
                {
                    createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                    return
                }
                
                do {
                    
                    let results = try context.fetch(request)
                    
                    for result in results as! [NSManagedObject]
                    {
                        if ( (result.value(forKey: "refund") as? Double) != nil && (result.value(forKey: "refund") as? Double) == cRefund && (result.value(forKey: "name") as? String) != nil &&  (result.value(forKey: "name") as? String) == cName )
                        {
                            createSimpleAlert(title: "Refund Edited", message: "Refund changed from \(cRefund) to \(newRefund)")
                            refundTF.text = ""
                            
                            result.setValue(newRefund, forKey: "refund")
                            restaurantController.saveContext()
                        }
                    }
                    
                } catch {
                    print(error.localizedDescription)
                    return
                }
                
            } else{
                createSimpleAlert(title: "Error", message: "Attemping to edit order without any entry")
            }
        }
        
        
        
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vendorLabel.isHidden = true
        vendorTF.isHidden = true
        
        nameLabel.isHidden = false
        nameTF.isHidden = false
        
        addressLabel.isHidden = true
        addressTF.isHidden = true
        
        tipLabel.isHidden = true
        tipTF.isHidden = true
        
        priceLabel.isHidden = true
        priceTF.isHidden = true
        
        deliveryFeeLabel.isHidden = true
        deliveryFeeTF.isHidden = true
        
        refundLabel.isHidden = true
        refundTF.isHidden = true
        
        cashCreditLabel.isHidden = true
        cashCreditTF.isHidden = true
        
 
        pickupDeliveryLabel.isHidden = true
        pickupDeliveryTF.isHidden = true
        
        cashCreditPicker.isHidden = true
        pickupDeliveryPicker.isHidden = true
        vendorPicker.isHidden = true
        
        cashCreditTF.isUserInteractionEnabled = false
        pickupDeliveryTF.isUserInteractionEnabled = false
        vendorTF.isUserInteractionEnabled = false

        currentEditLabel.text = cName
    }
    
    //MARK: Alert function
    
    func createSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
