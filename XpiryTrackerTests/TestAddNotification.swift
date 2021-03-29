//
//  TestAddNotification.swift
//  XpiryTrackerTests
//
//  Created by didi on 2020/10/11.
//  Copyright © 2020 nakhat. All rights reserved.
//

import XCTest
import UserNotifications
@testable import XpiryTracker


class TestAddNotification: XCTestCase {

    var add: AddNotification = AddNotification()
    var alertDate: String = "10/11/2020"
    var productName: String = "Test Product"
    var qty: String = "1"
    
    var shared = AddNotification.sharedInstance
    
    override func setUp() {
        add = AddNotification()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        
        XCTAssertNotNil(shared)
        
        //Test adding method
        add.setNotification(alertDate: alertDate, productName: productName, qty: qty)
        
        //The print should be "year: 2020 month: 11 day: 10 hour: 9 isLeapMonth: false"
        //XCTAssert can't be used here, as UNUserNotificationCenter.current().getPendingNotificationRequests return Void
        print(UNUserNotificationCenter.current().getPendingNotificationRequests)
        

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
