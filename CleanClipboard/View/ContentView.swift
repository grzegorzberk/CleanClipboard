//
//  ContentView.swift
//  CleanClipboard
//
//  Created by Grzegorz Berk on 14/07/2024.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @ObservedObject var clipboardManager: ClipboardManager
    @State private var showSidebar = false
    
    var body: some View {
        VStack {
            Text("Plain Text Clipboard")
                .font(.headline)
                .padding()
            
            Spacer()
            
            Text(clipboardManager.clipboardContent)
                .padding()
                .border(Color.gray, width: 1)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button (action: {
                    showSidebar.toggle()
                }) {
                    Image(systemName: "sidebar.left")
                }
            }
        }
        
        if showSidebar {
            HistorySidebarView(clipboardManager: clipboardManager)
                .frame(minWidth: 300)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(clipboardManager: ClipboardManager())
    }
}
