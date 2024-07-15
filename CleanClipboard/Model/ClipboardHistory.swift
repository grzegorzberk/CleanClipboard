//
//  ClipboardHistory.swift
//  CleanClipboard
//
//  Created by Grzegorz Berk on 15/07/2024.
//

import Foundation

struct ClipboardHistory: Identifiable, Codable {
    var id = UUID()
    var content: String
    var timestamp: Date
}
