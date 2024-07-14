//
//  CleanClipboardTests.swift
//  CleanClipboardTests
//
//  Created by Grzegorz Berk on 14/07/2024.
//

import XCTest
@testable import CleanClipboard

class ClipboardManagerTests: XCTestCase {
    
    var clipboardManager: ClipboardManager!

    override func setUpWithError() throws {
        clipboardManager = ClipboardManager()
    }

    override func tearDownWithError() throws {
        clipboardManager = nil
    }

    func testClipboardMonitoring() throws {
        let testString = "Test string"
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(testString, forType: .string)
        
        clipboardManager.checkClipboard()
        
        let clipboardContent = NSPasteboard.general.string(forType: .string)
        XCTAssertEqual(clipboardContent, testString)
    }
    
    func testPlainTextClipboardUpdate() throws {
        let formattedString = "Formated string with <b>bold</b> text"
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(formattedString, forType: .string)
        
        clipboardManager.checkClipboard()
        
        let clipboardContent = NSPasteboard.general.string(forType: .string)
        XCTAssertEqual(clipboardContent, formattedString)
    }

}
