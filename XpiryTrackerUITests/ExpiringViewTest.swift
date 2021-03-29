//
//  ExpiringViewTest.swift
//  XpiryTrackerUITests
//
//  Created by didi on 2020/10/11.
//  Copyright © 2020 nakhat. All rights reserved.
//

import XCTest

class ExpiringViewTest: XCTestCase {

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

    func testEditExpiringProduct() {
        
        //Add a product expring on 10/13/2020
        let app = XCUIApplication()
        app.tabBars.buttons["Add"].tap()
        
        let element = app.otherElements["Add Product"].children(matching: .other).element(boundBy: 1)
        let textField = element.children(matching: .other).element(boundBy: 0).children(matching: .textField).element
        textField.tap()
        textField.typeText("Test Product 1")
        
        let textField2 = element.children(matching: .other).element(boundBy: 2).children(matching: .textField).element
        textField2.tap()
        
        let datePickers = app.datePickers
        datePickers.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "October")
        datePickers.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "13")
        datePickers.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2020")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Add Product"]/*[[".otherElements[\"Add Product\"].buttons[\"Add Product\"]",".buttons[\"Add Product\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "addProductMsg").label, "Entry has been added.")
        
        //Test Expiring View
        app.tabBars.buttons["Expiring!"].tap()
        app.buttons["Today"].tap()
        app.buttons["Others"].tap()
        app.buttons["Tomorrow"].tap()
        app.buttons["2 Days Later"].tap()
        
        //Test Edit product
        app.tables.staticTexts["Test Product 1"].tap()
        app/*@START_MENU_TOKEN@*/.scrollViews.otherElements.tables.staticTexts["Expiring on: 13/10/2020"]/*[[".otherElements[\"Add Product\"].scrollViews.otherElements.tables",".cells.matching(identifier: \"detailViewCell\").staticTexts[\"Expiring on: 13\/10\/2020\"]",".staticTexts[\"Expiring on: 13\/10\/2020\"]",".scrollViews.otherElements.tables"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        
        let numButtons = app.buttons.count
        let numLabels = app.staticTexts.count
        
        XCTAssertEqual(numButtons, 10)
        XCTAssertEqual(numLabels, 12)
        
        app/*@START_MENU_TOKEN@*/.buttons["Update Entry"]/*[[".otherElements[\"Add Product\"].buttons[\"Update Entry\"]",".buttons[\"Update Entry\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "updateProductMsg").label, "Entry has been updated.")
        
    }

}
