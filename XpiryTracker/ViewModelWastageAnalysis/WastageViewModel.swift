//
//  WastageViewModel.swift
//  XpiryTracker
//
//  Created by Rajvinder Singh on 9/10/20.
//  Copyright © 2020 nakhat. All rights reserved.
//

import Foundation
import UIKit

struct WastageViewModel {
    
    private var productManager = ProductManager.shared
    
    struct pModel{
        var pName : String
        var pImage : UIImage
        var qty : Int
    }
    //function
    func getWastedProduct( _ startDt : Date, _ endDt : Date) -> [pModel]{
        let products = productManager.products
        var models : [pModel] = []
        for p in products{
            let pName = p.pName!
            let pImage = UIImage(data: p.pImage as! Data)!
            let entries = p.entries?.allObjects as! [Entry]
            var q : Int32 = 0
            for e in entries{
                if (((e.expiryDt as! Date) >= startDt) && ((e.expiryDt as! Date) <= endDt) && (e.quantity > 0)){
                    q+=e.quantity
                }
            }
            
            if(q>0){
                let model = pModel(pName: pName, pImage: pImage, qty: Int(q))
                models.append(model)
            }
        }
        return models
    }
}

