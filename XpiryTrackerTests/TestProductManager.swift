//
//  TestProductManager.swift
//  XpiryTrackerTests
//
//  Created by didi on 2020/10/11.
//  Copyright © 2020 nakhat. All rights reserved.
//

import XCTest
@testable import XpiryTracker

class TestProductManager: XCTestCase {

    var shared = ProductManager.shared
    var pName: String = ""
    var pImage: UIImage = UIImage(named: "add-photo-icon-19")!
    var expiryDate: Date = Date()
    var alertDate: Date = Date()
    var isAlert: Bool = false
    var qty: Int32 = 0
    
    
    override func setUp() {
        pName = "Unit Test"
        qty = 1
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let expiryDate = formatter.date(from: "16/10/2020")
        let alertDate = formatter.date(from: "15/10/2020")
        
    }

    override func tearDown() {
    }

    func testShared() {
        XCTAssertNotNil(shared)
        testAddProduct()
        testFindProductWithName()
    }

    func testPerformanceExample() {
        self.measure {
        }
    }

    
    func testAddProduct(){
        //Test Adding a product with pre-condition params
        //Should be able to delete if added successfully
        //fucn loadProducts() is also tested
        shared.addProduct(pName, pImage, expiryDate, alertDate, isAlert, qty)
        XCTAssert(shared.deleteProduct(name: "Unit Test"))
    }
    
    func testFindProductWithName(){
        //Test find non-exist product, should return nil
        XCTAssertNil(shared.findProductWithName(name: "Not Exist"))
    }
    
    func testDeleteProduct(){
        //Test delete a non-exist product, should return false
        XCTAssertFalse(shared.deleteProduct(name: "Not Exist"))
    }
    func testUpdateEntry(){
        //Pre-condition: Add a product called Unit Test
        shared.addProduct(pName, pImage, expiryDate, alertDate, isAlert, qty)
        let p = shared.findProductWithName(name: "Unit Test")
        let product = p as! Product
        //Found the entry
        let entries = product.entries?.allObjects as! [Entry]
        for e in entries{
            if (e.expiryDt as! Date == expiryDate){
                //Should return true if updated successfully
                XCTAssert(shared.updateEntry(product: product, entry: e, expiryDt: expiryDate, alertDt: alertDate, isAlert: isAlert, quantity: qty))
            }
        }


    }
    
    func testRemoveEntry(){
        //Pre-condition: Add a product called Unit Test
        shared.addProduct(pName, pImage, expiryDate, alertDate, isAlert, qty)
        let p = shared.findProductWithName(name: "Unit Test")
        let product = p as! Product
        //Found the entry
        let entries = product.entries?.allObjects as! [Entry]
        for e in entries{
            if (e.expiryDt as! Date == expiryDate){
               //Should return true if removed successfully
                XCTAssert(shared.removeEntry(product: product, entry: e))
            }
        }
        
        
    }
    
    
    
}
