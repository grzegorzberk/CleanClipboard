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
    
    var body: some View {
        VStack {
            Text("Plain Text Clipboard")
                .font(.headline)
                .padding()
            
            Text(clipboardManager.clipboardContent)
                .padding()
                .border(Color.gray, width: 1)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(clipboardManager: ClipboardManager())
    }
}
