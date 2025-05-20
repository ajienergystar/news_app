//
//  NewsAppUITests.swift
//  NewsUITests
//
//  Created by mac on 19/5/25.
//

import XCTest

class NewsAppUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testCategoryNavigation() {
        // Verify initial screen
        XCTAssertTrue(app.navigationBars["News Categories"].exists)
        
        // Tap on a category
        app.buttons["technology"].tap()
        
        // Verify navigation to sources
        XCTAssertTrue(app.navigationBars["Technology"].exists)
        
        // Tap on a source
        let firstSource = app.staticTexts.element(boundBy: 1)
        if firstSource.exists {
            firstSource.tap()
            
            // Verify navigation to articles
            XCTAssertTrue(app.navigationBars["Articles"].exists)
            
            // Tap on an article
            let firstArticle = app.staticTexts.element(boundBy: 1)
            if firstArticle.exists {
                firstArticle.tap()
                
                // Verify web view is presented
                XCTAssertTrue(app.otherElements["URL"].exists)
            }
        }
    }
    
    func testSearchFunctionality() {
        // Navigate to sources
        app.buttons["technology"].tap()
        
        // Tap search bar
        let searchBar = app.searchFields["Search..."]
        searchBar.tap()
        searchBar.typeText("tech")
        
        // Verify search results
        XCTAssertGreaterThan(app.staticTexts.count, 0)
    }
}
