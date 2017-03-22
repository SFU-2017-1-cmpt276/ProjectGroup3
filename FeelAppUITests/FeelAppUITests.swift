//
//  FeelAppUITests.swift
//  FeelAppUITests
//
//  Created by Deepak Venkatesh on 2017-03-01.
//  Copyright © 2017 CMPT276. All rights reserved.
//

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
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }
    
    //Test to see login works correctly
    func loginTest() {
        
    }
    
    //Test to see that user is able to select and post emotion
    func emotionSelect() {
        
        
    }
    
    //Test that user can view history view
    func historyView() {
        
        
    }
    
    //Stress test - Random UI interaction
    func stressTest(){
        
    }
    
}
