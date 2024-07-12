//
//  ContentView.swift
//  Memorize
//
//  Created by HannPC on 2024/7/4.
//

import SwiftUI

struct ContentView: View {
    @State var emojis: [String] = ["🙂‍↔️", "🥰", "😇", "🥹", "🙂‍↔️", "🥰", "😇", "🥹","🙂‍↔️", "🥰", "😇", "🥹","🙂‍↔️", "🥰", "😇", "🥹"]
    let emoji: [String] = ["🙂‍↔️", "🥰", "😇", "🥹", "🙂‍↔️", "🥰", "😇", "🥹","🙂‍↔️", "🥰", "😇", "🥹","🙂‍↔️", "🥰", "😇", "🥹"]
    let emojiAnimal: [String] = ["🐶","🐱","🐭","🐹","🐰","🐻","🦊","🐻‍❄️","🐨","🐯","🦁","🐶","🐱","🐭","🐹","🐰","🐻","🦊","🐻‍❄️","🐨","🐯","🦁"]
    let emojiBakery: [String] = ["🥯","🍞","🥖","🥨","🥐","🥪","🍔","🥯","🍞","🥖","🥨","🥐","🥪","🍔"]
    
    @State var cardCount: Int = 4
    
    var body: some View {
        VStack (spacing: 10){
            title
            cardAdjusters
            ScrollView{
                cards
            }
            cardTheme
        }
    }
    
    var title: some View {
        Text("Memorize!")
            .font(.title)
            .padding()
            .foregroundColor(.mint)
    }
    
    var cards: some View {
        // implicit return
        // lazyGrid will use space as less as it can, but HStack takes as much as it can
        LazyVGrid (columns: [GridItem(.adaptive(minimum: 80))]){
            // Cannot do for loop here for emoji assignment
            ForEach(0..<cardCount, id: \.self) { index in
                CardView(content: emojis[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .padding()
        .foregroundColor(.mint)
    }
    
    var cardAdjusters: some View {
        HStack {
            cardRemover
            Spacer()
            cardAdder
        }
        .padding()
        .imageScale(.medium)
        .font(.title)
        .foregroundColor(.mint)
    }
    
    var cardTheme: some View {
        HStack{
            Spacer()
            cardThemeSelector(theme: "Emoji", symbol: "smiley")
            Spacer()
            cardThemeSelector(theme: "Animal", symbol: "pawprint")
            Spacer()
            cardThemeSelector(theme: "Bakery", symbol: "fork.knife")
            Spacer()
        }
        .padding()
        .imageScale(.medium)
        .font(.title)
        .foregroundColor(.gray)
    }
    
    func cardThemeSelector(theme: String, symbol: String) -> some View {
        Button(action: {
            switch theme {
            case "Bakery":
                emojis = emojiBakery.shuffled()
            case "Animal":
                emojis = emojiAnimal.shuffled()
            case "Emoji":
                emojis = emoji.shuffled()
            default:
                emojis = emoji.shuffled()
            }
        }, label: {
            VStack{
                Image(systemName: symbol)
                Text(theme).font(.footnote)
            }
        })
    }
    
    func cardCountAdjuster(by offset: Int, symbol: String) ->
    some View {
        let text: String = if offset > 0 {
            "Add Card"
        } else {
            "Remove Card"
        }
        return Button(action: {
            cardCount += offset
        }, label: {
            VStack{
                Image(systemName: symbol)
                Text(text).font(.footnote)
            }
            
        })
        .disabled(cardCount + offset < 1 || cardCount + offset > emojis.count)
    }
    
    var cardAdder: some View {
        cardCountAdjuster(by: +1, symbol: "rectangle.stack.fill.badge.plus")
    }
    
    var cardRemover: some View {
        cardCountAdjuster(by: -1, symbol: "rectangle.stack.fill.badge.minus")
    }
}

struct CardView: View {
    let content: String
    // @State will create a pointer for isFaceUp which will never change, so the content it is pointing to can change
    @State var isFaceUp = false
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(content).font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            base.fill().opacity(isFaceUp ? 0 : 1)
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
