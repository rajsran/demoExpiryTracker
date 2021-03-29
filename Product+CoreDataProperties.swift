//
//  Product+CoreDataProperties.swift
//  XpiryTracker
//
//  Created by Rajvinder Singh on 2/10/20.
//  Copyright © 2020 nakhat. All rights reserved.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var pName: String?
    @NSManaged public var pImage: NSData?
    @NSManaged public var entries: NSSet?

}

// MARK: Generated accessors for entries
extension Product {

    @objc(addEntriesObject:)
    @NSManaged public func addToEntries(_ value: Entry)

    @objc(removeEntriesObject:)
    @NSManaged public func removeFromEntries(_ value: Entry)

    @objc(addEntries:)
    @NSManaged public func addToEntries(_ values: NSSet)

    @objc(removeEntries:)
    @NSManaged public func removeFromEntries(_ values: NSSet)

}
