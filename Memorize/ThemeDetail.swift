//
//  ThemeDetail.swift
//  Memorize
//
//  Created by HannPC on 2024/9/1.
//

import SwiftUI

struct ThemeDetail: View {
    @Binding var theme: Theme
    
    var body: some View {
        Form {
            Section(header: Text("Theme Name")) {
                TextField("Name", text: $theme.name)
                
            }
            Section(header: Text("Emojis")) {
                TextField("Add Emojis Here", text: $theme.emojis)
            }
            Section(header: Text("Number of Card Pairs")) {
                TextField("Number of Pairs", text: Binding (
                    get: {
                        String(theme.numberOfPairs)
                    },
                    set: {
                        if let value = Int($0) {
                            theme.numberOfPairs = value
                        }
                    }
                ))
            }
            Section(header: Text("Card Color")) {
//                TextField("Color", text: $theme.color)
                Picker("Color", selection: $theme.color) {
                    Text("Orange").tag("orange")
                    Text("Mint").tag("mint")
                    Text("Blue").tag("blue")
                    Text("Black").tag("black")
                }
            }
        }
    }
}


#Preview {
    struct Preview: View {
        @State private var theme = ThemeStore().themes.first!
        var body: some View {
            ThemeDetail(theme: $theme)
        }
    }
    return Preview()
}
