//
//  WaterMyPlantsUITests.swift
//  WaterMyPlantsUITests
//
//  Created by conner on 6/28/20.
//  Copyright © 2020 conner. All rights reserved.
//

import XCTest

class WaterMyPlantsUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAPISwitcher() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.navigationBars["Water My Plants"].buttons["gear"].exists)
        app.navigationBars["Water My Plants"].buttons["gear"].tap()
        XCTAssertTrue(app.buttons["Web"].exists)
        app.buttons["Web"].tap()
        XCTAssertTrue(app.buttons["Firebase"].exists)
        app/*@START_MENU_TOKEN@*/.buttons["Firebase"]/*[[".segmentedControls.buttons[\"Firebase\"]",".buttons[\"Firebase\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    func testDeletePlant() {
        let app = XCUIApplication()
        app.launch()
        app.navigationBars["Water My Plants"].buttons["Edit"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.buttons["Delete Blueberries, Next watering  7/1/20, 8:00 AM"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["trailing0"]/*[[".cells",".buttons[\"Delete\"]",".buttons[\"trailing0\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
    }
    
    func testDetailView() {
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(app.tables/*@START_MENU_TOKEN@*/.staticTexts["Blueberries"]/*[[".cells.staticTexts[\"Blueberries\"]",".staticTexts[\"Blueberries\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Blueberries"]/*[[".cells.staticTexts[\"Blueberries\"]",".staticTexts[\"Blueberries\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertTrue(app.buttons["Watered  ✔️"].exists)
        app.buttons["Watered  ✔️"].tap()
        XCTAssertTrue(app.navigationBars["Plant  Details"].buttons["Water My Plants"].exists)
        app.navigationBars["Plant  Details"].buttons["Water My Plants"].tap()
    }
    
    func testButtons() {
        let app = XCUIApplication()
        app.launch()
        let waterMyPlantsNavigationBar = app.navigationBars["Water My Plants"]
        XCTAssertTrue(waterMyPlantsNavigationBar.buttons["Edit"].exists)
        waterMyPlantsNavigationBar.buttons["Edit"].tap()
        XCTAssertTrue(waterMyPlantsNavigationBar.buttons["Done"].exists)
        waterMyPlantsNavigationBar.buttons["Done"].tap()
        XCTAssertTrue(waterMyPlantsNavigationBar.buttons["Add"].exists)
        waterMyPlantsNavigationBar.buttons["Add"].tap()
        app.navigationBars["Add Plant"].buttons["Cancel"].tap()
        XCTAssertTrue(waterMyPlantsNavigationBar.buttons["gear"].exists)
        waterMyPlantsNavigationBar.buttons["gear"].tap()
    }
    
    func testLogin() {
        let app = XCUIApplication()
        app.launch()
        
        let username = "Conner"
        let password = "Conner"
        
        app.navigationBars["Water My Plants"].buttons["gear"].tap()
        
        app/*@START_MENU_TOKEN@*/.staticTexts["Login VC"]/*[[".buttons[\"Login VC\"].staticTexts[\"Login VC\"]",".staticTexts[\"Login VC\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Sign In"]/*[[".segmentedControls.buttons[\"Sign In\"]",".buttons[\"Sign In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let usernameTextField = app.textFields["Username"]
        XCTAssertTrue(usernameTextField.exists)
        
        usernameTextField.tap()
        usernameTextField.typeText(username)
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordSecureTextField.exists)
        
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(password)
        
        app/*@START_MENU_TOKEN@*/.staticTexts["Sign In"]/*[[".buttons.matching(identifier: \"Sign In\").staticTexts[\"Sign In\"]",".staticTexts[\"Sign In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
