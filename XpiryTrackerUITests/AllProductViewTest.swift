//
//  AllProductViewTest.swift
//  XpiryTrackerUITests
//
//  Created by didi on 2020/10/11.
//  Copyright © 2020 nakhat. All rights reserved.
//

import XCTest

class AllProductViewTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAllProductView() {
        
        let app = XCUIApplication()
        app.tabBars.buttons["Home"].tap()
        
        let numButtons = app.buttons.count
        let numLabels = app.staticTexts.count
        
        //Record number of buttons and labels before adding a product.
        //Number changes depending on how many products are in database now
        //XCTAssertEqual(numButtons, 13)
        //XCTAssertEqual(numLabels, 17)
        
        //Add a new product called Test Product 17
        app.tabBars.buttons["Add"].tap()
        let element = app.otherElements["Add Product"].children(matching: .other).element(boundBy: 1)
        let textField = element.children(matching: .other).element(boundBy: 0).children(matching: .textField).element
        textField.tap()
        textField.typeText("Test Product 21")
        
        let textField2 = element.children(matching: .other).element(boundBy: 2).children(matching: .textField).element
        textField2.tap()
        
        let datePickers = app.datePickers
        datePickers.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "October")
        datePickers.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "14")
        datePickers.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2020")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        app/*@START_MENU_TOKEN@*/.buttons["Add Product"]/*[[".otherElements[\"Add Product\"].buttons[\"Add Product\"]",".buttons[\"Add Product\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "addProductMsg").label, "Entry has been added.")
        
        //Back to All Product view
        app.tabBars.buttons["Home"].tap()
        let numButtonsAfter = app.buttons.count
        let numLabelsAfter = app.staticTexts.count
        
        //Number of buttons and labels should be added
        //XCTAssertEqual(numButtonsAfter, 14)
        //XCTAssertEqual(numLabelsAfter, 19)
        
        XCTAssertEqual(numButtonsAfter, 10)
        XCTAssertEqual(numLabelsAfter, 12)
        
       
        
        
        
    }


}
