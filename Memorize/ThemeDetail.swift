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
                Stepper(
                    value: $theme.numberOfPairs,
                    in: 1...theme.emojis.count/2,
                    step: 1
                ) {
                    Text("Total card pairs: \(theme.numberOfPairs)")
                }
            }
            Section(header: Text("Card Color")) {
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
