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
    private(set) var startTime: Date? = Date.now
    private(set) var timeInterval: TimeInterval
    private(set) var isPause = false
    
    // create a time-based score, initially each match add 20 seconds, and a mismatch -10 seconds, initial total score is 10 * nPair and ticked down
    private(set) var score: Int
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        // add numberOfPairsOfCards * 2 cards
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content: CardContent = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex + 1)a"))
            cards.append(Card(content: content, id: "\(pairIndex + 1)b"))
        }
        score = numberOfPairsOfCards * 10
        timeInterval = TimeInterval(0)
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
            if !isPause && !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                // first check the pre flip scenario
                if let potentialFaceUpCard = currFaceUpCard {
                    if cards[potentialFaceUpCard].content == cards[chosenIndex].content {
                        cards[potentialFaceUpCard].isMatched = true
                        cards[chosenIndex].isMatched = true
                        score += 20
                    } else {
                        // a mismatch
                        if cards[potentialFaceUpCard].isSeen {
                            score -= 10
                        }
                        if cards[chosenIndex].isSeen {
                            score -= 10
                        }
                        cards[potentialFaceUpCard].isSeen = true
                        cards[chosenIndex].isSeen = true
                    }
                    if let start = startTime {
                        score -= Int(Date.now.timeIntervalSince(start))
                    }
                    startTime = Date.now
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
        score = cards.count * 5
        startTime = Date.now
    }
    
    mutating func pause() {
        if isPause {
            startTime = Date.now - timeInterval
            isPause = false
        } else {
            if let start = startTime {
                timeInterval = Date().timeIntervalSince(start)
            }
            startTime = nil
            isPause = true
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
