//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by HannahFromAland on 2024/7/4.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    // View is stateless, constantly showing what being represent in Model
    // View is declared （not imperative)
    // View is reactive, reacting to all changes in Model
    
    // Never let ObservedObject equals to anything
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack (spacing: 10){
            title
            ScrollView{
                cards
                    .animation(.default, value: viewModel.cards)
            }
            HStack{
                Button("Shuffle") {
                    viewModel.shuffle()
                }
                Spacer()
                Button("New Game") {
                    viewModel.restart()
                }
            }
            .padding()
        }
    }
    
    // Defines the title for the game
    var title: some View {
        Text("Memorize!")
            .font(.title)
            .padding()
            .foregroundColor(Color.gray)
    }

    
    // Defines card part
    var cards: some View {
        // implicit return
        // lazyGrid will use space as less as it can, but HStack takes as much as it can
        let themeColor = EmojiMemoryGame.intepretColor(viewModel.theme.color)
        return LazyVGrid (columns: [GridItem(.adaptive(minimum: 100), spacing: 0)], spacing: 0){
            // Cannot do for loop here for emoji assignment
            ForEach(viewModel.cards) { card in
                CardView(card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(2)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
            }
        }
        .padding()
        .foregroundColor(themeColor)
    }
    
    // Define each card, which has the state of face up or face down, with emoji as content on the card
    struct CardView: View {
        let card: MemoryGame<String>.Card
        
        init(_ card: MemoryGame<String>.Card) {
            self.card = card
        }
        // @State will create a pointer for isFaceUp which will never change, so the content it is pointing to can change
        @State var isFaceUp = false
        var body: some View {
            ZStack {
                let base = RoundedRectangle(cornerRadius: 12)
                Group {
                    base.fill(.white)
                    base.strokeBorder(lineWidth: 2)
                    Text(card.content)
                        .font(.system(size:60))
                        .minimumScaleFactor(0.01)
                        .aspectRatio(1, contentMode: .fit)
                }
                .opacity(card.isFaceUp ? 1 : 0)
                base.fill().opacity(card.isFaceUp ? 0 : 1)
            }
            .opacity(card.isMatched ? 0 : 1)
        }
    }
}

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
