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
        
        clipboardManager.clipboardHistory.removeAll()
        UserDefaults.standard.removeObject(forKey: clipboardManager.historyKey)
    }

    override func tearDownWithError() throws {
        UserDefaults.standard.removeObject(forKey: clipboardManager.historyKey)
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

    func testAddToHistory() throws {
        let testString = "Test string"
        clipboardManager.addToHistory(testString)
        
        XCTAssertEqual(clipboardManager.clipboardHistory.count, 1)
        XCTAssertEqual(clipboardManager.clipboardHistory.first?.content, testString)
    }
    
    func testRemoveFromHistory() throws {
        let testString = "Test String"
        clipboardManager.addToHistory(testString)
        XCTAssertEqual(clipboardManager.clipboardHistory.count, 1)
        
        clipboardManager.removeFromHistory(at: 0)
        XCTAssertEqual(clipboardManager.clipboardHistory.count, 0)
    }
    
    func testCopyToClipboard() throws {
        let testString = "Test string"
        clipboardManager.copyToClipboard(content: testString)
        
        let clipboardContent = NSPasteboard.general.string(forType: .string)
        XCTAssertEqual(clipboardContent, testString)
        XCTAssertEqual(clipboardManager.clipboardContent, testString)
    }
    
    func testSaveHistory() throws {
        let testString = "Test string"
        clipboardManager.addToHistory(testString)
        clipboardManager.saveHistory()
            
        guard let savedHistory = UserDefaults.standard.data(forKey: clipboardManager.historyKey) else {
                XCTFail("Failed to retrieve saved history")
                return
            }
            
        do {
                let decodedHistory = try JSONDecoder().decode([ClipboardHistory].self, from: savedHistory)
                XCTAssertEqual(decodedHistory.count, 1)
                XCTAssertEqual(decodedHistory.first?.content, testString)
            } catch {
                XCTFail("Failed to decode saved history: \(error)")
        }
    }
    
    func testLoadHistory() throws {
        let testString = "Test string"
        let historyItem = ClipboardHistory(content: testString, timestamp: Date())
        clipboardManager.clipboardHistory = [historyItem]
        clipboardManager.saveHistory()
        
        clipboardManager.clipboardHistory.removeAll()
        XCTAssertEqual(clipboardManager.clipboardHistory.count, 0)
        
        clipboardManager.loadHistory()
        XCTAssertEqual(clipboardManager.clipboardHistory.count, 1)
        XCTAssertEqual(clipboardManager.clipboardHistory.first?.content, testString)
    }
    
    func testGroupedHistory() throws {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let date1 = formatter.date(from: "2023-07-14")!
        let date2 = formatter.date(from: "2023-07-15")!
        
        let historyItem1 = ClipboardHistory(content: "Test1", timestamp: date1)
        let historyItem2 = ClipboardHistory(content: "Test2", timestamp: date1)
        let historyItem3 = ClipboardHistory(content: "Test3", timestamp: date2)
        
        clipboardManager.clipboardHistory = [historyItem1, historyItem2, historyItem3]
        
        let groupedHistory = clipboardManager.groupedHistory()
        XCTAssertEqual(groupedHistory["2023-07-14"]?.count, 2)
        XCTAssertEqual(groupedHistory["2023-07-15"]?.count, 1)
    }
    
    func testEmptyClipboard() throws {
        NSPasteboard.general.clearContents()
        clipboardManager.checkClipboard()
        
        XCTAssertEqual(clipboardManager.clipboardContent, "")
        XCTAssertEqual(clipboardManager.clipboardHistory.count, 0)
    }
    
    func testRemoveAllHistory() throws {
        let testString1 = "Test string 1"
        let testString2 = "Test string 2"
        clipboardManager.addToHistory(testString1)
        clipboardManager.addToHistory(testString2)
        XCTAssertEqual(clipboardManager.clipboardHistory.count, 2)
        
        clipboardManager.clipboardHistory.removeAll()
        clipboardManager.saveHistory()
        XCTAssertEqual(clipboardManager.clipboardHistory.count, 0)
        
        let savedHistory = UserDefaults.standard.data(forKey: clipboardManager.historyKey)
        XCTAssertNotNil(savedHistory)
        
        if let savedHistory = savedHistory,
           let decodedHistory = try? JSONDecoder().decode([ClipboardHistory].self, from: savedHistory) {
            XCTAssertEqual(decodedHistory.count, 0)
        } else {
            XCTFail("Failed to decoded saved history")
        }
    }
    
    func testPerformance() throws {
        self.measure {
            clipboardManager.clipboardHistory.removeAll()
            UserDefaults.standard.removeObject(forKey: clipboardManager.historyKey)
            for i in 0..<1000 {
                clipboardManager.addToHistory("Test string \(i)")
            }
            XCTAssertEqual(clipboardManager.clipboardHistory.count, 1000)
        }
    }
    
    func testDateFormatting() throws {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let data = formatter.string(from: Date())
        
        let testString = "Test string"

        clipboardManager.addToHistory(testString)
        let groupedHistory = clipboardManager.groupedHistory()
        
        XCTAssertNotNil(groupedHistory[data])
        XCTAssertEqual(groupedHistory[data]?.count, 1)
    }
}
