//
//  MemoryGame.swift
//  Memorize
//
//  Created by HannPC on 2024/7/13.
//

import Foundation


struct MemoryGame<CardContent> {
    // means settings of this var is private, accessing the var is public
    private(set) var cards: Array<Card>
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        // add numberOfPairsOfCards * 2 cards
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content: CardContent = cardContentFactory(pairIndex)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
    }
    
    func choose(_ card: Card) {
        
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    // nested struct
    struct Card  {
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        let content: CardContent // CardContent is a don't care for us, so do not(cannot) initialize
    }
}
