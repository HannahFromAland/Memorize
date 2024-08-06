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
    typealias Card = MemoryGame<String>.Card
    @ObservedObject var viewModel: EmojiMemoryGame
    private let aspectRatio: CGFloat = 2/3
    private let spacing: CGFloat = 10
    
    var body: some View {
        VStack (spacing: spacing){
            VStack {
                title
                score
            }
            cards.foregroundColor(EmojiMemoryGame.intepretColor(viewModel.theme.color))
            ZStack {
                HStack {
                    Button("New Game") {
                        viewModel.restart()
                    }
                    
                    Spacer()
                    
                    Button("Shuffle") {
                        withAnimation {
                            viewModel.shuffle()
                        }
                    }
                }
                deck.foregroundColor(EmojiMemoryGame.intepretColor(viewModel.theme.color))
            }
            .padding()
            .frame(alignment: .center)
        }
    }
    var score: some View {
        Text("Score: \(viewModel.score)")
            .font(.title2)
            .animation(nil)
    }
    // Defines the title for the game
    var title: some View {
        Text("Memorize \(viewModel.theme.name)!")
            .font(.title)
            .padding()
            .foregroundColor(Color.gray)
    }

    
    // Defines card part
    private var cards: some View {
        // lazyGrid will use space as less as it can, but HStack takes as much as it can
        return AspectVGrid(viewModel.cards, aspectRatio: aspectRatio) { card in
            if isDealt(card) {
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .padding(4)
                    .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                    .onTapGesture {
                        choose(card)
                    }
            }
        }
    }
    
    @State private var dealt = Set<Card.ID>()
    
    private func isDealt(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }
    
    private var undealtCards: [Card] {
        viewModel.cards.filter { !isDealt($0) }
    }
    
    @Namespace private var dealingNamespace
    
    private var deck: some View {
        ZStack {
            ForEach(undealtCards) { card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: deckWidth, height: deckWidth / aspectRatio)
        .onTapGesture {
            deal()
        }
    }
    
    private func deal() {
        // deal the cards
        var delay: TimeInterval = 0
        for card in viewModel.cards {
            withAnimation(.easeInOut(duration: 0.5).delay(delay)) {
                _ = dealt.insert(card.id)
            }
            delay += 0.15
        }
    }
    
    private let deckWidth: CGFloat = 50
    
    private func choose(_ card: Card) {
        withAnimation {
            let scoreBeforeChoose = viewModel.score
            viewModel.choose(card)
            let scoreChange = viewModel.score - scoreBeforeChoose
            lastScoreChange = (scoreChange, causedByCardId: card.id)
           // print("choose:: scoreChange: \(scoreChange), causedByCardid: \(card.id)")
        }
    }
    
    @State private var lastScoreChange = (0, causedByCardId: "")
    
    private func scoreChange(causedBy card: Card) -> Int {
        let (amount, id) = lastScoreChange
        print("scoreChange:: \(card.id == id ? amount: 0)")
        return card.id == id ? amount: 0
    }
}

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
