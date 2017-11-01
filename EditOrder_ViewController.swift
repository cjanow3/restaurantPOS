//
//  EditOrder_ViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 5/25/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EditOrder_ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var ref:DatabaseReference!
    
    //seg control to choose which field to edit
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
    
    var vendorslist = [newVendor]()


    //arrays for some fields to prevent spelling errors
    let cashCredit = ["Cash", "Credit"]
    let pickupDelivery = ["Pickup", "Delivery"]

    //fucntions to determine what pickerview is used
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //
    // Pickviews for cash/credit and pickup/delivery
    //
    // Determine which picker view is being used,
    // then display corresponding informatin
    //
    //
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == pickupDeliveryPicker {
            return pickupDelivery[row]
        } else if pickerView == cashCreditPicker{
            return cashCredit[row]
        } else if pickerView == vendorPicker{
            return vendorslist[row].getName()
        }
        
        return ""

        
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
            return vendorslist.count
        }
            
        else
        {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == pickupDeliveryPicker{
            pickupDeliveryTF.text = pickupDelivery[row]
        } else if pickerView == cashCreditPicker {
            cashCreditTF.text = cashCredit[row]
        } else if pickerView == vendorPicker {
            vendorTF.text = vendorslist[row].getName()
        }
    }
    
    //
    // End cash/credit and pickup/delivery picker view functions
    //
    
    
    
    
    //
    //cell variables used to represent each data
    //
    
    var cName:String?
    var cVendor:String?
    var cAddress:String?
    var cCashCredit:String?
    var cPickupDelivery:String?
    var cNotes:String?
    
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
            displayName()
            
        case 1:
            displayVendor()

        case 2:
            displayAddress()
            
        case 3:
            displayCashCredit()
            
        case 4:
            displayPickupDelivery()
            
        case 5:
            displayTip()
            
        case 6:
            displayPrice()
            
        case 7:
            displayDeliveryFee()

        case 8:
            displayRefund()

        default:
            break
        }

        
    } //end seg control edit display options
    
    
    //
    // MARK: Save button
    //
    // name, vendor, address, cash/credit, pickup/delivery, tip, price, DF, refund
    //
    
    
    @IBAction func saveEditOrder(_ sender: Any) {
        
        switch (editSegControl.selectedSegmentIndex) {
            
        case 0:
            guard let name = nameTF.text else{
                return
            }
            
            setName(newName: name)
        case 1:
            guard let vendor = vendorTF.text else{
                return
            }
            
            setVendor(newVendor: vendor)
        case 2:
            guard let address = addressTF.text else{
                return
            }
            
            setAddress(newAddress: address)
        case 3:
            guard let cash = cashCreditTF.text else{
                return
            }
            
            var orderCash = true

            if (cash == "Cash") {
                orderCash = true
            } else {
                orderCash = false
            }
            
            setCash(newCash: orderCash)
        case 4:
            guard let pickup = pickupDeliveryTF.text else{
                return
            }
            
            var orderPickup = true
            
            if (pickup == "Pickup") {
                orderPickup = true
            } else {
                orderPickup = false
            }
            
            setPickup(newPickup: orderPickup)
        case 5:
            guard let tip = Double(tipTF.text!) else{
                return
            }
            
            setTip(newTip: tip)
        case 6:
            guard let price = Double(priceTF.text!) else{
                return
            }
            
            setPrice(newPrice: price)
        
        case 7:
            guard let df = Double(deliveryFeeTF.text!) else{
                return
            }
            
            setDeliveryFee(newDF: df)
        case 8:
            guard let refund = Double(refundTF.text!) else{
                return
            }
            
            setRefund(newRefund: refund)
        default:
            break
            
            
        }
        
    }
    
    func setName(newName: String) {
        print(newName)
        
        
        
    }
    
    func setAddress(newAddress: String) {
        print(newAddress)

        ref.child("orders").child(cName!).child("address").setValue(newAddress)

    }
    
    func setVendor(newVendor: String) {
        print(newVendor)

        ref.child("orders").child(cName!).child("vendor").setValue(newVendor)

    }
    
    func setPrice(newPrice: Double) {
        print(newPrice)
        
        ref.child("orders").child(cName!).child("price").setValue(newPrice)

    }
    
    func setTip(newTip: Double) {
        print(newTip)
        
        ref.child("orders").child(cName!).child("tip").setValue(newTip)

    }
    
    func setDeliveryFee(newDF: Double) {
        print(newDF)
        
        ref.child("orders").child(cName!).child("delivery fee").setValue(newDF)

    }
    
    func setPickup(newPickup: Bool) {
        print(newPickup)
        
        ref.child("orders").child(cName!).child("pickup").setValue(newPickup)

    }
    
    func setCash(newCash: Bool) {
        print(newCash)
        
        ref.child("orders").child(cName!).child("cash").setValue(newCash)

    }
    
    func setRefund(newRefund: Double) {
        print(newRefund)
        
        ref.child("orders").child(cName!).child("refund").setValue(newRefund)

    }
    
    

    
    //used to dismiss keyboards
    @objc func doneClicked()
    {
        view.endEditing(true)
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        ref = Database.database().reference()

        //
        //initial view will display name
        //
        
        displayName()
        
        //
        //creating done button to close keyboards
        //
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([doneButton], animated: false)
        
        nameTF.inputAccessoryView = toolBar
        addressTF.inputAccessoryView = toolBar
        tipTF.inputAccessoryView = toolBar
        priceTF.inputAccessoryView = toolBar
        deliveryFeeTF.inputAccessoryView = toolBar
        refundTF.inputAccessoryView = toolBar
        
        vendorTF.isUserInteractionEnabled = false
        cashCreditTF.isUserInteractionEnabled = false
        pickupDeliveryTF.isUserInteractionEnabled = false


        if (cPickup)! {
            addressTF.isUserInteractionEnabled = false
            deliveryFeeTF.isUserInteractionEnabled = false
        }
        
        
    }
    
    //
    //functions used to display respective labels and TF
    //
    
    func displayName()
    {
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
    }
    
    func displayVendor()
    {
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
        
    }
    
    func displayAddress()
    {
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
    }
    
    func displayCashCredit()
    {
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
        
    }
    
    func displayPickupDelivery()
    {
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
        
    }
    
    
    func displayTip()
    {
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
    }
    
    func displayPrice()
    {
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
    }
    
    func displayDeliveryFee()
    {
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
    }
    
    func displayRefund()
    {
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
    }
    
    //
    //MARK: Alert function
    //
    
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
