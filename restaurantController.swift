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
    
    class func getContext() -> NSManagedObjectContext
    {
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

    
    
    //MARK: order struct and its functions to store/retrieve/manipulate data
    struct OrderItem
    {
        var name:String?
        var address:String?
        var vendor:String?
        var price:Double?
        var tip:Double?
        var delivFee:Double?
        var pickup:Bool
        var cash:Bool
        
        init()
        {
            name = ""
            address = ""
            vendor = ""
            price = 0.0
            delivFee = 0.0
            tip = 0.0
            pickup = true
            cash = true
        }
        
        init(NAME:String, ADDRESS:String, VENDOR:String, PRICE:Double, TIP:Double, DELIVFEE:Double, PICKUP:Bool, CASH:Bool)
        {
            name = NAME;
            address = ADDRESS;
            vendor = VENDOR;
            price = PRICE;
            delivFee = DELIVFEE;
            tip = TIP;
            pickup = PICKUP;
            cash = CASH
        }
    }
    
    class func storeOrder_OBJECT(newOrder:OrderItem)
    {
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
    
    class func fetchOrders() -> [OrderItem]
    {
        var array = [OrderItem]()
        
        let fetchRequest:NSFetchRequest<Order> = Order.fetchRequest();
        
        do
        {
            let fetchResult = try getContext().fetch(fetchRequest);
            
            for res in fetchResult
            {
                
                let anOrder = OrderItem(NAME: res.name!, ADDRESS: res.address!, VENDOR: res.vendor!, PRICE: res.price, TIP: res.tip, DELIVFEE: res.delivFee, PICKUP: res.pickup, CASH: res.cash)
                

                
                array.append(anOrder);
                
            }
        }
            
        catch
        {
            print(error.localizedDescription);
        }
        
        return array;
    }

    
    
    
}
