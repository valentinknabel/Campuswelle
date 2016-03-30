//
//  CampuswelleUITests.swift
//  CampuswelleUITests
//
//  Created by Valentin Knabel on 30.03.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

import XCTest

class CampuswelleUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        snapshot("01Screenshot")
        tablesQuery.cells.containingType(.StaticText, identifier:"S70: Zeichentrick, Naturfakten, Wissen vor 2, Zitat der Woche").buttons["ios7 play"].tap()
        snapshot("02Screenshot")
        app.buttons["ios7 arrow down"].tap()
        snapshot("03Screenshot")
        tablesQuery.staticTexts["S69: Medinetz, Achtung Frage, Kinorubrik, Zitat der Woche"].tap()
        snapshot("04Screenshot")
        
    }
    
}
