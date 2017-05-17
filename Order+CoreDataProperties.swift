//
//  Order+CoreDataProperties.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 5/16/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order");
    }

    @NSManaged public var address: String?
    @NSManaged public var cash: Bool
    @NSManaged public var delivFee: Double
    @NSManaged public var name: String?
    @NSManaged public var pickup: Bool
    @NSManaged public var price: Double
    @NSManaged public var tip: Double
    @NSManaged public var vendor: String?
    
    

}
