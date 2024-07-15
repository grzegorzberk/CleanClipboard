//
//  HistorySidebarView.swift
//  CleanClipboard
//
//  Created by Grzegorz Berk on 15/07/2024.
//

import SwiftUI

struct HistorySidebarView: View {
    @ObservedObject var clipboardManager: ClipboardManager
    
    var body: some View {
        List {
            ForEach(clipboardManager.groupedHistory().keys.sorted(by: >), id: \.self) {
                dateKey in Section(header: Text(dateKey)) {
                    let items = clipboardManager.groupedHistory()[dateKey] ?? []
                    ForEach(items) { item in
                        HStack {
                            Text(item.content)
                                .padding()
                                .border(Color.gray, width: 1)
                            Spacer()
                            Button(action: {
                                clipboardManager.copyToClipboard(content: item.content)
                            }) {
                                Text("Copy")
                            }
                            Button(action: {
                                if let index = clipboardManager.clipboardHistory.firstIndex(where: {$0.id == item.id}) { clipboardManager.removeFromHistory(at: index) }
                            }) {
                                Text("Delete")
                            }
                        }
                    }
                    .overlay(
                        Text("Records: \(items.count)")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .padding(.top, 5)
                            .frame(maxWidth: .infinity,
                                   alignment: .leading)
                            )
                }
            }
        }
        .navigationTitle("Clipboard History")
    }
}


struct HistorySidebarView_Previews: PreviewProvider {
    static var previews: some View {
        HistorySidebarView(clipboardManager: ClipboardManager())
    }
}
