//
//  AppDelegate.swift
//  CleanClipboard
//
//  Created by Grzegorz Berk on 14/07/2024.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var clipboardManager: ClipboardManager?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        clipboardManager = ClipboardManager()
    }
}
