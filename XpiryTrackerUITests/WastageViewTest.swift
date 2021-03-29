//
//  WastageViewTest.swift
//  XpiryTrackerUITests
//
//  Created by didi on 2020/10/11.
//  Copyright © 2020 nakhat. All rights reserved.
//

import XCTest

class WastageViewTest: XCTestCase {

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

    func testExample() {

        //Test Wastage view
        let app = XCUIApplication()
        app.tabBars.buttons["More"].tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Wastage"]/*[[".cells.staticTexts[\"Wastage\"]",".staticTexts[\"Wastage\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        //Record the number of buttons, label and cells before searching
        let numButtons = app.buttons.count
        let numLabels = app.staticTexts.count
        let numTables = app.tables.cells.count
        
        XCTAssertEqual(numButtons, 8)
        XCTAssertEqual(numLabels, 7)
        XCTAssertEqual(numTables, 0)
        
        //Search for wasted on 11/10/20, It changes based on database
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .textField).element(boundBy: 0).tap()
        
        element.children(matching: .textField).element(boundBy: 0).typeText("11/10/2020")
        
        let doneButton = app.toolbars["Toolbar"].buttons["Done"]
        doneButton.tap()
        element.children(matching: .textField).element(boundBy: 1).tap()
        
        element.children(matching: .textField).element(boundBy: 1).typeText("11/10/2020")
        doneButton.tap()
        
        //The numbers of buttons, label and cells should change if there's one wastage
        let numButtonsAfter = app.buttons.count
        let numLabelsAfter = app.staticTexts.count
        let numTableAfter = app.tables.cells.count
        XCTAssertEqual(numButtonsAfter, 6)
        XCTAssertEqual(numLabelsAfter, 5)
        XCTAssertEqual(numTableAfter, 0)
        
    }

}
