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
    private let aspectRatio: CGFloat = 2/3
    
    var body: some View {
        VStack (spacing: 10){
            VStack {
                title
                Text("Score: \(viewModel.score)")
                    .font(.title2)
            }
            cards
                .animation(.default, value: viewModel.cards)
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
        Text("Memorize \(viewModel.theme.name)!")
            .font(.title)
            .padding()
            .foregroundColor(Color.gray)
    }

    
    // Defines card part
    @ViewBuilder
    private var cards: some View {
        // implicit return
        // lazyGrid will use space as less as it can, but HStack takes as much as it can
        let colorList = viewModel.theme.color.map { EmojiMemoryGame.intepretColor($0)}
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio) { card in
            CardView(card, colorList: colorList)
                .padding(4)
                .onTapGesture {
                    viewModel.choose(card)
                }
        }
        .foregroundColor(colorList.first)
    }
    
    // Define each card, which has the state of face up or face down, with emoji as content on the card
    struct CardView: View {
        let card: MemoryGame<String>.Card
        let colorList: [Color]
        
        init(_ card: MemoryGame<String>.Card, colorList: [Color]) {
            self.card = card
            self.colorList = colorList
        }
        // @State will create a pointer for isFaceUp which will never change, so the content it is pointing to can change
        @State var isFaceUp = false
        var body: some View {
            ZStack {
                let base = RoundedRectangle(cornerRadius: 12)
                Group {
                    if colorList.count > 1 {
                        base.fill(Gradient(colors: colorList))
                    } else {
                        base.fill(.white)
                    }
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
