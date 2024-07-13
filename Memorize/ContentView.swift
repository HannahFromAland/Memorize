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
    
    // Theme color will be changed through theme selection
    @State var themeColor: Color = .mint
    
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
    
    // Defines the title for the game
    var title: some View {
        Text("Memorize!")
            .font(.title)
            .padding()
            .foregroundColor(.gray)
    }
    
    // Defines card part
    var cards: some View {
        let minimum: CGFloat
        if cardCount <= 6 {
            minimum = 100
        } else if cardCount <= 12 {
            minimum = 80
        } else if cardCount <= 20{
            minimum = 60
        } else {
            minimum = 40
        }
        // implicit return
        // lazyGrid will use space as less as it can, but HStack takes as much as it can
        return LazyVGrid (columns: [GridItem(.adaptive(minimum: minimum))]){
            // Cannot do for loop here for emoji assignment
            ForEach(0..<cardCount, id: \.self) { index in
                CardView(content: emojis[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .padding()
        .foregroundColor(themeColor)
    }
    
    // Define each card, which has the state of face up or face down, with emoji as content on the card
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
    
    // Defines control button for adding and removing cards
    var cardAdjusters: some View {
        HStack {
            cardRemover
            Spacer()
            cardAdder
        }
        .padding()
        .imageScale(.medium)
        .font(.title)
        .foregroundColor(.gray)
    }
    
    // Defines card theme part
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
    
    // Emoji shown list will be shuffled once changing the theme
    func cardThemeSelector(theme: String, symbol: String) -> some View {
        Button(action: {
            switch theme {
            case "Bakery":
                emojis = emojiBakery.shuffled()
                themeColor = .orange
                cardCount = Int.random(in: 0..<emojis.count)
            case "Animal":
                emojis = emojiAnimal.shuffled()
                themeColor = .brown
                cardCount = Int.random(in: 0..<emojis.count)
            case "Emoji":
                emojis = emoji.shuffled()
                themeColor = .yellow
                cardCount = Int.random(in: 0..<emojis.count)
            default:
                emojis = emoji.shuffled()
                cardCount = Int.random(in: 0..<emojis.count)
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

#Preview {
    ContentView()
}
