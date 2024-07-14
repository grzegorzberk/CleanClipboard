//
//  CleanClipboardApp.swift
//  CleanClipboard
//
//  Created by Grzegorz Berk on 14/07/2024.
//

import SwiftUI

@main
struct CleanClipboardApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
