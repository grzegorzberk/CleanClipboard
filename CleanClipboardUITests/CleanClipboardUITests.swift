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
    
}
