//
//  ProductManager.swift
//  XpiryTracker
//
//  Created by Rajvinder Singh on 2/10/20.
//  Copyright © 2020 nakhat. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ProductManager{
    
    static let shared = ProductManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext : NSManagedObjectContext
    
    private (set) var products : [Product] = []
    
    private init(){
        managedContext = appDelegate.persistentContainer.viewContext
        loadProducts()
    }
    
    private func createNSEntry(_ expiryDt : Date, alertDt : Date, isAlert : Bool, quantity : Int32) -> Entry{
        let entryEntity = NSEntityDescription.entity(forEntityName: "Entry", in: managedContext)!
        
        let nsEntry = NSManagedObject(entity: entryEntity, insertInto: managedContext) as! Entry
        
        nsEntry.setValue(expiryDt, forKey: "expiryDt")
        nsEntry.setValue(alertDt, forKey: "alertDt")
        nsEntry.setValue(isAlert, forKey: "isAlert")
        nsEntry.setValue(quantity, forKey: "quantity")
        
        return nsEntry
    }
    
    private func createNSProduct(_ pName: String, pImage: UIImage, entry: Entry) -> Product{
        let productEntity = NSEntityDescription.entity(forEntityName: "Product", in: managedContext)!
        
        let nsProduct = NSManagedObject(entity: productEntity, insertInto: managedContext) as! Product
        
        nsProduct.setValue(pName, forKey: "pName")
        
        let data = pImage.pngData() as NSData?
        nsProduct.pImage = data
        nsProduct.entries?.adding(entry)
        
        return nsProduct
    }
    
    
    func addProduct(_ pName:String, _ pImage:UIImage, _ expiryDt:Date, _ alertDt:Date,_ isAlert:Bool,_ quantity:Int32) -> String{
        var s = "Error Saving Data."
        
        let nsEntry = createNSEntry(expiryDt, alertDt: alertDt, isAlert: isAlert, quantity: quantity)
        
        
        let prod = findProductWithName(name: pName)
        
        if (prod is Product){
            let p = prod as! Product
            let entries = p.entries?.allObjects as! [Entry]
            var f = 0
            for var e in entries{
                if (e.expiryDt as! Date == expiryDt){
                    e.quantity = e.quantity + quantity
                    do{
                        try managedContext.save()
                    }catch let error as NSError{
                        print("Could not save \(error), \(error.userInfo)")
                    }
                    f = 1
                }
            }
            if (f==0){
                p.addToEntries(nsEntry)
                do{
                    try managedContext.save()
                    s = ("New entry created.")
                }catch let error as NSError{
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            else{
                s = ("An entry for this product with the same expiry date exists. Quantity added to existing batch with same expiry date.")
            }
            
        }
        
        else{
            let nsProduct = createNSProduct(pName, pImage: pImage, entry: nsEntry)
            nsProduct.addToEntries(nsEntry)
            do{
                try managedContext.save()
                s = ("New product created and entry saved.")
            }catch let error as NSError{
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        
        do{
            try managedContext.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        loadProducts()
        return s
    }
    
    func loadProducts(){
        do{
            let request = Product.fetchRequest() as NSFetchRequest<Product>
            
            let sort = NSSortDescriptor(key: "pName", ascending: true)
            
            request.sortDescriptors = [sort]

            let result = try managedContext.fetch(request)
            
            products = result as! [Product]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func findProductWithName(name:String) -> Any?{
        let fetchRequest = Product.fetchRequest() as NSFetchRequest<Product>
        
        let filter = NSPredicate(format: "pName CONTAINS %@", name)
        fetchRequest.predicate = filter
        var prod : [Product] = []
        do{
        prod = try managedContext.fetch(fetchRequest)
        }catch{
        }
        
        if (prod.count != 0){
            return prod[0]
            
        }
        
        else{
        return nil
        }
    }
    

    
    func deleteProduct(name : String) -> Bool{
        
        let p = findProductWithName(name: name)
        
        if (p is Product){
            managedContext.delete(p as! NSManagedObject)
            do{
            try managedContext.save()
            }
            catch{
                
            }
            return true
        }
        
        loadProducts()
        
        return false
    }
    
    
    func updateEntry(product : Product, entry : Entry, expiryDt : Date, alertDt : Date, isAlert : Bool, quantity : Int32) -> Bool{
        
        var entries = product.entries?.allObjects as! [Entry]
        
        for e in entries{
            if (e.expiryDt == entry.expiryDt){
                e.expiryDt = expiryDt as NSDate
                e.alertDt = alertDt as NSDate
                e.isAlert = isAlert
                e.quantity = quantity
                
                do{
                    try managedContext.save()
                    return true
                }
                catch{
                    return false
                }
            }
        }
        return false
    }
    
    func removeEntry(product : Product, entry : Entry) -> Bool{
        product.removeFromEntries(entry)
        do{
            try managedContext.save()
            return true
        }
        catch{
            return false
        }
    }
    
}
