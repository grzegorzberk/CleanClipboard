//
//  ClipboardManager.swift
//  CleanClipboard
//
//  Created by Grzegorz Berk on 14/07/2024.
//

import Cocoa

class ClipboardManager: ObservableObject {
    @Published var clipboardContent: String = ""
    @Published var clipboardHistory: [ClipboardHistory] = []
    
    private var timer: Timer?
    private var lastClipboardContent: String?
    let historyKey = "clipboardHistory"
    
    init () {
        loadHistory()
        startMonitoring()
    }
    
    func startMonitoring() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkClipboard), userInfo: nil, repeats: true)
    }
    
    @objc func checkClipboard() {
        if let clipboardContent = NSPasteboard.general.string(forType: .string) {
            if clipboardContent != lastClipboardContent {
                let plainText = clipboardContent
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(plainText, forType: .string)
                print("Clipboard updated with plain text.")
                DispatchQueue.main.async {
                    self.clipboardContent = plainText
                }
                lastClipboardContent = plainText
            }
        }
    }
    
    func addToHistory(_ content: String) {
        let newEntry = ClipboardHistory(content: content, timestamp: Date())
        clipboardHistory.append(newEntry)
        saveHistory()
    }
    
    func removeFromHistory(at index: Int) {
        clipboardHistory.remove(at: index)
        saveHistory()
    }
    
    func copyToClipboard(content: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(content, forType: .string)
        clipboardContent = content
    }
    
    func saveHistory() {
        if let encodedHistory = try? JSONEncoder().encode(clipboardContent) {
            UserDefaults.standard.set(encodedHistory, forKey: historyKey)
        }
    }
    
    func loadHistory() {
        if let savedHistory = UserDefaults.standard.data(forKey: historyKey),
           let decodedHistory = try? JSONDecoder().decode([ClipboardHistory].self, from: savedHistory) {
            clipboardHistory = decodedHistory
        }
    }
    
    func groupedHistory() -> [String: [ClipboardHistory]] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let grouped = Dictionary(grouping: clipboardHistory) { history -> String in
            return formatter.string(from: history.timestamp)
        }
        
        return grouped
    }
}
