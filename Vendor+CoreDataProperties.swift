//
//  Vendor+CoreDataProperties.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 7/18/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import Foundation
import CoreData


extension Vendor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vendor> {
        return NSFetchRequest<Vendor>(entityName: "Vendor")
    }

    @NSManaged public var cash: Double
    @NSManaged public var credit: Double
    @NSManaged public var total: Double
    @NSManaged public var num: Int16
    @NSManaged public var name: String
    @NSManaged public var pickup: Bool
}
