//
//  ClipboardManager.swift
//  CleanClipboard
//
//  Created by Grzegorz Berk on 14/07/2024.
//

import Cocoa

class ClipboardManager {
    var timer: Timer?
    var lastClipboardContent: String?
    
    init () {
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
                lastClipboardContent = plainText
            }
        }
    }
}
