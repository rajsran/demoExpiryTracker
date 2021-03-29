//
//  Entry+CoreDataProperties.swift
//  XpiryTracker
//
//  Created by Rajvinder Singh on 2/10/20.
//  Copyright © 2020 nakhat. All rights reserved.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var expiryDt: NSDate?
    @NSManaged public var isAlert: Bool
    @NSManaged public var alertDt: NSDate?
    @NSManaged public var quantity: Int32
    @NSManaged public var product: Product?

}
