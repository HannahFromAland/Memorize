//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by HannPC on 2024/7/13.
//
//
//@State var emojis: [String] = ["🙂‍↔️", "🥰", "😇", "🥹", "🙂‍↔️", "🥰", "😇", "🥹","🙂‍↔️", "🥰", "😇", "🥹","🙂‍↔️", "🥰", "😇", "🥹"]
//let emoji: [String] = ["🙂‍↔️", "🥰", "😇", "🥹", "🙂‍↔️", "🥰", "😇", "🥹","🙂‍↔️", "🥰", "😇", "🥹","🙂‍↔️", "🥰", "😇", "🥹"]
//let emojiAnimal: [String] = ["🐶","🐱","🐭","🐹","🐰","🐻","🦊","🐻‍❄️","🐨","🐯","🦁","🐶","🐱","🐭","🐹","🐰","🐻","🦊","🐻‍❄️","🐨","🐯","🦁"]
//let emojiBakery: [String] = ["🥯","🍞","🥖","🥨","🥐","🥪","🍔","🥯","🍞","🥖","🥨","🥐","🥪","🍔"]

import SwiftUI
// ViewModel is part of the UI, but not going to be creating views/UI

class EmojiMemoryGame: ObservableObject {
    // static property will be global but only in its namespace, use EmojiMemoryGame.emojis
    // Normally static properties goes first in the class
    private static let emojis = ["🙂‍↔️", "🥰", "😇", "🥹", "😉", "🤨", "😚", "🤩","🥳", "😎", "🙂‍↕️"]
    // class only gets free init which has nothing(no argument), so still needs to be inited
    
    private static func createMemorizeGame() -> MemoryGame<String> {
        return MemoryGame(
            numberOfPairsOfCards: 6) { pairIndex in
                if emojis.indices.contains(pairIndex) {
                    return emojis[pairIndex]
                } else {
                    return "😱"
                }
        }
    }
    
    // make it private means only ViewModel can see it, otherwise View can directly access public model
    @Published private var model = createMemorizeGame()
    
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
}
