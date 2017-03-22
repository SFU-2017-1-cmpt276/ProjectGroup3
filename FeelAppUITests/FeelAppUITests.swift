//
//  FeelAppUITests.swift
//  FeelAppUITests
//
//  Created by Deepak Venkatesh on 2017-03-01.
//  Copyright © 2017 CMPT276. All rights reserved.

//Test UI interaction inside the testExample function

import XCTest


class FeelAppUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func testExample() {
        XCUIDevice.shared().orientation = .faceUp
        //Test to see login works correctly
        let app = XCUIApplication()
        let emailTextField = app.textFields["EMAIL"]
        emailTextField.tap()
        XCUIDevice.shared().orientation = .portrait
        app.keys["ampersand"].tap()
        XCUIDevice.shared().orientation = .portrait
        app.keys["\""].tap()
        
        let moreKey = app.keys["more"]
        moreKey.tap()
        XCUIDevice.shared().orientation = .portrait
        emailTextField.typeText("Ckl41")
        moreKey.tap()
        
        let moreKey2 = app.keys["more"]
        moreKey2.tap()
        emailTextField.typeText("@")
        moreKey.tap()
        moreKey.tap()
        emailTextField.typeText("sfu")
        moreKey2.tap()
        moreKey2.tap()
        emailTextField.typeText(".")
        moreKey.tap()
        emailTextField.typeText("caa")
        
        let passwordSecureTextField = app.secureTextFields["PASSWORD"]
        passwordSecureTextField.tap()
        emailTextField.tap()
        
        let deleteKey = app.keys["delete"]
        deleteKey.tap()
        deleteKey.tap()
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("123456")
        app.buttons["LOG IN"].tap()
        XCUIDevice.shared().orientation = .faceUp
        XCUIDevice.shared().orientation = .portrait
        
        //Test to see that user is able to select and post emotion
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.buttons["Happy"].tap()
        XCUIDevice.shared().orientation = .faceUp
        app.keys["H"].tap()
        
        let textView = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .textView).element
        textView.typeText("Haappy ")
        app.keys["a"].swipeRight()
        textView.typeText("alm")
        app.keys["o"].swipeLeft()
        textView.typeText("ost ")
        app.keys[";"].swipeRight()
        textView.typeText(" Donne  276")
        app.buttons["Post and Share"].tap()
        app.buttons["Newsfeed"].tap()
        
        //Test that user can view history view
        let leftarrowiconButton = app.buttons["leftArrowIcon"]
        leftarrowiconButton.tap()
        app.buttons["calendarIcon"].tap()
        collectionViewsQuery.cells.containing(.button, identifier:"4:33 pm").children(matching: .other).element(boundBy: 0).tap()
        collectionViewsQuery.cells.containing(.button, identifier:"4:01 pm").children(matching: .other).element(boundBy: 0).tap()
        app.buttons["pieChartIcon"].tap()
        leftarrowiconButton.tap()
        app.windows["SBSwitcherWindow"].children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.tap()
        app.buttons["linksIcon"].tap()
        
        //Test that links view loads
        let sfuHealthyCampusCommunityStaticText = app.tables.staticTexts["SFU Healthy Campus Community"]
        sfuHealthyCampusCommunityStaticText.tap()
        sfuHealthyCampusCommunityStaticText.swipeDown()
        leftarrowiconButton.tap()
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}
