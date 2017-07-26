//
//  Contact+CoreDataProperties.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 7/24/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var name: String?
    @NSManaged public var relationship: String?
    @NSManaged public var phoneNum: String?

}
