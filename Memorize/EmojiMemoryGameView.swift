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
    @ObservedObject var game: EmojiMemoryGame
    private let aspectRatio: CGFloat = 2/3
    private let spacing: CGFloat = 8
    
    private func isGameFinish() -> Bool {
        for card in game.cards {
            if !card.isMatched {
                return false
            }
        }
        return true
    }
    
    var body: some View {
        VStack (spacing: spacing) {
            if isGameFinish() {
                Spacer()
                Text("Success!")
                    .font(.title2)
                score
                Spacer()
                Button("New Game") {
                    dealt = Set<Card.ID>()
                    game.restart()
                }
            } else {
                gameTable
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    var gameTable: some View {
        VStack {
            title
            score
        }
        cards.foregroundStyle(EmojiMemoryGame.intepretColor(game.theme.color))
        ZStack {
            HStack {
                Button("New Game") {
                    dealt = Set<Card.ID>()
                    game.restart()
                }
                
                Spacer()
                
                Button("Shuffle") {
                    withAnimation {
                        game.shuffle()
                    }
                }
            }
            deck.foregroundColor(EmojiMemoryGame.intepretColor(game.theme.color))
            
        }
        .padding()
        .frame(alignment: .top)
    }
    var score: some View {
        Text("Score: \(game.score)")
            .font(.title2)
            .animation(nil)
    }
    // Defines the title for the game
    var title: some View {
        Text("Memorize \(game.theme.name)!")
            .font(.title)
            .padding()
            .foregroundColor(EmojiMemoryGame.intepretColor(game.theme.color))
    }

    
    // Defines card part
    private var cards: some View {
        // lazyGrid will use space as less as it can, but HStack takes as much as it can
        return AspectVGrid(game.cards, aspectRatio: aspectRatio) { card in
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
        game.cards.filter { !isDealt($0) }
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
        for card in game.cards {
            withAnimation(.easeInOut(duration: 0.5).delay(delay)) {
                _ = dealt.insert(card.id)
            }
            delay += 0.15
        }
    }
    
    private let deckWidth: CGFloat = 50
    
    private func choose(_ card: Card) {
        withAnimation {
            let scoreBeforeChoose = game.score
            game.choose(card)
            let scoreChange = game.score - scoreBeforeChoose
            lastScoreChange = (scoreChange, causedByCardId: card.id)
        }
    }
    
    @State private var lastScoreChange = (0, causedByCardId: "")
    
    private func scoreChange(causedBy card: Card) -> Int {
        let (amount, id) = lastScoreChange
        return card.id == id ? amount: 0
    }
}

#Preview {
    EmojiMemoryGameView(game: EmojiMemoryGame(theme: ThemeStore().themes.first!))
}
