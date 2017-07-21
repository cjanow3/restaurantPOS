//
//  restaurantController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 5/16/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import Foundation
import CoreData



class restaurantController
{
    
    class func getContext() -> NSManagedObjectContext {
        return restaurantController.persistentContainer.viewContext
    
    }
    
    // MARK: - Core Data stack
    
    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "restaurantPOS_Assist")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    
    // MARK: - Core Data Saving support
    
    class func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    //MARK: vendor struct and its functions to add/delete from list restaurant is partnered with
    struct VendorItem {
        var name:String?
        var cash:Double?
        var credit:Double?
        var total:Double?
        var num:Int16?
        var pickup:Bool
        
        //Init() methods
        init() {
            
            name   = ""
            cash   = 0.0
            credit = 0.0
            total  = 0.0
            num    = 0
            pickup = true
        }
        
        init(NAME:String, CASH:Double, CREDIT:Double,TOTAL:Double, NUM:Int16, PICKUP:Bool) {
            
            name   = NAME
            cash   = CASH
            credit = CREDIT
            total  = TOTAL
            num    = NUM
            pickup = PICKUP
        }
        
        //Setters
        mutating func setName(NAME:String)
        {
            name = NAME
        }
        
        mutating func setCash(CASH:Double)
        {
            cash = CASH
        }
        
        mutating func setCredit(CREDIT:Double)
        {
            credit = CREDIT
        }
        
        mutating func setTotal(TOTAL:Double)
        {
            total = TOTAL
        }
        
        mutating func setNum(NUM:Int16)
        {
            num = NUM
        }
        
        mutating func setPickup(PICKUP:Bool)
        {
            pickup = PICKUP
        }
        
        //Getters
        func getName() -> String
        {
            return name!
        }
        
        func getCash() -> Double
        {
            return cash!
        }
        
        func getCredit() -> Double
        {
            return credit!
        }
        
        func getTotal() -> Double
        {
            return total!
        }
        
        func getNum() -> Int16
        {
            return num!
        }
        
        func getPickup() -> Bool
        {
            return pickup
        }
    }
    
    //MARK: order struct and its functions to store/retrieve/manipulate data
    struct OrderItem {
        
        var name:String?
        var address:String?
        var vendor:String?
        var price:Double?
        var tip:Double?
        var delivFee:Double?
        var pickup:Bool
        var cash:Bool
        var refund:Double?
        
        init() {
            
            name = ""
            address = ""
            vendor = ""
            price = 0.0
            delivFee = 0.0
            tip = 0.0
            refund = 0.0
            pickup = true
            cash = true
        }
        
        init(NAME:String, ADDRESS:String, VENDOR:String, PRICE:Double, TIP:Double, DELIVFEE:Double, PICKUP:Bool, CASH:Bool, REFUND:Double) {
            
            name = NAME;
            address = ADDRESS;
            vendor = VENDOR;
            price = PRICE;
            delivFee = DELIVFEE;
            tip = TIP;
            pickup = PICKUP;
            cash = CASH
            refund = REFUND
        }
        
        //setters
        mutating func setName(NAME: String)
        {
            name = NAME
        }
        
        mutating func setAddress(ADDRESS:String)
        {
            address = ADDRESS
        }
        
        mutating func setVendor(VENDOR:String)
        {
            vendor = VENDOR
        }
        
        mutating func setPrice(PRICE:Double)
        {
            price = PRICE
        }
        
        mutating func setDeliveryFee(DFEE:Double)
        {
            delivFee = DFEE
        }
        
        mutating func setTip(TIP:Double)
        {
            tip = TIP
        }
        
        mutating func setPickup(PICKUP:Bool)
        {
            pickup = PICKUP
        }
        
        mutating func setCash(CASH:Bool)
        {
            cash = CASH
        }
        
        mutating func setRefund(REFUND:Double)
        {
            refund = REFUND
        }
        
        //getters
        func getName() -> String
        {
            return name!
        }
        
        func getAddress() -> String
        {
            return address!
        }
        
        func getVendor() -> String
        {
            return vendor!
        }
        
        func getPrice() -> Double
        {
            return price!
        }
        
        func getDeliveryFee() -> Double
        {
            return delivFee!
        }
        
        func getTip() -> Double
        {
            return tip!
        }
        
        func getPickup() -> Bool
        {
            return pickup
        }
        
        func getCash() -> Bool
        {
            return cash
        }
        
        func getRefund() -> Double
        {
            return refund!
        }
    }
    
    //Stores an OrderItem into coredata
    class func storeOrder_OBJECT(newOrder:OrderItem) {
        let context = getContext();
        
        let entity = NSEntityDescription.entity(forEntityName: "Order", in: context);
        
        let managedObj = NSManagedObject(entity: entity!, insertInto: context);
        
        managedObj.setValue(newOrder.name, forKey: "name");
        managedObj.setValue(newOrder.address, forKey: "address");
        managedObj.setValue(newOrder.vendor, forKey: "vendor");
        managedObj.setValue(newOrder.price, forKey: "price");
        managedObj.setValue(newOrder.tip,forKey: "tip");
        managedObj.setValue(newOrder.delivFee, forKey: "delivFee");
        managedObj.setValue(newOrder.pickup, forKey: "pickup")
        managedObj.setValue(newOrder.cash, forKey: "cash")
        managedObj.setValue(newOrder.refund, forKey: "refund")
        
        
        do
        {
            try context.save();
            print("saved!");
            
        }
        catch
        {
            print(error.localizedDescription);
        }
        
    } //end save function
    
    //Stores a VendorItem into coredata
    class func storeVendor_OBJECT(newVendor:VendorItem) {
        let context = getContext()
        
        let entity = NSEntityDescription.entity(forEntityName: "Vendor", in: context)
        
        let managedObj = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObj.setValue(newVendor.name, forKey: "name")
        managedObj.setValue(newVendor.cash, forKey: "cash")
        managedObj.setValue(newVendor.credit, forKey: "credit")
        managedObj.setValue(newVendor.total, forKey: "total")
        managedObj.setValue(newVendor.num, forKey: "num")
        managedObj.setValue(newVendor.pickup, forKey: "pickup")

        do
        {
            try context.save();
            print("saved!");
            
        }
        catch
        {
            print(error.localizedDescription);
        }
        
    } //end save function
    
    //MARK: Fetch functions
    //Returns an array of type OrderItem
    class func fetchOrders() -> [OrderItem] {
        var array = [OrderItem]()
        
        let fetchRequest:NSFetchRequest<Order> = Order.fetchRequest();
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest);
            
            for res in fetchResult {
                
                let anOrder = OrderItem(NAME: res.name!, ADDRESS: res.address!, VENDOR: res.vendor!, PRICE: res.price, TIP: res.tip, DELIVFEE: res.delivFee, PICKUP: res.pickup, CASH: res.cash, REFUND: res.refund)
                
                array.append(anOrder);
            }
        }
            
        catch {
            print(error.localizedDescription)
        }
        
        return array
    }
    
    //Returns an array of type VendorItem -- one array for both pickup/delivery
    class func fetchVendors() -> [VendorItem] {
        var array = [VendorItem]()
        
        let fetchRequest:NSFetchRequest<Vendor> = Vendor.fetchRequest();
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest);
            
            for res in fetchResult {
                
                let aVendor = VendorItem(NAME: res.name, CASH: res.cash, CREDIT: res.credit, TOTAL: res.total, NUM: res.num, PICKUP:res.pickup)
                
                array.append(aVendor);
            }
        }
            
        catch {
            print(error.localizedDescription)
        }
        
        return array
    }
    
    //Returns an array of type VendorItem -- only composing array of pickup vendors
    class func fetchPickupVendors() -> [VendorItem] {
        var array = [VendorItem]()
        
        let fetchRequest:NSFetchRequest<Vendor> = Vendor.fetchRequest();
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest);
            
            for res in fetchResult {
                
                if (res.pickup)
                {
                    let aVendor = VendorItem(NAME: res.name, CASH: res.cash, CREDIT: res.credit, TOTAL: res.total, NUM: res.num, PICKUP:res.pickup)
                    
                    array.append(aVendor)
                }

            }
        }
            
        catch {
            print(error.localizedDescription)
        }
        
        return array
    }
    
    class func fetchDeliveryVendors() -> [VendorItem] {
        var array = [VendorItem]()
        
        let fetchRequest:NSFetchRequest<Vendor> = Vendor.fetchRequest();
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest);
            
            for res in fetchResult {
                
                if (!res.pickup)
                {
                    let aVendor = VendorItem(NAME: res.name, CASH: res.cash, CREDIT: res.credit, TOTAL: res.total, NUM: res.num, PICKUP:res.pickup)
                    
                    array.append(aVendor)
                }
                
            }
        }
            
        catch {
            print(error.localizedDescription)
        }
        
        return array
    }
    

    //MARK: Delete all orders from core data functions
    class func cleanAllOrdersCoreData() {
        
        let fetchRequest:NSFetchRequest<Order> = Order.fetchRequest();
        
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest:
            fetchRequest as! NSFetchRequest<NSFetchRequestResult>);
        
        do
        {
            print("Deleting all orders");
            try getContext().execute(deleteRequest);
            
        }
        catch
        {
            print(error.localizedDescription);
        }
    } //end clean_ALL_CoreData()
    
    class func cleanAllVendorsCoreData() {
        
        let fetchRequest:NSFetchRequest<Vendor> = Vendor.fetchRequest();
        
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest:
            fetchRequest as! NSFetchRequest<NSFetchRequestResult>);
        
        do
        {
            print("Deleting all vendors");
            try getContext().execute(deleteRequest);
            
        }
        catch
        {
            print(error.localizedDescription);
        }
    } //end clean_ALL_CoreData()
    
    //Delete specific orders from core data
    class func clean_SPECIFIC_CoreData() {
        
        let fetchRequest:NSFetchRequest<Order> = Order.fetchRequest();
        
        let predicate = NSPredicate(format: "name contains[c] %@", "Janowski")
        
        //predicate = NSPredicate(format: "address == %@", "1622 S. Allport")
        //predicate = NSPredicate(format: "price > %@", "20.00")
        
        fetchRequest.predicate = predicate;
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest:
            fetchRequest as! NSFetchRequest<NSFetchRequestResult>);
        
        do {
            print("Deleting specific content(s)");
            //Print are you sure message alert -- yes or no buttons
            try getContext().execute(deleteRequest);
        }
        catch {
            print(error.localizedDescription);
        }
    } //end cleanCoreData()
    
}
