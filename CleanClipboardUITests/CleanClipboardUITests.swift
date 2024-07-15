//
//  CleanClipboardUITests.swift
//  CleanClipboardUITests
//
//  Created by Grzegorz Berk on 14/07/2024.
//

import XCTest

class CleanClipboardUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    func testSidebarToogle() throws {
        let sidebarButton = app.buttons["sidebar.left"]
        XCTAssertTrue(sidebarButton.exists)
        sidebarButton.tap()
        
        let historySidebar = app.staticTexts["Clipboard History"]
        XCTAssertTrue(historySidebar.exists)
        
        sidebarButton.tap()
        XCTAssertFalse(historySidebar.exists)
    }
    
    func testAddToClipboardHistory() throws {
        let testString = "Test string"
        let pasteboard = NSPasteboard.general
        pasteboard.setString(testString, forType: .string)
        
        let historyItem = app.staticTexts[testString]
        expectation(for: NSPredicate(format: "exist == 1"), evaluatedWith: historyItem, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(historyItem.exists)
    }
    
    func testCopyFromClipboardHistory() throws {
        let testString = "Test String"
        let pasteboard = NSPasteboard.general
        pasteboard.setString(testString, forType: .string)
        
        let historyItem = app.staticTexts[testString]
        expectation(for: NSPredicate(format: "exist == 1"), evaluatedWith: historyItem, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(historyItem.exists)
        
        let copyButton = app.buttons["Copy"]
        XCTAssertTrue(copyButton.exists)
        copyButton.tap()
        
        XCTAssertEqual(pasteboard.string(forType: .string), testString)
    }
    
    func testRemoveFromClipboardHistory() throws {
        let testString = "Test String"
        let pasteboard = NSPasteboard.general
        pasteboard.setString(testString, forType: .string)
        
        let historyItem = app.staticTexts[testString]
        expectation(for: NSPredicate(format: "exist == 1"), evaluatedWith: historyItem, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(historyItem.exists)
        
        let deleteButton = app.buttons["Delete"]
        XCTAssertTrue(deleteButton.exists)
        deleteButton.tap()
        
        XCTAssertFalse(historyItem.exists)
    }
}
