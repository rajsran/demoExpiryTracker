//
//  AllProductsViewModel.swift
//  XpiryTracker
//
//  Created by Rajvinder Singh on 3/10/20.
//  Copyright © 2020 nakhat. All rights reserved.
//

import Foundation
import UIKit

struct AllProductsViewModel{
    
    private var productManager = ProductManager.shared
    
    struct pModel{
        var pName : String
        var pImage : UIImage
        var entry : [Entry]
    }
    
    func getDetails() -> ([pModel]){
        productManager.loadProducts()
        let products = productManager.products
        var temp1 : [pModel] = []
        
        for (_, product) in products.enumerated(){
            
            let nm = product.pName
            let img = UIImage(data: product.pImage as! Data)
            let ent = product.entries
            
            let entries = product.entries?.allObjects as! [Entry]
            
            var ents : [Entry] = []
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let today = Date()
            let s = dateFormatter.string(from: today)
            let t = dateFormatter.date(from: s)
            
            for e in entries{
                if (e.expiryDt! as Date >= t! && e.quantity>0){
                    ents.append(e)
                }
                
            }
            
            if (ents.count != 0){
                ents = ents.sorted(by: { $0.expiryDt!.compare($1.expiryDt! as Date)  == .orderedAscending })
                let pd = pModel(pName: nm!, pImage: img!, entry: ents)
            temp1.append(pd)
            }
            
        }
        
        return(temp1)
    }
    
    func searchSubstr(searchText : String) -> ([pModel]){
        //productManager.loadProducts()
        let products = productManager.products
        var temp1 : [pModel] = []
        
        for (_, product) in products.enumerated(){
            
            let nm = product.pName
            let img = UIImage(data: product.pImage! as Data)
            let ent = product.entries
            
            let entries = product.entries?.allObjects as! [Entry]
            
            var ents : [Entry] = []
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let today = Date()
            let s = dateFormatter.string(from: today)
            let t = dateFormatter.date(from: s)
            
            for e in entries{
                if (e.expiryDt! as Date >= t! && e.quantity>0){
                    ents.append(e)
                }
                
            }
            
            if ((nm?.lowercased().contains(searchText.lowercased()))! &&  (ents.count != 0)){
                ents = ents.sorted(by: { $0.expiryDt!.compare($1.expiryDt! as Date)  == .orderedAscending })
                let pd = pModel(pName: nm!, pImage: img!, entry: ents)
                temp1.append(pd)
            }
        }
        
        return(temp1)
    }
    
    func deleteProduct(name: String) -> (Bool){
            productManager.deleteProduct(name: name)
        
        return true;
    }
}
