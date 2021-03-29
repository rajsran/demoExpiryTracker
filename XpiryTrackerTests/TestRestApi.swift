//
//  TestRestApi.swift
//  XpiryTrackerTests
//
//  Created by didi on 2020/10/11.
//  Copyright © 2020 nakhat. All rights reserved.
//

import XCTest

@testable import XpiryTracker
class TestRestApi: XCTestCase {
    
    var api: RestApi = RestApi()
    var shared = RestApi.sharedInstance
    var barcode: String = "8901063136465"
    
    override func setUp() {
        api = RestApi()
        testGetProductName()
        testGetData()
        
    }

    override func tearDown() {
    }

    func testExample() {
        XCTAssertNotNil(shared)
    }

    func testPerformanceExample() {
        self.measure {
        }
    }
    
    /*
     * The result and expected are same, tried using == to compare,
     * Still assert false
     */
    func testGetProductName(){
        print(api.getProductName(with: barcode))
        var expected = "Britania Milk Rusk 560 G – Subhlaxmi Grocers"
        let isEqual = (api.getProductName(with: barcode) == expected)
        print(isEqual)
        XCTAssert(isEqual)
    }
    
    
    func testGetData(){
        //Pre condition : Build a request
        let base_url:String = "https://api.promptapi.com/google_search?q="
        let apiKey: String = "MRV8S4xGK3ZZ8k5Zmhk9dRTc3bjGMMI5"
        let url = base_url + barcode
        let escapedAddress = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        var result: String = ""
        if let finalurl = URL(string: escapedAddress!)
        {
            var request = URLRequest(url: finalurl,timeoutInterval: Double.infinity)
            request.httpMethod = "GET"
            request.addValue(apiKey, forHTTPHeaderField: "apikey")
            //Set the result after API call
            result = api.getData(request)
        }
        
        //Compare result
        //Post condition: result = "Britania Milk Rusk 560 G – Subhlaxmi Grocers"
        let expected: String = "Britania Milk Rusk 560 G – Subhlaxmi Grocers"
        let compare = (result==expected)
        XCTAssert(compare)
        
    }

}
