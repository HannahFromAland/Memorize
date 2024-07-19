//
//  MemoryGame.swift
//  Memorize
//
//  Created by HannPC on 2024/7/13.
//

import Foundation


struct MemoryGame<CardContent> where CardContent: Equatable {
    // means settings of this var is private, accessing the var is public
    private(set) var cards: Array<Card>
    
    private(set) var score: Int
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        // add numberOfPairsOfCards * 2 cards
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content: CardContent = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex + 1)a"))
            cards.append(Card(content: content, id: "\(pairIndex + 1)b"))
        }
        score = 0
    }
    
    var currFaceUpCard: Int? {
        get {
            // get the currFaceUpCard if there is only one card facing up
            return cards.indices.filter { index in cards[index].isFaceUp && !cards[index].isMatched }.only}
        set {
            // getting all other cards to be faced down
            cards.indices.forEach { index in
                cards[index].isFaceUp = (index == newValue) || (cards[index].isMatched) ? true : false
            }
        }
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                // first check the pre flip scenario
                if let potentialFaceUpCard = currFaceUpCard {
                    if cards[potentialFaceUpCard].content == cards[chosenIndex].content {
                        cards[potentialFaceUpCard].isMatched = true
                        cards[chosenIndex].isMatched = true
                        score += 2
                    } else {
                        // a mismatch
                        if cards[potentialFaceUpCard].isSeen {
                            score -= 1
                        }
                        if cards[chosenIndex].isSeen {
                            score -= 1
                        }
                        cards[potentialFaceUpCard].isSeen = true
                        cards[chosenIndex].isSeen = true
                    }
                } else {
                    // currFaceUpCard is nil, either there is no face up cards or the two facing up cards are not matching
                    currFaceUpCard = chosenIndex
                }
                // flip the card to be faced up
                cards[chosenIndex].isFaceUp = true
                
            }
        }
    }

    mutating func shuffle() {
        cards.shuffle()
    }
    
    mutating func restart() {
        cards.shuffle()
        cards.indices.forEach { index in
            cards[index].isMatched = false
            cards[index].isFaceUp = false
            cards[index].isSeen = false
        }
    }
    
    // nested struct
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var debugDescription: String {
            return "\(id): \(content) is \(isFaceUp ? "up" : "down"), \(isMatched ? "matched" : "not matched yet");"
        }
        
        
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var isSeen: Bool = false
        let content: CardContent // CardContent is a don't care for us, so do not(cannot) initialize
        
        var id: String // for Identifiable
    }
}

extension Array {
    var only: Element? {
        return count == 1 ? first : nil
    }
}
