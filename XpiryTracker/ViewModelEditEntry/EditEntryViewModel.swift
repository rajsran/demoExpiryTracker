//
//  EditEntryViewModel.swift
//  XpiryTracker
//
//  Created by Rajvinder Singh on 8/10/20.
//  Copyright © 2020 nakhat. All rights reserved.
//

import Foundation
import UIKit

struct EditEntryViewModel{
    
    private var productManager = ProductManager.shared
    
    func changeEntry(_ pName : String, _ expiryDt : Date, _ newExpiryDt : Date, _ newAlertDt : Date, _ newIsAlert : Bool, _ newQuantity : Int) -> Bool{
        let p = productManager.findProductWithName(name: pName)
        let prod = p as! Product
        let entries = prod.entries?.allObjects as! [Entry]
        for e in entries{
            if (e.expiryDt as! Date == expiryDt){
                let result = productManager.updateEntry(product: prod, entry: e, expiryDt: newExpiryDt, alertDt: newAlertDt, isAlert: newIsAlert, quantity: Int32(newQuantity))
                return result
            }
        }
        return false
    }
    
}
