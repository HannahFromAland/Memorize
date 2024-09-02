//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by HannPC on 2024/7/13.
//
//

import SwiftUI
// ViewModel is part of the UI, but not going to be creating views/UI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    // static property will be global but only in its namespace, use EmojiMemoryGame.emojis
    // Normally static properties goes first in the class
    // class only gets free init which has nothing(no argument), so still needs to be inited
    // make it private means only ViewModel can see it, otherwise View can directly access public model
    private(set) var theme : Theme
    private var numberOfPairs: Int
    @Published private var model: MemoryGame<String>
    
    init(theme: Theme) {
        self.theme = theme
        numberOfPairs = theme.numberOfPairs
        model = EmojiMemoryGame.createMemorizeGame(theme: self.theme, nPair: theme.numberOfPairs)
        model.shuffle()
    }
    
    private static func createMemorizeGame(theme: Theme, nPair: Int) -> MemoryGame<String> {
        return MemoryGame(
            numberOfPairsOfCards: nPair) { pairIndex in
                if theme.emojis.count > pairIndex {
                    // the list of emoji content is always not empty
                    return String(theme.emojis.randomElement()!)
                } else {
                    return "😱"
                }
        }
    }
    
    public static func intepretColor(_ colorName: String) -> Color {
        switch colorName {
        case "red":
            return Color.red
        case "yellow":
            return Color.yellow
        case "blue":
            return Color.blue
        case "mint":
            return Color.mint
        case "gray":
            return Color.gray
        case "brown":
            return Color.brown
        case "green":
            return Color.green
        case "pink":
            return Color.pink
        case "purple":
            return Color.purple
        case "orange":
            return Color.orange
        default:
            return Color.black
        }
    }
    
    var score: Int {
        return model.score
    }
    
    var cards: Array<Card> {
        return model.cards
    }
    // MARK: Intents
    func shuffle() {
        model.shuffle()
    }
    // intent function
    func choose(_ card: Card) {
        model.choose(card)
    }
    func restart() {
        model = EmojiMemoryGame.createMemorizeGame(theme: self.theme, nPair: self.theme.numberOfPairs)
        model.shuffle()
    }
}
