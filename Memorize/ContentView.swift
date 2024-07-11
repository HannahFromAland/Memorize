//
//  ContentView.swift
//  Memorize
//
//  Created by HannPC on 2024/7/4.
//

import SwiftUI

struct ContentView: View {
    let emojis: [String] = ["🙂‍↔️", "🥰", "😇", "🙂‍↔️"]
    var body: some View {
        HStack {
            // Cannot do for loop here for emoji assignment
            ForEach(emojis.indices, id: \.self) { index in
                CardView(content: emojis[index])
            }
        }
        .padding()
        .foregroundColor(.mint)
    }
}

struct CardView: View {
    let content: String
    // @State will create a pointer for isFaceUp which will never change, so the content it is pointing to can change
    @State var isFaceUp = true
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 25)
            if isFaceUp {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(content).font(.largeTitle)
            } else {
                base.fill()
            }
        }
        .onTapGesture {
            // views are immutable
            // isFaceUp = !isFaceUp
            isFaceUp.toggle()
        }
    }
}

#Preview {
    ContentView()
}
