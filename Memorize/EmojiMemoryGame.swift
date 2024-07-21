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
    // static property will be global but only in its namespace, use EmojiMemoryGame.emojis
    // Normally static properties goes first in the class
    // class only gets free init which has nothing(no argument), so still needs to be inited
    // make it private means only ViewModel can see it, otherwise View can directly access public model
    private(set) var theme : ThemeSelector.Theme
    private var numberOfPairs: Int
    @Published private var model: MemoryGame<String>
    
    init() {
        let randomThemeId = Int.random(in: 0..<5)
        numberOfPairs = 8
        theme = ThemeSelector().select(randomThemeId, nPair: numberOfPairs)
        model = EmojiMemoryGame.createMemorizeGame(theme: self.theme, nPair: self.numberOfPairs)
    }
    
    private static func createMemorizeGame(theme: ThemeSelector.Theme, nPair: Int) -> MemoryGame<String> {
        return MemoryGame(
            numberOfPairsOfCards: nPair) { pairIndex in
                if theme.emojiSet.indices.contains(pairIndex) && !theme.emojiSet.isEmpty {
                    // the list of emoji content is always not empty
                    return theme.emojiSet.randomElement()!
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
        default:
            return Color.black
        }
    }
    
    var score: Int {
        return model.score
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    // MARK: Intents
    func shuffle() {
        model.shuffle()
    }
    // intent function
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    func restart() {
        let randomThemeId = Int.random(in: 0..<5)
        numberOfPairs = 8
        theme = ThemeSelector().select(randomThemeId, nPair: numberOfPairs)
        model = EmojiMemoryGame.createMemorizeGame(theme: self.theme, nPair: theme.nPair ?? Int.random(in: 1..<theme.emojiSet.count))
        model.shuffle()
    }
}
